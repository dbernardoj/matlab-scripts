function [ X_minus_mean,X_div_mean ] = norm_minus_mean( X,Y )
%NORM_MINUS_MEAN Summary of this function goes here
%   Detailed explanation goes here

%% Minus mean
classes = unique(grp2idx(Y));
mean_norm = [];
for i=1:length(classes)
    meanTemp = mean(X(grp2idx(Y)==i,:),1);
    mean_norm = vertcat(mean_norm,repmat(meanTemp,...
        size(X(grp2idx(Y)==i,:),1),1));
end
X_minus_mean = abs(X - mean_norm);

%% Divided by mean
Vsa = [];
for i=1:length(classes)
    VsaTemp = mean(X_minus_mean(grp2idx(Y)==i,:),1);
    Vsa = vertcat(Vsa,repmat(VsaTemp,size(X(grp2idx(Y)==i,:),1),1));
end
X_div_mean =  X_minus_mean./Vsa;

end

