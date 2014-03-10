function [ y_num ] = conv_to_num( y )
%CONV_TO_NUM Convert from name string output to numeric output
%   Detailed explanation goes here
y_num = zeros(length(y),1);

for i=1:length(y)
    if strcmp(y{i},'Blues')
        y_num(i) = 1;
    elseif strcmp(y{i},'Classical')
        y_num(i) = 2;
    elseif strcmp(y{i},'Jazz')
        y_num(i) = 3;
    elseif strcmp(y{i},'Metal')
        y_num(i) = 4;
    elseif strcmp(y{i},'Pop')
        y_num(i) = 5;
    else
        y_num(i) = 6;
    end
end

end

