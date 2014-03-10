%% DATA ANALYSIS
% THIS SCRIPT PERFORMS DATA NORMALIZATION ON THE DATA OF MFVEP TEST SIGNAL
% TO RATIO IN THREE GROUPS OF PEOPLE, THE ONES THAT ARE HEALTHY AND THE
% ONES THAT ARE WITH MULTIPLE SCLEROSIS AND NEUROMYELITIS OPTICA.

%% ABOUT
% * Author: Iraquitan Cordeiro Filho
% * Mentor: Schubert Carvalho
% * Company: Institudo Tecnologico Vale - Desenvolvimento Sustentavel
%% PRELIMINARIES
% Clear our workspace
clear all
clc

% Close all figures
close all

% * IMPORTING THE DATA
%
load('data');

%% PROCESSING THE DATA
% Use defined function to normalize the data
[ N1,N2,N3,N4,N5,N6,N7,N8,N9 ] = data_norm( X,Y );
%% PLOTTING THE DATA
c = random_color(length(unique(Y)));
% N1,N2 and N3
h1 = figure;
subplot(3,1,1);
plotMeanStd(N1,Y,'Minimax',c)
subplot(3,1,2);
plotMeanStd(N2,Y,'Zscore',c)
subplot(3,1,3);
plotMeanStd(N3,Y,'Decimal scaling',c)
%suptitle('N1,N2,N3');
%%
% N4,N5 and N6
figure
subplot(3,1,1);
plotMeanStd(N4,Y,[],c)
subplot(3,1,2);
plotMeanStd(N5,Y,[],c)
subplot(3,1,3);
plotMeanStd(N6,Y,[],c)
%suptitle('N4,N5,N6');
%%
% N7,N8 and N9
figure
subplot(3,1,1);
plotMeanStd(N7,Y,[],c)
subplot(3,1,2);
plotMeanStd(N8,Y,[],c)
subplot(3,1,3);
plotMeanStd(N9,Y,[],c)
%suptitle('N7,N8,N9');