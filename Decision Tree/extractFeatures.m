function [ features ] = extractFeatures( tree )
%EXTRACT FEATURES FROM DECISION TREE
%   Extract the features used to build a Decision Tree, without repetition
%   and converts it from cell array to numeric array.
raw_feats = unique(tree.CutVar);
%% Remove emptys
feats = raw_feats(~cellfun('isempty', raw_feats));
%% Convert cell array to numeric array
[m,~] = size(feats);
features = zeros(m,1);
for i=1:m
    features(i) = str2double(feats{i});
end

clear 'raw_feats' 'feats' 'm'
end