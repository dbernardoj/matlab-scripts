function [ minmax_data,params ] = minimax( X,minimum,maximum )
%MINIMAX DATA NORMALIZATION
%   performs a linear transformation on the original data. Sup- pose that
%   minA and maxA are the minimum and maximum values of an attribute, A.
%   Min-max normalization maps a value, vi, of A to vi' in the range
%   [new_minA,new_maxA] by computing
%   vi'=((vi-minA)/(maxA-minA))*(new_minA-new_maxA)+new_minA. Min-max
%   normalization preserves the relationships among the original data
%   values. It will encounter an ?out-of-bounds? error if a future input
%   case for normalization falls outside of the original data range for A.

if ~exist('minimum','var')
    minimum=0;
end
if ~exist('maximum','var')
    maximum=1;
end
minmax = max(X)-min(X); % Vector
minmax = repmat(minmax,size(X,1),1); % Now a matrix
minmax_data = (X-repmat(min(X),size(X,1),1))./minmax;
minmax_data = minmax_data * (maximum-minimum) + minimum;
params = [min(X);max(X)];
end

