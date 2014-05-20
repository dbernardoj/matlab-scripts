function [ selected_feats ] = forwardFeatSel_wf( X,Y,input_title )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Preprocess the inputs
start_title = 'Forward Sequential Feature Selection';
if nargin < 3
    input_title = '';
end
%% Create a 10 fold cross-validation partition
% First we generate a stratified 10-fold partition for the training set:

tenfoldCVP = cvpartition(Y,'kfold',10);

features = 1:size(X,2);
%% Apply Forward Sequential Feature Selection

% We apply foward sequential feature selection on these features. The
% function _sequentialfs_ provides a simple way (the default option)to
% decide how many features are needed. It stops when the first local
% minimum of the cross-validation MCE is found.
classf = @(XTRAIN,ytrain,XTEST,ytest)(sum(~strcmp(ytest,predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST))));

% Sometimes a small MCE is achievable by looking for the minimum of the
% cross-validation MCE over a reasonable number of features. For isntance,
% we draw the plot of the cross-validation MCE as a function of the number
% of features.

[~,historyCV] = sequentialfs(classf,X,Y,'cv',tenfoldCVP,...
    'nfeatures',size(X,2));
plot(historyCV.Crit,'o');
xlabel('Number of Features');
ylabel('Cross-Validation Misclassification Error');
title(strcat('Forward Sequential Feature Selection without filter',input_title));
grid on

classf2 = @(XTRAIN, ytrain,XTEST)(predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST));

%% Evaluate for all maximum indexes
%{
% All Maximum Indexes for p=.01
maxIdxs01 = find(historyCV01.Crit == max(historyCV01.Crit));

fsCVforMaxs01 = cell(1,length(maxIdxs01));
testMCEforMaxs01 = zeros(1,length(maxIdxs01));
for i=1:length(maxIdxs01)
    % Here we show the selected features:
    fsCVforMaxs01{i} = fs1(historyCV01.In(maxIdxs01(i),:));
    testMCEforMaxs01(i) = crossval('mcr',X(:,fsCVforMaxs01{i}),Y,...
    'predfun',classf2,'partition',tenfoldCVP);
end
%}

%% Select the best features according to the MCE
selected_feats = [];

% For p=.01
%testMCEforMaxs01
if isempty(historyCV.Crit) ~= 1
    %lastvalue01 = testMCEforMaxs01(end);
    %testMCEforMaxs01 = testMCEforMaxs01(testMCEforMaxs01==lastvalue01);
    prompt = 'Select index of the desired group of features from graph:';
    %bestFeatsIdx = input(prompt);
    [bestFeatsIdx,~] = ginput(1)
    %[~,bestFeatsIdx01] = min(testMCEforMaxs01);
    %selected_feats01 = fs1(historyCV01.In(maxIdxs01(bestFeatsIdx01),:));
    selected_feats = features(historyCV.In(round(bestFeatsIdx),:));
end
end