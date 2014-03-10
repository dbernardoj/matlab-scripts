function [ result_struct ] = methodology( X,Y,txt )
%METHODOLOGY Summary of this function goes here
%   Detailed explanation goes here
result_struct.Config = txt;
%% Perform feature selection
% Sequential forward selection with gindex decision tree and t-test
[fs01,fs05] = forwardFeatSelNew(X,Y,[' for ' txt ' classes with sfs and filter']);
% Relieff feature selection with 5 neighbors
ttsh = 0.05;
[~,weight] = relieff(X,Y,5);
rsf = 1:size(X,2);
rsf = rsf(weight > ttsh);
%% Show selected features
%draw_Dartboard(fs01,[' for ' txt ' classes with sfs and filter p=.01']);
%draw_Dartboard(fs05,[' for ' txt ' classes with sfs and filter p=.05']);
%% Features to compare
%sf_1 = fs01;
%sf_2 = fs05;
%
sf_1 = fs01;
sf_2 = rsf;
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