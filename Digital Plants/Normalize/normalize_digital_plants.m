%% ABOUT
% * Author: Iraquitan Cordeiro Filho
% * Company: Institudo Tecnologico Vale - Desenvolvimento Sustentavel
% * Date: 05 feb 2014
%% PRELIMINARIES
% Clear our workspace
clear all
clc

% Close all figures
close all
%% LOAD THE DATA
%load('N4_vetorAHVD_db3_14c');
bior22 = load('semNormalizar_N4_vetorAHVD_bior22_14c.mat');
bior44 = load('semNormalizar_N4_vetorAHVD_bior44_14c.mat');
haar = load('semNormalizar_N4_vetorAHVD_haar_14c.mat');
rbio22 = load('semNormalizar_N4_vetorAHVD_rbio22_14c.mat');
rbio44 = load('semNormalizar_N4_vetorAHVD_rbio44_14c.mat');
load('species');
%% Perform Normalization
[normBior22,normBior22_mm] = norm_dp(bior22.vetor,especie);
[normBior44,normBior44_mm] = norm_dp(bior44.vetor,especie);
[normHaar,normHaar_mm] = norm_dp(haar.vetor,especie);
[normRBio22,normRBio22_mm] = norm_dp(rbio22.vetor,especie);
[normRBio44,normRBio44_mm] = norm_dp(rbio44.vetor,especie);
%% Save
% Save normalizations without removing mean
save('new_data_norms_26_02_14','normBior22','normBior44','normHaar',...
    'normRBio22','normRBio44');
% Save normalizations minus mean
save('new_data_norms_26_02_14_mm','normBior22_mm','normBior44_mm','normHaar_mm',...
    'normRBio22_mm','normRBio44_mm');