function [ line ] = getPlotLine( idx )
%GETPLOTLINE
%   Pick a color for plot

lines = {'-','--',':','-.'};
line = lines{mod(idx,numel(lines))+1};

end

