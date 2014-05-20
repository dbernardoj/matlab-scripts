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
load('Ferreira BV_Edit_2014 04 22 16:27:27');
%% PRE-PROCESS DATA
% 2 = Esquerda
% 4 = Direita
Y = cell(size(veckRefs,2),1);
for i=1:size(veckRefs,2)
    if veckRefs(i) == 2
        Y{i} = 'Left';
    elseif veckRefs(i) == 4
        Y{i} = 'Right';
    else
        error('Unknow reference value.');
    end     
end

%{
Yn = cell(size(veckRefs,2),1);
for i=1:size(veckRefs,2)
    if i <= 14
        Yn{i} = 'Right';
    else
        Yn{i} = 'Left';
    end     
end
%}
%obj = ClassificationDiscriminant.fit(vertcat(group1,group2),Y,'discrimType','quadratic','SaveMemory','on');

X = cell(1,3);
X{1} = trialsCurva;
X{2} = trialsCurva(:,1:65,:);
X{3} = trialsCurva(:,65:end,:);
%% DIVIDE THE DATA INTO TRAINING AND TEST SETS
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
cvErrLDA = cell(1,3);
cvErrQDA = cell(1,3);
cvErrDT = cell(1,3);
for i=1:size(X,2)
    Xvalue = zeros(size(Y,1),size(X{i},1)*size(X{i},2));
    for j=1:size(Y,1)
        temp = reshape(X{i}(:,:,j)',1,[]);
        %Xvalue = vertcat(Xvalue,temp);
        Xvalue(j,:) = temp;
    end
    cvErrLDA{i} = crossval('mcr',Xvalue,Y,'predfun',LDA_classf,'partition',cpHoldout);
    %cvErrQDA{i} = crossval('mcr',Xvalue,Y,'predfun',QDA_classf,'partition',cpHoldout);
    cvErrDT{i} = crossval('mcr',Xvalue,Y,'predfun',DTREE_classf,'partition',cpHoldout);
end