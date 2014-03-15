function [ result_struct ] = methodology_wf( X,Y,sf_1,sf_2,txt )
%METHODOLOGY Summary of this function goes here
%   Detailed explanation goes here
result_struct.Config = txt;
%% Save selected features
if isempty(sf_1)
    result_struct.SelectedFeatures_1 = 'Empty';
else
    result_struct.SelectedFeatures_1 = sf_1;
end
if isempty(sf_2)
    result_struct.SelectedFeatures_2 = 'Empty';
else
    result_struct.SelectedFeatures_2 = sf_2;
end
%% Compare selected features
if ~isempty(sf_1) && ~isempty(sf_2)
    [results,eval_results] = compareFeatures_2(X,Y,sf_1,sf_2);
elseif isempty(sf_1)
    sf_1 = 1:size(X,2);
    [results,eval_results] = compareFeatures_2(X,Y,sf_1,sf_2);
elseif isempty(sf_2)
    sf_2 = 1:size(X,2);
    [results,eval_results] = compareFeatures_2(X,Y,sf_1,sf_2);
end
%% Generate tree
% All features
all_labels = array2cellarray(1:size(X,2));
Tree_all = ClassificationTree.fit(X,Y,'PredictorNames',all_labels);
% Selected features 1
sf1_labels = array2cellarray(sf_1);
Tree_sf1 = ClassificationTree.fit(X(:,sf_1),Y,'PredictorNames',sf1_labels);
% All features
sf2_labels = array2cellarray(sf_2);
Tree_sf2 = ClassificationTree.fit(X(:,sf_2),Y,'PredictorNames',sf2_labels);
%% Prepare output as struct
result_struct.Tree_all = Tree_all;
result_struct.Tree_sf1 = Tree_sf1;
result_struct.Tree_sf2 = Tree_sf2;
result_struct.Results = results;
result_struct.Eval_results = eval_results;
end