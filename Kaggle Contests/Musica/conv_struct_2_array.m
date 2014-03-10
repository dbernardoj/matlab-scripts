function [ results_array ] = conv_struct_2_array( results_struct )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
n = length(results_struct);
results_array = zeros(n,2);
for i=1:n
    results_array(i,1) = results_struct(i).Id;
    results_array(i,2) = results_struct(i).Genres;
end

end

