function [ transposed_cell ] = transpose_cell( cell_array )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

transposed_cell = cell(length(cell_array),1);
for i=1:length(cell_array)
    transposed_cell{i} = cell_array{i};
end 

end

