function [ sp_value,sn_value ] = sp_sn( conf_mat )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
sp_value = conf_mat(2,2)/(conf_mat(2,2)+conf_mat(2,1));
sn_value = conf_mat(1,1)/(conf_mat(1,1)+conf_mat(1,2));

end

