function [ labels ] = go_nogo_labels( X )
%GO_NOGO_LABELS Summary of this function goes here
%   Detailed explanation goes here
labels = cell(1,size(X,2));
for i=1:size(X,2)
    nl = size(X{i},1);
    templabels = cell(nl,1);
    for j=1:nl
        if j<=nl/3
            templabels{j} = 'Go';
        else
            templabels{j} = 'No-Go';
        end
    end
    labels{i} = templabels;
end

end

