function [ selected_feats ] = forwardfeatsel( X,Y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

allfeatures = zeros(1,size(X,2));
for i=1:size(X,2)
    allfeatures(i) = i;
end

%% Create a 10 fold cross-validation partition
% First we generate a stratified 10-fold partition for the training set:
tenfoldCVP = cvpartition(Y,'kfold',10);

%%
% We apply foward sequential feature selection on these features. The
% function _sequentialfs_ provides a simple way (the default option)to
% decide how many features are needed. It stops when the first local
% minimum of the cross-validation MCE is found.
classf = @(XTRAIN,ytrain,XTEST,ytest)(sum(~strcmp(ytest,predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST))));

fsLocal = sequentialfs(classf,X,Y,'cv',tenfoldCVP);

% The selected features are the following:

fsCVLocal = allfeatures(fsLocal);

% Sometimes a small MCE is achievable by looking for the minimum of the
% cross-validation MCE over a reasonable number of features. For isntance,
% we draw the plot of the cross-validation MCE as a function of the number
% of features.

[fsCVforBest,historyCV] = sequentialfs(classf,X,Y,'cv',tenfoldCVP,...
    'nfeatures',length(allfeatures)/2);
subplot(1,3,2);
plot(historyCV.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('Forward Sequential Feature Selection with Cross-Validation');
grid on

% We need to find where the cross-validation MCE reaches the minimum value
% to determine the minimum number of features, because it is usually
% preferable to have fewer features.
% Here we find the minimum number of features that return the lowest MCE.

minIdx = find(historyCV.Crit == min(historyCV.Crit),1,'first');

% Here we show the selected features:
fsCVforMin = allfeatures(historyCV.In(minIdx,:))

classf2 = @(XTRAIN, ytrain,XTEST)(predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST));

% To show these features in the order in which they are selected in the
% sequential forward procedure, we find the row in which they first become
% true in the |historyCV| output.

%[orderlist,ignore] = find( [historyCV.In(1,:);...
%    diff(historyCV.In(1:minIdx,:))]' );

% Here we show the ordered features:
%fs1(orderlist)

% To evaluate the selected features, we compute their MCE for
% Classification Tree on the test set.
testMCEforMin = crossval('mcr',X(:,fsCVforMin),Y,...
    'predfun',classf2,'partition',tenfoldCVP)

%% Evaluate for all minimum indexes
% All Minimum Indexes
minIdxs = find(historyCV.Crit == min(historyCV.Crit));

% Generates the trees using the minimum indexes:
%[fsCVforMins01, fsCVforMinsLabels01, TestTrees01] = compSelFeats(X,Y,...
%    minIdxs,fs1);

fsCVforMins = cell(1,length(minIdxs));
testMCEforMins = zeros(1,length(minIdxs));
for i=1:length(minIdxs)
    % Here we show the selected features:
    fsCVforMins{i} = fs1(historyCV.In(minIdxs(i),:));
    testMCEforMins(i) = crossval('mcr',X(:,fsCVforMins{i}),Y,...
    'predfun',classf2,'partition',tenfoldCVP);
end
%% Select the best features according to the MCE
testMCEforMins
[~,bestFeatsIdx] = min(testMCEforMins);
selected_feats = fs1(historyCV.In(minIdxs(bestFeatsIdx),:));

end

