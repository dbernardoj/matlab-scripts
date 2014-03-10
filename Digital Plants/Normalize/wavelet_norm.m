function [ normX,tp ] = wavelet_norm( X )
%WAVELET_NORM Summary of this function goes here
%   Detailed explanation goes here

nfeats = size(X,2);
tp_size = size(X,2)/3;
tpSps = sum_by_n(abs(X),3);

tp = [];
for i=1:tp_size
    cl = tpSps(:,i);
    temp = [cl cl cl];
    tp = [tp temp];
end
normX = abs(X)./tp;

end