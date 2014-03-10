function [ scaling_data,scalingVec ] = decimalScaling( X )
%DECIMAL SCALING DATA NORMALIZATION
%   Normalizes by moving the decimal point of values of attribute A. The
%   number of decimal points moved depends on the maximum absolute value of
%   A. A value, vi, of A is normalized to vi0 by computing vi'=vi/10^j,
%   where j is the smallest integer such that max(|vi'|) < 1.

maximun = max(abs(X));
scalingVec = zeros(1,size(X,2));
for i=1:size(X,2)
    iter = 0;
    maxvi = abs(maximun(i)/(10^iter));
    while maxvi > 1
        iter = iter + 1;
        maxvi = abs(maximun(i)/(10^iter));
    end
    scalingVec(i) = iter;
end
scaldiv = repmat(10.^scalingVec,size(X,1),1);
scaling_data = X./scaldiv;

end