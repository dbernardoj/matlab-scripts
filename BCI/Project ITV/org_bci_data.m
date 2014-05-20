function [ newX ] = org_bci_data( X )
%ORG_BCI_DATA Summary of this function goes here
%   Detailed explanation goes here
newX = zeros(size(X,3),size(X,1)*size(X,2));
for i=1:size(X,3)
    temp1 = X(:,:,i);
    temp2 = reshape(temp1(:,:,1)',1,[]); % Reshape electrodes to one line E1,E1,E2,...
    newX(i,:) = temp2;
end

end

