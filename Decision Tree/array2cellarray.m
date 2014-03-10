function [ cellarray ] = array2cellarray( array )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = length(array);
cellarray = cell(1,n);
for i=1:n
    cellarray{i} = num2str(array(i));
end

end

