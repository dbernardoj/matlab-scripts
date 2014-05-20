function [ sel_feats ] = Anova_fs( X,Y,sig_lvl,ax )
%ANOVA Summary of this function goes here
%   Detailed explanation goes here
%ANOVA
p = zeros(1,size(X,2));
h1 = waitbar(0,'Inicializando ANOVA...',...
    'Name','ANOVA Feature Selection');
for i=1:size(X,2)
    p(i) = anova1(X(:,i),Y,'off');
    perc1 = i/size(X,2)*100;
    waitbar(i/size(X,2),h1,sprintf('%3.2f%% concluido...',perc1))
end
close(h1)

% In order to get a better idea of how well-separated the two groups are by
% each feature, we plot the empirical cumulative distribution function
% (CDF) of the _p-values_.
axes(ax)
ecdf(p);
title('Empirical CDF');
xlabel('P Value');
ylabel('CDF Value');
grid on

sel_feats = find(p < sig_lvl);

end

