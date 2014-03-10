function [ n1,n2,n3,n4,n5,n6,n7,n8,n9 ] = data_norm( X,Y )
%DATA_NORM - Various normalization algorithms
%   Performs various normalization algorithms on the data. Algotithms
%   includes Minimax, Zscore, Decimal Scaling, and variations with mean
%   subtraction and mean division.
classes = unique(grp2idx(Y));
%% Norm1 - Minimax Normalization
[n1,~] = minimax(X);
%% Norm2 - Zscore Normalization
n2 = zscore(X,0,1);
%% Norm3 - Decimal Scaling Normalization
[n3,~] = decimalScaling(X);
%% Norm4 - Minimax minus Mean Normalization
mean_norm1 = [];
for i=1:length(classes)
    meanTemp = mean(n1(grp2idx(Y)==i,:),1);
    mean_norm1 = vertcat(mean_norm1,repmat(meanTemp,...
        size(X(grp2idx(Y)==i,:),1),1));
end
%mean_norm1 = mean(n1,1);
%n4 = abs(n1 - repmat(mean_norm1,size(X,1),1));
n4 = abs(n1 - mean_norm1);
%% Norm5 - Zscore minus Mean Normalization
mean_norm2 = [];
for i=1:length(classes)
    meanTemp = mean(n2(grp2idx(Y)==i,:),1);
    mean_norm2 = vertcat(mean_norm2,repmat(meanTemp,...
        size(X(grp2idx(Y)==i,:),1),1));
end
%mean_norm2 = mean(n2,1);
%n5 = abs(n2 - repmat(mean_norm2,size(X,1),1));
n5 = abs(n2 - mean_norm2);
%% Norm6 - Decimal Scaling minus Mean Normalization
mean_norm3 = [];
for i=1:length(classes)
    meanTemp = mean(n3(grp2idx(Y)==i,:),1);
    mean_norm3 = vertcat(mean_norm3,repmat(meanTemp,...
        size(X(grp2idx(Y)==i,:),1),1));
end
%mean_norm3 = mean(n3,1);
%n6 = abs(n3 - repmat(mean_norm3,size(X,1),1));
n6 = abs(n3 - mean_norm3);
%% Norm7 - Norm4 divided by Mean per Class
Vsa = [];
for i=1:length(classes)
    VsaTemp = mean(n4(grp2idx(Y)==i,:),1);
    Vsa = vertcat(Vsa,repmat(VsaTemp,size(X(grp2idx(Y)==i,:),1),1));
end
n7 =  n4./Vsa;
%% Norm8 - Norm5 divided by Mean per Class
Vsa = [];
for i=1:length(classes)
    VsaTemp = mean(n5(grp2idx(Y)==i,:),1);
    Vsa = vertcat(Vsa,repmat(VsaTemp,size(X(grp2idx(Y)==i,:),1),1));
end
n8 =  n5./Vsa;
%% Norm9 - Norm6 divided by Mean per Class
Vsa = [];
for i=1:length(classes)
    VsaTemp = mean(n6(grp2idx(Y)==i,:),1);
    Vsa = vertcat(Vsa,repmat(VsaTemp,size(X(grp2idx(Y)==i,:),1),1));
end
n9 =  n6./Vsa;
end