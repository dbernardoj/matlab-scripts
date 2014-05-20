function [ n ] = data_norm2( X,alg )
%DATA_NORM - Various normalization algorithms
%   Performs various normalization algorithms on the data. Algotithms
%   includes Minimax, Zscore, Decimal Scaling, and variations with mean
%   subtraction and mean division.
if strcmp(alg,'Minimax')
%% Norm1 - Minimax Normalization
    [n,~] = minimax(X);
elseif strcmp(alg,'Z-Score')
%% Norm2 - Zscore Normalization
    n = zscore(X,0,1);
elseif strcmp(alg,'Decimal Scaling')
%% Norm3 - Decimal Scaling Normalization
    [n,~] = decimalScaling(X);
else
    error('Algorithm not supported.')
end

end

