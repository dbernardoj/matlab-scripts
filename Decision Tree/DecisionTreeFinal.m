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
k = find(strncmp('Classification tree viewer', names, 3));
close(child_handles(k))

% * IMPORTING THE DATA
%
load('selFeats01');
% Place variables to point to the raw data in the Excell format.
user = getenv('USER');
%{
filename1 = '/Users/pma007/Dropbox/TCC/Dados/Dados mfVEP.xlsx';
filename2 = '/Users/pma007/Dropbox/TCC/Dados/Dados mfVEP Reduzido.xlsx';
status_fn = '/Users/pma007/Dropbox/TCC/Dados/status mfVEP.xlsx';
%}
filename1 = sprintf('/Users/%s/Dropbox/TCC/Dados/Dados mfVEP - Novos.xlsx',user);

fileBest = sprintf('/Users/%s/Dropbox/TCC/Dados/Best Feats.csv',user);

% * EXPORTING THE DATA
%
% Place variables to point to where the results will be written.

featWrite = sprintf('/Users/%s/Dropbox/TCC/Dados/Key Features.xlsx',user);
predictWrite = ...
    sprintf('/Users/%s/Dropbox/TCC/Dados/Key Features.xlsx',user);
bestFeats = sprintf('/Users/%s/Dropbox/TCC/Dados/Best Feats.xlsx', user);

%% PROCESSING THE DATA
% First specify the sheet names for the Excell raw data.

sheet1 = 'UFPA';
sheet2 = 'Neuromielite optica UFPA';
sheet3 = 'Esclerose Multipla UFPA';

% Create one variable to receive the values of each sheet (original data).
saudaveis = xlsread(filename1, sheet1, 'b2:w61');
neuromielite = xlsread(filename1, sheet2, 'b2:x61');
esclerose = xlsread(filename1, sheet3, 'b2:q61');
%
saudaveis = saudaveis';
neuromielite = neuromielite';
esclerose = esclerose';

% Create *people_meas* matrix using vertcat to join all data.
% * (64 observations x 60 features)
people_meas = vertcat(saudaveis,neuromielite,esclerose);
% Create parameter status to compare with the predictions.
people_status = cell(size(people_meas,1),1);
for i=1:length(people_meas)
    if i <= size(saudaveis,1)
        people_status{i} = 'saudavel';
    elseif i <= size(saudaveis,1) + size(neuromielite,1)
        people_status{i} = 'neuromielite otica';
    else
        people_status{i} = 'esclerose multipla';
    end
end

% Assign label to the features.
[~,y] = size(people_meas);
features_label = cell(1,y);
for i=1:y
    features_label{i} = num2str(i);
end
clear y i

% Organizing Selected Features
best_feats = selFeatsNew;
best_featsLabel = cell(1,length(best_feats));
for i=1:length(best_feats)
    best_featsLabel{i} = num2str(best_feats(i));
end
clear i
X = people_meas;
Y = people_status;
%% DIVIDE THE DATA INTO TRAINING AND TEST SETS
% Here we divide the data for training and testing.
% Divides using kfold = 10
cpkfold = cvpartition(people_status,'k',10);

% Divides using holdout with 75% test size.
cpholdout = cvpartition(people_status,'holdout',0.25);
XtrainHO = X(training(cpholdout),:);
YtrainHO = Y(training(cpholdout),:);
XtestHO = X(test(cpholdout),:);
YtestHO = Y(test(cpholdout),:);

% Divides using leave one out.
cpleaveout = cvpartition(people_status,'leaveout');

%% GENERATING THE DEFAULT CLASSIFICATION TREE
% Generate the Decision Tree using the training sets.
% Generate the default tree using K-Fold partitions
%{
DefaultTreeKF01 = ClassificationTree.fit(XtrainKF,YtrainKF,...
    'PredictorNames',features_label);
view(DefaultTreeKF01, 'mode', 'graph');

DefaultTreeKF02 = ClassificationTree.fit(XtrainKF(:,best_feats),...
    YtrainKF,'PredictorNames',best_featsLabel);
view(DefaultTreeKF02, 'mode','graph');

% Generate the default tree using Holdout partitions
DefaultTreeHO01 = ClassificationTree.fit(XtrainHO,YtrainHO,...
    'PredictorNames',features_label);
%view(DefaultTreeHO01, 'mode', 'graph');

DefaultTreeHO02 = ClassificationTree.fit(XtrainHO(:,best_feats),...
    YtrainHO,'PredictorNames',best_featsLabel);
%view(DefaultTreeHO02, 'mode','graph');
%}
%% CROSS-VALIDATION ERROR
classf = @(XTRAIN, ytrain,XTEST)(predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST));
% Using k-fold
%{
err01 = zeros(cpkfold.NumTestSets,1);
err02 = zeros(cpkfold.NumTestSets,1);
for i = 1:cpkfold.NumTestSets
    trIdx = cpkfold.training(i);
    teIdx = cpkfold.test(i);
    ClassTree_Model01 = ClassificationTree.fit(X(trIdx,:),Y(trIdx));
    ClassTree_Model02 = ClassificationTree.fit(X(trIdx,best_feats),Y(trIdx));
    ytest01 = ClassTree_Model01.predict(X(teIdx,:));
    ytest02 = ClassTree_Model02.predict(X(teIdx,best_feats));
    err01(i) = sum(~strcmp(ytest01,Y(teIdx)));
    err02(i) = sum(~strcmp(ytest02,Y(teIdx)));
end
cvErrKF01 = sum(err01)/sum(cpkfold.TestSize)
cvErrKF02 = sum(err02)/sum(cpkfold.TestSize)
%}
cvErrKF_cv01 = crossval('mcr',people_meas,people_status,...
    'predfun',classf,'partition',cpkfold);
cvErrKF_cv02 = crossval('mcr',people_meas(:,best_feats),people_status,...
    'predfun',classf,'partition',cpkfold);

% Using Holdout
%predHO01 = DefaultTreeHO01.predict(XtestHO);
%cvErrHO01 = sum(~strcmp(predHO01,YtestHO))/cpholdout.TestSize
cvErr_cvHo01 = crossval('mcr',people_meas,people_status,...
    'predfun',classf,'partition',cpholdout);

%predHO02 = DefaultTreeHO02.predict(XtestHO(:,best_feats));
%cvErrHO02 = sum(~strcmp(predHO02,YtestHO))/cpholdout.TestSize
cvErr_cvHo02 = crossval('mcr',people_meas(:,best_feats),people_status,...
    'predfun',classf,'partition',cpholdout);

% Using Leave One Out
cvErrLO01 = crossval('mcr',people_meas,people_status,...
    'predfun',classf,'partition',cpleaveout);
cvErrLO02 = crossval('mcr',people_meas(:,best_feats),people_status,...
    'predfun',classf,'partition',cpleaveout);
%% RESULTS
% Here we gather the results and put into a matrix
results = cell(4,4);
results{2,1} = 'All Features';
results{3,1} = 'Selected Features';
results{4,1} = 'Gain Percentage';
results{1,2} = 'MCR K-fold Cross-Validation';
results{1,3} = 'MCR holdout Cross-Validation';
results{1,4} = 'MCR Leave Out Cross-Validation';
results{2,2} = cvErrKF_cv01;
results{3,2} = cvErrKF_cv02;
results{4,2} = (cvErrKF_cv01/cvErrKF_cv02 - 1) * 100;
%results{4,2} = sprintf('%f %%',((cvErrKF_cv01/cvErrKF_cv02 - 1) * 100));
results{2,3} = cvErr_cvHo01;
results{3,3} = cvErr_cvHo02;
results{4,3} = (cvErr_cvHo01/cvErr_cvHo02 - 1) * 100;
%results{4,3} = sprintf('%f %%',((cvErr_cvHo01/cvErr_cvHo02 - 1) * 100));
results{2,4} = cvErrLO01;
results{3,4} = cvErrLO02;
results{4,4} = (cvErrLO01/cvErrLO02 - 1) * 100;
%results{4,4} = sprintf('%f %%',((cvErrLO01/cvErrLO02 - 1) * 100));
% Open results
%openvar('results');

%% TRAIN THE FINAL TREE USING ALL SUBJECTS AND SELECTED FEATURES
tree = ClassificationTree.fit(X(:,selFeatsNew), Y, ...
    'PredictorNames',best_featsLabel);
%view(tree, 'mode','graph');

%% DRAW THE DARTBOARD WITH THE EXTRACTED FEATURES
extracted_feats = extractFeatures(tree);
%draw_Dartboard(extracted_feats);

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
%% PERFORM FORWARD SEQUENTIAL FEATURE SELECTION WITH 2B2 CLASSES and p=.05 and p=.01
% Two diseases classes
[fs01_minus_saudavel,fs05_minus_saudavel] = forwardFeatSelNew(X_minus_saudavel,Y_minus_saudavel,' for two diseases classes with sfs and filter');
draw_Dartboard(fs01_minus_saudavel,' for two diseases classes with sfs and filter p=.01');
draw_Dartboard(fs05_minus_saudavel,' for two diseases classes with sfs and filter p=.05');
% Healthy and sclerosis classes
[fs01_minus_neuromielite,fs05_minus_neuromielite] = forwardFeatSelNew(X_minus_neuromielite,Y_minus_neuromielite,' for healthy and sclerosis classes with sfs and filter');
draw_Dartboard(fs01_minus_neuromielite,' for healthy and sclerosis classes with sfs and filter p=.01');
draw_Dartboard(fs05_minus_neuromielite,' for healthy and sclerosis classes with sfs and filter p=.05');
% Healthy and neuromielite classes
[fs01_minus_esclerose,fs05_minus_esclerose] = forwardFeatSelNew(X_minus_esclerose,Y_minus_esclerose,' for healthy and neuromielite classes with sfs and filter');
draw_Dartboard(fs01_minus_esclerose,' for healthy and neuromielite classes with sfs and filter p=.01');
draw_Dartboard(fs05_minus_esclerose,' for healthy and neuromielite classes with sfs and filter p=.05');
% Healthy and 2 diseases without distinction
[fs01_saudavel_doente,fs05_saudavel_doente] = forwardFeatSelNew(X,Y_saudavel_doente,' for healthy and 2 diseases classes with forward sfs and filter');
draw_Dartboard(fs01_saudavel_doente,' for healthy and 2 diseases classes with sfs and filter p=.01');
draw_Dartboard(fs05_saudavel_doente,' for healthy and 2 diseases classes with sfs and filter p=.05');
%% Saves selected features
% Saves selected features from both cross-validation and forward sequential
% feature selection methods
save('selected_features.mat','extracted_feats',...
    'extracted_feats_minus_esclerose','extracted_feats_minus_neuromielite',...
    'extracted_feats_minus_saudavel','fs_selected_feats_minus_esclerose',...
    'fs_selected_feats_minus_neuromielite','fs_selected_feats_minus_saudavel',...
    'fs_selected_feats_saudavel_doente');

% Filter and SFS p=.01 and p=.05

save('last_selected_features.mat','fs01_minus_esclerose',...
    'fs01_minus_neuromielite','fs01_minus_saudavel',...
    'fs01_saudavel_doente','fs05_minus_esclerose',...
    'fs05_minus_neuromielite','fs05_minus_saudavel',...
    'fs05_saudavel_doente');
%% COMPARES THE SELECTED FEATURES
%{
[results_minus_saudavel,eval_results_minus_saudavel] = compareFeatures(X_minus_saudavel,Y_minus_saudavel,...
    extracted_feats_minus_saudavel,fs_selected_feats_minus_saudavel);
[results_minus_neuromielite,eval_results_minus_neuromielite] = compareFeatures(X_minus_neuromielite,Y_minus_neuromielite,...
    extracted_feats_minus_neuromielite,fs_selected_feats_minus_neuromielite);
[results_minus_esclerose,eval_results_minus_esclerose] = compareFeatures(X_minus_esclerose,Y_minus_esclerose,...
    extracted_feats_minus_esclerose,fs_selected_feats_minus_esclerose);
%}
features_selec = unique(horzcat(fs01_minus_esclerose,fs01_minus_neuromielite,fs01_minus_saudavel,fs01_saudavel_doente));

[results_minus_saudavel,eval_results_minus_saudavel] = compareFeatures(X_minus_saudavel,Y_minus_saudavel,...
    fs05_minus_saudavel,allfeatures);
[results_minus_neuromielite,eval_results_minus_neuromielite] = compareFeatures(X_minus_neuromielite,Y_minus_neuromielite,...
    fs01_minus_neuromielite,allfeatures);
[results_minus_esclerose,eval_results_minus_esclerose] = compareFeatures(X_minus_esclerose,Y_minus_esclerose,...
    fs01_minus_esclerose,allfeatures);
[results_saudavel_doente,eval_results_saudavel_doente] = compareFeatures(X,Y_saudavel_doente,...
    fs01_saudavel_doente,allfeatures);
[results_all,eval_results_all] = compareFeatures(X,Y,...
    features_selec,allfeatures);
%% GENERATING THE CLASSIFICATION TREES
% Generate the Decision Trees for each combination with the selected
% features.
% Two diseases classes
Tree_minus_saudavel = ClassificationTree.fit(X_minus_saudavel,Y_minus_saudavel,...
    'PredictorNames',features_label);
view(Tree_minus_saudavel, 'mode', 'graph');

% Healthy and sclerosis classes
Tree_minus_neuromielite = ClassificationTree.fit(X_minus_neuromielite(:,health_and_sclerosis),...
    Y_minus_neuromielite,'PredictorNames',feats_minus_neuromielite);
view(Tree_minus_neuromielite, 'mode', 'graph');

% Healthy and neuromielite classes
Tree_minus_esclerose = ClassificationTree.fit(X_minus_esclerose(:,health_and_neuromielite),...
    Y_minus_esclerose,'PredictorNames',feats_minus_esclerose);
view(Tree_minus_esclerose, 'mode', 'graph');

% Healthy and 2 diseases as one class
Tree_saudavel_doente = ClassificationTree.fit(X(:,health_two_diseases),...
    Y_saudavel_doente,'PredictorNames',feats_saudavel_doente);
view(Tree_saudavel_doente, 'mode', 'graph');

% All classes
Tree_all_classes = ClassificationTree.fit(X(:,features_selec),...
    Y,'PredictorNames',features_selec_label);
view(Tree_all_classes, 'mode', 'graph');