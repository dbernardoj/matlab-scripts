%% LDA AND QDA CLASSIFIERS FOR BCI DATA
% DESCRIPTION HERE...

%% ABOUT
% * Author: Iraquitan Cordeiro Filho
% * Company: Institudo Tecnologico Vale - Desenvolvimento Sustentavel

%% PRELIMINARIES
% Clear our workspace
clear all
clc

% Close all figures
close all

% * IMPORTING THE DATA
%
load('Ferreira BV_Edit_F2');
%% PRE-PROCESS DATA
%electrodes_g1 = [3,4,11,12];
electrodes_g1 = 3;
electrodes_g2 = [6,7,8,9];

features_vec = [26,52,77,103]; % [0.2015s 0.4031s 0.5968s 0.7984s]
features_vec_L = [32,65]; % [0.2461s 0.5s]

% separate right and left trials
grp1 = grp2idx(veckRefs)==1; % Group 2 (Left)
grp2 = grp2idx(veckRefs)==2; % Group 4 (Right)
%% For 1s Epochs
%X1L = zeros(size(epochS{1}(:,:,grp1),3)*3,size(electrodes_g1,2)*size(features_vec,2));
%X1R = zeros(size(epochS{1}(:,:,grp2),3)*3,size(electrodes_g1,2)*size(features_vec,2));
X1S = cell(1,size(epochS,2));
X1All = [];
X1Left = [];
X1Right = [];
for i=1:3
    %{
    for j=1:size(epochS{i},3)
        temp1 = epochS{i}(electrodes_g1,features_vec,j);
        temp2 = reshape(temp1(:,:,1)',1,[]); % Reshape electrodes to one line E1,E1,E2,...
    end
    %}
    temp = org_bci_data(epochS{i}(electrodes_g1,features_vec,:));
    temp1 = org_bci_data(epochS{i}(electrodes_g1,features_vec,grp1));
    temp2 = org_bci_data(epochS{i}(electrodes_g1,features_vec,grp2));
    X1All = vertcat(X1All,temp);
    X1Left = vertcat(X1Left,temp1);
    X1Right = vertcat(X1Right,temp2);
    clear temp temp1 temp2
end
X1S = {X1All,X1Left,X1Right};
clear X1All X1Left X1Right
X1S_Labels = go_nogo_labels(X1S);
%% For 0,5s Epochs
X1L = cell(1,size(epochL,2));
X1All = [];
X1Left = [];
X1Right = [];
for i=1:6
    %{
    temp1 = epochL(electrodes_g1,features_vec,i);
    temp2 = reshape(temp1(:,:,1)',1,[]); % Reshape electrodes to one line E1,E1,E2,...
    %}
    temp = org_bci_data(epochL{i}(electrodes_g1,features_vec_L,:));
    temp1 = org_bci_data(epochL{i}(electrodes_g1,features_vec_L,grp1));
    temp2 = org_bci_data(epochL{i}(electrodes_g1,features_vec_L,grp2));
    X1All = vertcat(X1All,temp);
    X1Left = vertcat(X1Left,temp1);
    X1Right = vertcat(X1Right,temp2);
    clear temp temp1 temp2
end
X1L = {X1All,X1Left,X1Right};
clear X1All X1Left X1Right
X1L_Labels = go_nogo_labels(X1L);
%% Classification
X = X1S{3};
Y = X1S_Labels{3};
cpHoldout = cvpartition(Y,'holdout',0.25);
%% LDA CLASSIFIER
LDA_classf = @(XTRAIN, ytrain,XTEST)(predict(...
    ClassificationDiscriminant.fit(XTRAIN,ytrain,'discrimType','linear'),XTEST));
%LDA_classf = @(XTRAIN, ytrain,XTEST)(predict(...
%    fitcdiscr(XTRAIN,ytrain,'discrimType','linear'),XTEST));
%% QDA CLASSIFIER
QDA_classf = @(XTRAIN, ytrain,XTEST)(predict(...
    ClassificationDiscriminant.fit(XTRAIN,ytrain,'discrimType','quadratic'),XTEST));
%QDA_classf = @(XTRAIN, ytrain,XTEST)(predict(...
%    fitcdiscr(XTRAIN,ytrain,'discrimType','quadratic'),XTEST));
%% DTREE CLASSIFIER
DTREE_classf = @(XTRAIN, ytrain,XTEST)(predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST));
%% Cross-Validation Error
cvErrLDA = [];
cvErrQDA = [];
cvErrDT = [];

cvErrLDA = crossval('mcr',X,Y,'predfun',LDA_classf,'partition',cpHoldout);
cvErrQDA = crossval('mcr',X,Y,'predfun',QDA_classf,'partition',cpHoldout);
cvErrDT = crossval('mcr',X,Y,'predfun',DTREE_classf,'partition',cpHoldout);