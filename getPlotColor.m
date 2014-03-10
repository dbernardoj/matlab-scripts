function [ color ] = getPlotColor( idx )
%GETPLOTCOLOR 
%   Pick a color for plot

colors = {'r','g','b','c','m','y','k','w'};
color = colors{mod(idx,numel(colors))+1};
end

