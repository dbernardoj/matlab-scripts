function [ datadiv ] = datadiv_pairwise( X,Y )
%DATADIV_PAIRWISE Divides data for pairwise analysis
%
[~,index] = unique(Y,'first');      % Capture the index, ignore junk
classes = Y(sort(index));     % Index y with the sorted index

datadiv = cell(3,length(classes));
for i=1:length(classes)
    datadiv{1,i} = strcat('X_minus_',classes{i}); % Name
    datadiv{2,i} = X(~cellfun(@(x)strcmp(x,classes{i}),Y),:); % X
    datadiv{3,i} = Y(~cellfun(@(x)strcmp(x,classes{i}),Y)); % Y
end

end