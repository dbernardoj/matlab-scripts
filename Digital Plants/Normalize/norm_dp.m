function [ Norm1,NormX ] = norm_dp( X,Y )
%NORM_DP Summary of this function goes here
%   Performs wavelet normalization and minimax normalization on data, then
%   contatenate them, and also removes the mean by classes.

%% Wavelet normalization
X1 = wavelet_norm(X(:,1:108));
%% Minimax normalization
X2 = minimax(X(:,109:end));
%% Concatenation
Norm1 = horzcat(X1,X2);
%% Remove mean
NormX = horzcat(X1,X2);
classes = unique(grp2idx(Y));
mean_normX = [];
for i=1:length(classes)
    meanTemp = mean(NormX(grp2idx(Y)==i,:),1);
    mean_normX = vertcat(mean_normX,repmat(meanTemp,...
        size(X(grp2idx(Y)==i,:),1),1));
end
NormX = abs(NormX - mean_normX);
end