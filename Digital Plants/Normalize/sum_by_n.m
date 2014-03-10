function [ res ] = sum_by_n( X,nCol )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if mod(size(X,2), nCol) == 0
    res = sum(reshape(reshape(X,size(X,1)*nCol,[])',[size(X,2)./nCol,size(X,1),nCol]),3)';
else
    error('Configuration not possible.')
end

end