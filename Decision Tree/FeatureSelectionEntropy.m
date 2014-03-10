%% FEATURE SELECTION USING ENTROPY
% THIS SCRIPT USES THE ENTROPY IN THE CONTEXT OF DECISION TREE, WHICH IS A
% MEASURE OF IMPURITY OF PARTITIONING THE DATA IN A GIVEN ATTRIBUTE. HERE
% IS USED INFORMATION GAIN, GAIN RATIO AND GINI INDEX.

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

% This finds handles to all the objects in the current session, filters it
% to find just the handles to the Classification tree viewers so that they
% can be selectively closed.
child_handles = allchild(0);
names = get(child_handles,'Name');
k = find(strncmp('Classification tree viewer', names, 3));
close(child_handles(k))

% * IMPORTING THE DATA
%
load('NewData');
user = getenv('USER');

[igsp, iga, sig, siga] = infoGain(people_meas,people_status);
[grsp, gra, sgr, sgra] = gainRatio(people_meas,people_status,iga);
[gisp, gia, sgi, sgia] = giniIndex(people_meas,people_status);