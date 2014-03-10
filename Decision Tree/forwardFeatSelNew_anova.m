function [ selected_feats01,selected_feats05 ] = forwardFeatSelNew_anova( X,Y,input_title )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

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

featSmallPoOne = find(p < 0.01);

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
% step to select features.vvvv
%% Apply Forward Sequential Feature Selection
fs1 = featureIdxSortbyp(1:60);

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

[~,historyCV05] = sequentialfs(classf,X,Y,'cv',tenfoldCVP,...
    'nfeatures',length(featSmallPoFive));
subplot(1,3,2);
plot(historyCV05.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('Forward Sequential Feature Selection with Cross-Validation p=.05');
grid on


[~,historyCV01] = sequentialfs(classf,X,Y,'cv',tenfoldCVP,...
    'nfeatures',length(featSmallPoOne));
subplot(1,3,3);
plot(historyCV01.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('Forward Sequential Feature Selection with Cross-Validation p=.01');
grid on

% Add superior title
suptitle(strcat(start_title,input_title));

classf2 = @(XTRAIN, ytrain,XTEST)(predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST));

%% Evaluate for all maximum indexes
% All Maximum Indexes for p=.05
%{
maxIdxs05 = find(historyCV05.Crit == max(historyCV05.Crit));

fsCVforMaxs05 = cell(1,length(maxIdxs05));
testMCEforMaxs05 = zeros(1,length(maxIdxs05));
for i=1:length(maxIdxs05)
    % Here we show the selected features:
    fsCVforMaxs05{i} = fs1(historyCV05.In(maxIdxs05(i),:));
    testMCEforMaxs05(i) = crossval('mcr',X(:,fsCVforMaxs05{i}),Y,...
    'predfun',classf2,'partition',tenfoldCVP);
end

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
selected_feats05 = [];
selected_feats01 = [];
% For p=.05
%testMCEforMaxs05
if isempty(historyCV05.Crit) ~= 1
    %lastvalue05 = testMCEforMaxs05(end);
    %testMCEforMaxs05 = testMCEforMaxs05(testMCEforMaxs05==lastvalue05);
    prompt05 = 'Select index of the desired group of features with p=.05 from graph:';
    bestFeatsIdx05 = input(prompt05);
    %[~,bestFeatsIdx05] = min(testMCEforMaxs05);
    %selected_feats05 = fs1(historyCV05.In(maxIdxs05(bestFeatsIdx05),:));
    selected_feats05 = fs1(historyCV05.In(bestFeatsIdx05,:));
end

% For p=.01
%testMCEforMaxs01
if isempty(historyCV01.Crit) ~= 1
    %lastvalue01 = testMCEforMaxs01(end);
    %testMCEforMaxs01 = testMCEforMaxs01(testMCEforMaxs01==lastvalue01);
    prompt01 = 'Select index of the desired group of features with p=.01 from graph:';
    bestFeatsIdx01 = input(prompt01);
    %[~,bestFeatsIdx01] = min(testMCEforMaxs01);
    %selected_feats01 = fs1(historyCV01.In(maxIdxs01(bestFeatsIdx01),:));
    selected_feats01 = fs1(historyCV01.In(bestFeatsIdx01,:));
end
end

