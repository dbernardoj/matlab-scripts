function [ selected_feats_01,selected_feats_05 ] = filterFeatSel_anova_progress( X,Y,input_title )
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
start_title = 'ANOVA Filter Selection Graphs: ';
if nargin < 4
    input_title = '';
end
%% Apply the analysis of variance (ANOVA) for groups
% We might apply the anova on each feature and compare p-value
% for each feature as a measure of how
% effective it is at separating groups.

%ANOVA
p = zeros(1,size(X,2));
h1 = waitbar(0,'Inicializando ANOVA...',...
    'Name','ANOVA Feature Selection');
for i=1:size(X,2)
    p(i) = anova1(X(:,i),Y,'off');
    perc1 = i/size(X,2)*100;
    waitbar(i/size(X,2),h1,sprintf('%3.2f%% concluido...',perc1))
end
close(h1)

% In order to get a better idea of how well-separated the two groups are by
% each feature, we plot the empirical cumulative distribution function
% (CDF) of the _p-values_.

hfig=figure;
ecdf(p);
title('Empirical CDF');
xlabel('P Value');
ylabel('CDF Value');
title(strcat(start_title,input_title));
grid on

featSmallPoOne = find(p < 0.01);
featSmallPoFive = find(p < 0.05);
selected_feats_01 = featSmallPoOne;
selected_feats_05 = featSmallPoFive;
end

