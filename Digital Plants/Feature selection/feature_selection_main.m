%% FEATURE SELECTION IN THE DIGITAL PLANTS DATABASE
% THIS SCRIPT USES THE IMPLEMENTED HYBRID FEATURE SELECTION FUNCTION WITH
% THE FILTER ALGORITHM ANALYSIS OF VARIANCE (ANOVA) AND THE WRAPPER
% ALGORITHM SEQUENTIAL FORWARD SELECTION (SFS) WITH VARIOUS CLASSIFICATION
% ALGORITHMS LIKE DECISION TREES WITH DIFFERENT CONFIGURATIONS AND
% DISCRIMINANT CLASSIFIERS SUCH AS LINEAR DISCRIMINANT ANALYSIS (LDA) AND
% QUADRATIC DISCRIMINANT ANALYSIS (QDA). THE DATABASE USED IS THE DIGITAL
% PLANTS DATABASE.

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

% This finds handles to all the objects in the current session, filters it
% to find just the handles to the Classification tree viewers so that they
% can be selectively closed.
child_handles = allchild(0);
names = get(child_handles,'Name');
k = find(strncmp('Classification tree viewer', names, 3));
close(child_handles(k))

user = getenv('USER'); % get user

% * LOADING THE DATA
%
vetor1=load('N3_vetorAHVD_db3_14c');
vetor2=load('N3_vetorAHVD_db4_14c');
vetor3=load('N4_vetorAHVD_db3_14c');
vetor4=load('N4_vetorAHVD_db4_14c');
load('species');
% * DECLARE WRITE DATA
database = {'N3db314c','N3db414c','N4db314c','N4db414c'};
numdbs = length(database);
%% PREPROCESSING THE DATA
% cell array of strings from character array
%especie = cellstr(spe);
Y = especie;
class_algs = {'dt_gdi','dt_twoing','dt_deviance','cd_linear','cd_quadratic'};
numconfigs = length(class_algs);
%% PERFORM FEATURE SELECTION WITH ALL POSSIBLE CONFIGURATIONS
for i=1:numdbs
    expression = sprintf('X = vetor%d.vetor;',i);
    eval(expression);
    for j=1:numconfigs
        [hfig,feat_sel] = forwardFeatSel_anova_progress(X,Y,...
            class_algs{j},strcat(class_algs{j},' ',database{i}));
        filename = strcat('featSel_',class_algs{j},'_',database{i});
        saveas(hfig,filename,'fig');
        saveAsMatFile(feat_sel,filename,filename);
    end
end