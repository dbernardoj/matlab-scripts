%% CLASSIFICATION USING DECISION TREE
% THIS SCRIPT USE THE TECHNIQUES OF DECISION TREE TO CLASSIFY THE DATA OF
% A MFVEP TEST SIGNAL TO RATIO IN THREE GROUPS OF PEOPLE, THE ONES THAT ARE
% HEALTHY AND THE ONES THAT ARE WITH MULTIPLE SCLEROSIS AND NEUROMYELITIS
% OPTICA. WE USE FEATURE SELECTION TO REDUCE THE RAW DATA 60 FEATURES, USING
% THE CROSS-VALIDATION METHOD AS PARAMETER TO EVALUATE THE FEATURES.

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
k = strncmp('Classification tree viewer', names, 3);
close(child_handles(k))
clear k names child_handles
% * IMPORTING THE DATA
%
load('data');

% * EXPORTING THE DATA
%


%% PRE-PROCESSING THE DATA
%
% Normalize data
[minimaxNorm,zscoreNorm,decimalscalNorm,~,~,~,~,~,~] = data_norm(X,Y);
% Loads the normalized data
%load('dataNormalized_1');
%% SELECT THE DATABASE TO USE
prompt = '1 - Original data\n2 - Minimax norm data\n3 - Zscore norm data\n4 - Decimal scaling norm data\n\nSelect the database to use: ';
choice = input(prompt,'s');
choice_num = str2num(choice);
if isempty(choice)
    error('No input value.');
elseif ~isnumeric(choice_num)
    error('Not a numeric value.')
end

if choice_num == 1
    sprintf('Original data selected')
elseif choice_num == 2
    X = minimaxNorm;
    sprintf('Minimax data selected')
elseif choice_num == 3
    X = zscoreNorm;
    sprintf('Zscore data selected')
elseif choice_num == 4
    X = decimalscalNorm;
    sprintf('Decimal scaling data selected')
else
    error('No choice was made');
end
%% DIVIDE THE DATA INTO TRAINING AND TEST SETS
% Here we divide the data for training and testing.
% Divides using kfold = 10

% Divides using holdout with 75% test size.

% Divides using leave one out.

%% GENERATING THE DEFAULT CLASSIFICATION TREE
% Generate the Decision Tree using the training sets.
% Generate the default tree using K-Fold partitions

%% DIVIDE DATA IN CLASSES TO PAIRWISE ANALYSIS
% Two diseases classes
X_minus_saudavel = X(~cellfun(@(x)strcmp(x,'saudavel'),Y),:);
Y_minus_saudavel = Y(~cellfun(@(x)strcmp(x,'saudavel'),Y));

% Healthy and sclerosis classes
X_minus_neuromielite = X(~cellfun(@(x)strcmp(x,'neuromielite otica'),Y),:);
Y_minus_neuromielite = Y(~cellfun(@(x)strcmp(x,'neuromielite otica'),Y));

% Healthy and neuromielite classes
X_minus_esclerose = X(~cellfun(@(x)strcmp(x,'esclerose multipla'),Y),:);
Y_minus_esclerose = Y(~cellfun(@(x)strcmp(x,'esclerose multipla'),Y));

% Healthy and 2 diseases without distinction
Y_saudavel_doente = Y;
for i=1:length(Y)
    if strcmp(Y{i},'neuromielite otica') || strcmp(Y{i},'esclerose multipla')
        Y_saudavel_doente{i} = 'doente';
    end
end
%{
%% PERFORM CROSS_VALIDATION FEATURE SELECTION WITH 2B2 CLASSES
% Tree with the two diseases classes
tree_minus_saudavel = ClassificationTree.fit(X_minus_saudavel,...
    Y_minus_saudavel,'PredictorNames',features_label);
extracted_feats_minus_saudavel = ...
    cv_feat_selection(tree_minus_saudavel, ...
    'kfold',' for two diseases classes');
draw_Dartboard(extracted_feats_minus_saudavel,' for two diseases classes');

% Tree with the healthy and sclerosis classes
tree_minus_neuromielite = ClassificationTree.fit(X_minus_neuromielite,...
    Y_minus_neuromielite,'PredictorNames',features_label);
extracted_feats_minus_neuromielite = ...
    cv_feat_selection(tree_minus_neuromielite, ...
    'kfold',' for healthy and sclerosis classes');
draw_Dartboard(extracted_feats_minus_neuromielite,' for healthy and sclerosis classes');

% Tree with the healthy and neuromielite classes
tree_minus_esclerose = ClassificationTree.fit(X_minus_esclerose,...
    Y_minus_esclerose,'PredictorNames',features_label);
extracted_feats_minus_esclerose = ...
    cv_feat_selection(tree_minus_esclerose, ...
    'kfold',' for healthy and neuromielite classes');
draw_Dartboard(extracted_feats_minus_esclerose,' for healthy and neuromielite classes');
%}
%{
%% PERFORM FORWARD SEQUENTIAL FEATURE SELECTION WITH 2B2 CLASSES
% Two diseases classes
fs_selected_feats_minus_saudavel = forwardFeatSel(X_minus_saudavel,Y_minus_saudavel,' for two diseases classes with forward feature selection');
draw_Dartboard(fs_selected_feats_minus_saudavel,' for two diseases classes with forward feature selection');
% Healthy and sclerosis classes
fs_selected_feats_minus_neuromielite = forwardFeatSel(X_minus_neuromielite,Y_minus_neuromielite,' for healthy and sclerosis classes with forward feature selection');
draw_Dartboard(fs_selected_feats_minus_neuromielite,' for healthy and sclerosis classes with forward feature selection');
% Healthy and neuromielite classes
fs_selected_feats_minus_esclerose = forwardFeatSel(X_minus_esclerose,Y_minus_esclerose,' for healthy and neuromielite classes with forward feature selection');
draw_Dartboard(fs_selected_feats_minus_esclerose,' for healthy and neuromielite classes with forward feature selection');
% Healthy and 2 diseases without distinction
fs_selected_feats_saudavel_doente = forwardFeatSel(X,Y_saudavel_doente,' for healthy and 2 diseases classes with forward feature selection');
draw_Dartboard(fs_selected_feats_saudavel_doente,' for healthy and 2 diseases classes with forward feature selection');
%% PERFORM T-TEST BASED FEATURE SELECTION WITH 2B2 CLASSES
% Two diseases classes
[fs01_minus_saudavel,fs05_minus_saudavel] = filterFeatSel(X_minus_saudavel,Y_minus_saudavel);
draw_Dartboard(fs01_minus_saudavel,' for two diseases classes with filter and p=.01');
draw_Dartboard(fs05_minus_saudavel,' for two diseases classes with filter and p=.05');
% Healthy and sclerosis classes
[fs01_minus_neuromielite,fs05_minus_neuromielite] = filterFeatSel(X_minus_neuromielite,Y_minus_neuromielite);
draw_Dartboard(fs01_minus_neuromielite,' for healthy and sclerosis classes with filter and p=.01');
draw_Dartboard(fs05_minus_neuromielite,' for healthy and sclerosis classes with filter and p=.05');
% Healthy and neuromielite classes
[fs01_minus_esclerose,fs05_minus_esclerose] = filterFeatSel(X_minus_esclerose,Y_minus_esclerose);
draw_Dartboard(fs01_minus_esclerose,' for healthy and neuromielite classes with filter and p=.01');
draw_Dartboard(fs05_minus_esclerose,' for healthy and neuromielite classes with filter and p=.05');
% Healthy and 2 diseases without distinction
[fs01_saudavel_doente,fs05_saudavel_doente] = filterFeatSel(X,Y_saudavel_doente);
draw_Dartboard(fs01_saudavel_doente,' for healthy and 2 diseases classes with filter and p=.01');
draw_Dartboard(fs05_saudavel_doente,' for healthy and 2 diseases classes with filter and p=.05');
%}
%% Use methodology function
results_minus_saudavel = methodology(X_minus_saudavel,Y_minus_saudavel,'two diseases');
results_minus_neuromielite = methodology(X_minus_neuromielite,Y_minus_neuromielite,'healthy and sclerosis');
results_minus_esclerose = methodology(X_minus_esclerose,Y_minus_esclerose,'healthy and neuromielytis');
results_saudavel_doente = methodology(X,Y_saudavel_doente,'healthy and diseased');