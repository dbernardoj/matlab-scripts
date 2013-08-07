%% WRITE THE BEST FEATURES SO FAR TO FILE
% Execute this script to write the best features found so far to file, so
% it can be used later.
user = getenv('USER');
bestFeats = sprintf('/Users/%s/Dropbox/TCC/Dados/Best Feats.xlsx',user);
w0 = xlswrite(bestFeats,fsCVforMin);