function [ featSmallPoOne,featSmallPoFive ] = ttest2FeatSel( X,Y,input_title )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Preprocess the inputs
start_title = 'T-test selection graphs';
if nargin < 3
    input_title = '';
end
%% Apply the t-test for two groups
% We might apply the _t-test_ on each feature and compare _p-value_ (or the
% absolute values of _t-statistics_) for each feature as a measure of how
% effective it is at separating groups.

%ANOVA
%[p,table] = anovan(teste,X,3,3,features_label); % Highly computational expensive

group1 = X(grp2idx(Y)==1,:);
group2 = X(grp2idx(Y)==2,:);
[h,p,ci,stat] = ttest2(group1,group2,[],[],'unequal');

% In order to get a better idea of how well-separated the two groups are by
% each feature, we plot the empirical cumulative distribution function
% (CDF) of the _p-values_.

figure;
ecdf(p);
title('Empirical Cumulative Distribution Function');
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

% Add superior title
suptitle(strcat(start_title,input_title));
end

