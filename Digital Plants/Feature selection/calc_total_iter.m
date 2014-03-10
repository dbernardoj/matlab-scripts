function [ num_iter ] = calc_total_iter( investigate_feats,tot_feats )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
k = 10;
num_iter = 0;
for i=1:investigate_feats
    num_iter = num_iter + (tot_feats + 1 - i)*k; 
end

end

