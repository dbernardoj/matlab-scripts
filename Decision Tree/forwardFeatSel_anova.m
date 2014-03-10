function [ selected_feats ] = forwardFeatSel_anova( X,Y,input_title )
%WRAPPER METHOD (SEQUENTIAL FEATURE SELECTION)
%   Wrapper methods use the performance of the chosen learning algorithm
%   (Classification Tree in this case) to evaluate each feature subset.
%   Wrapper metohds search for features better fit for the chosen learning
%   algorithm, but they can be significantly slower than filter methods if
%   the learning algoritm takes a long time to run. Sequential feature
%   selection is one of the most widely used techniques. It selects a
%   subset of features by sequentially adding (foward search) or removing
%   (backward search) until certain stop conditions are satisfied. Here we
%   use the MCE of the learning algorithm Classification Tree on each
%   candidate feature subset as the performance indicator of the subset.
%   The training set is used to select the features and to fit the
%   Classification Tree model, and the test set is used to evaluate the
%   performance of the finally selected feature. During the feature
%   selection procedure, to evaluate and to compare the performance of the
%   each candidate feature subset, we apply stratified 10-fold
%   cross-validation to the trainig set.
%% Preprocess the inputs
start_title = 'Forward sequential feature selection graphs';
if nargin < 3
    input_title = '';
end
%% Apply the analysis of variance (ANOVA) for groups
% We might apply the anova on each feature and compare p-value
% for each feature as a measure of how
% effective it is at separating groups.

%ANOVA
p = zeros(1,size(X,2));
for i=1:size(X,2)
    p(i) = anova1(X(:,i),Y,'off');
end

% In order to get a better idea of how well-separated the two groups are by
% each feature, we plot the empirical cumulative distribution function
% (CDF) of the _p-values_.

figure;
subplot(1,3,1);
ecdf(p);
title('Empirical CDF');
xlabel('P Value');
ylabel('CDF Value');
grid on

featSmallPoFive = find(p < 0.05);

% Features having _p-values_ close to zero and features having _p-values_
% smaller than 0.05, mean that they have strong discrimination power. One
% can sort these features according to their _p-values_ (or the absolute
% values of _t-statistics_) and select some features from the sorted list.
% However, it is usually difficult to decide how many features are needed.
% One quick way to decide the number of needed features is to plot the MCE
% (misclassification error, i.e., the number of misclassified observations
% divided by the number of observations) on the test set as a function of
% the number of features.

[~,featureIdxSortbyp] = sort(p,2); % sort the features by the p value;

%% Create a 10 fold cross-validation partition
% First we generate a stratified 10-fold partition for the training set:

tenfoldCVP = cvpartition(Y,'kfold',10);

% Then we use the filter results from previous section as a pre-processing
% step to select features.

%% Apply Forward Sequential Feature Selection
fs1 = featureIdxSortbyp(1:60);

% We apply foward sequential feature selection on these features. The
% function _sequentialfs_ provides a simple way (the default option)to
% decide how many features are needed. It stops when the first local
% minimum of the cross-validation MCE is found.
classf = @(XTRAIN,ytrain,XTEST,ytest)(sum(~strcmp(ytest,predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST))));

fsLocal = sequentialfs(classf,X(:,fs1),Y,'cv',tenfoldCVP);

% The selected features are the following:

fsCVLocal = fs1(fsLocal)

% Sometimes a small MCE is achievable by looking for the minimum of the
% cross-validation MCE over a reasonable number of features. For isntance,
% we draw the plot of the cross-validation MCE as a function of the number
% of features.

[fsCVforBest,historyCV] = sequentialfs(classf,X,Y,'cv',tenfoldCVP,...
    'nfeatures',length(featSmallPoFive));
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
fsCVforMin = fs1(historyCV.In(minIdx,:))

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
%% Plot the Resubstitution MCE for comparison
% It is interesting to look at the plot of resubstitution MCE values on the
% training set(i.e.m without performing cross-validation during the feature
% selection procedure) as a function of the number of features:
[fsResubforBest,historyResub] = sequentialfs(classf,X(:,fs1),...
    Y,'cv','resubstitution','nfeatures',length(featSmallPoFive));
subplot(1,3,3);
plot(1:length(featSmallPoFive),historyCV.Crit,'bo',...
    1:length(featSmallPoFive),historyResub.Crit,'r^');
xlabel('Number of Features');
ylabel('MCE');
title('Comparison of Resub and FS Feature Selection');
legend({'10-fold CV MCE','Resubstitution MCE'},'location','NE');
grid on
% Add superior title
suptitle(strcat(start_title,input_title));

% In order to compare the MCE of the resubstitution with the one using
% cross-validation, we have evaluate the MCE for the minimum features using
% resubstitution.
% Here we find the minimum number of features that return the lowest MCE.
minResubIdx = find(historyResub.Crit == min(historyResub.Crit),1,'first');

% Here we show the selected features using resubstitution:
fsResubforMin = fs1(historyResub.In(minResubIdx,:))

% To evaluate the selected features, we compute their MCE for
% Classification Tree on the test set using resubstitution.
testMCEResubforMin = crossval('mcr',X(:,fsResubforMin),Y,...
    'predfun',classf2,'partition',tenfoldCVP)
%}

%% Select the best features according to the MCE
testMCEforMins
[~,bestFeatsIdx] = min(testMCEforMins);
selected_feats = fs1(historyCV.In(minIdxs(bestFeatsIdx),:));
end

