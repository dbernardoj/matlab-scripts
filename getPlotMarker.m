function [ marker ] = getPlotMarker( idx )
%GETPLOTMARKER 
%   Pick a marker for plot
markers = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
marker = markers{mod(idx,numel(markers))+1};

end

