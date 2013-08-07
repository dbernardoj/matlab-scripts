%% CLASSIFICATION USING DECISION TREE
% THIS ARTICLE USE THE TECHNIQUES OF DECISION TREE TO CLASSIFY THE DATA OF
% A MFVEP TEST IN TWO GROUPS OF PEOPLE, THE ONES THAT ARE HEALTHY AND THE
% ONES THAT ARE WITH SOME KIND OF EYE ILLNESS. WE USE FEATURE SELECTION TO
% REDUCE THE RAW DATA 60 FEATURES, USING THE CROSS-VALIDATION METHOD AS
% PARAMETER TO EVALUATE THE FEATURES.

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
% Place variables to point to the raw data in the Excell format.
user = getenv('USER');
%{
filename1 = '/Users/pma007/Dropbox/TCC/Dados/Dados mfVEP.xlsx';
filename2 = '/Users/pma007/Dropbox/TCC/Dados/Dados mfVEP Reduzido.xlsx';
status_fn = '/Users/pma007/Dropbox/TCC/Dados/status mfVEP.xlsx';
%}

filename1 = sprintf('/Users/%s/Dropbox/TCC/Dados/Dados mfVEP.xlsx',user);
filename2 = ...
    sprintf('/Users/%s/Dropbox/TCC/Dados/Dados mfVEP Reduzido.xlsx',user);
status_fn = sprintf('/Users/%s/Dropbox/TCC/Dados/status mfVEP.xlsx',user);
fileBest = sprintf('/Users/%s/Dropbox/TCC/Dados/Best Feats.csv',user);

% * EXPORTING THE DATA
%
% Place variables to point to where the results will be written.

featWrite = sprintf('/Users/%s/Dropbox/TCC/Dados/Key Features.xlsx',user);
predictWrite = ...
    sprintf('/Users/%s/Dropbox/TCC/Dados/Key Features.xlsx',user);
bestFeats = sprintf('/Users/%s/Dropbox/TCC/Dados/Best Feats.xlsx', user);

%{
featWrite = '/Users/iraquitanfilho/Dropbox/TCC/Dados/Key Features.xlsx';
predictWrite = '/Users/iraquitanfilho/Dropbox/TCC/Dados/Predictions.xlsx';
%}
%% PROCESSING THE DATA
% First specify the sheet names for the Excell raw data.

sheet1 = 'Saudavel 1';
sheet2 = 'Doentes 1';
sheet3 = 'Saudavel 2';
sheet4 = 'Doentes 2';

% Create one variable to receive the values of each sheet (original data).

saudaveis1 = xlsread(filename1, sheet1, 'a1:p60');
doentes1 = xlsread(filename1, sheet2, 'a1:p60');
saudaveis2 = xlsread(filename1, sheet3, 'a1:p60');
doentes2 = xlsread(filename1, sheet4, 'a1:p60');

%{
% Create one variable to receive the values of each sheet (reduced data).

saudaveis1 = xlsread(filename2, sheet1, 'b1:q32');
doentes1 = xlsread(filename2, sheet2, 'b1:q32');
saudaveis2 = xlsread(filename2, sheet3, 'b1:q32');
doentes2 = xlsread(filename2, sheet4, 'b1:q32');
%}

saudaveis1 = saudaveis1';
saudaveis2 = saudaveis2';
doentes1 = doentes1';
doentes2 = doentes2';

% Create *people_meas* matrix using vertcat to join all data.
% * (64 observations x 60 features)
people_meas = vertcat(saudaveis1,saudaveis2,doentes1,doentes2);

% Create *people_status* matrix.
[~,~,people_status] = xlsread(status_fn);

% Assing label to the features.
[~,y] = size(people_meas);
features_label = cell(1,y);
for i=1:y
    features_label{i} = num2str(i);
end
clear y i

best_feats = csvread(fileBest);
best_featsLabel = cell(1,length(best_feats));
for i=1:length(best_feats)
    best_featsLabel{i} = num2str(best_feats(i));
end
clear i

% Inputs to predict
new1 = xlsread(filename1, sheet1, 'b1:w60');
new2 = xlsread(filename1, sheet2, 'b1:x60');
new3 = xlsread(filename1, sheet3, 'b1:z60');
new4 = xlsread(filename1, sheet4, 'b1:q60');
new = horzcat(new1, new2, new3, new4);
newinput = new';
clear new1 new2 new3 new4 new

% Create parameter status to compare with the predictions.
parameter_status = cell(82,1);
for i=1:length(newinput)
    if i <= 21
        parameter_status{i} = 'saudavel';
    elseif i <= 43
        parameter_status{i} = 'doente';
    elseif i <= 67
        parameter_status{i} = 'saudavel';
    else
        parameter_status{i} = 'doente';
    end
end

% Selecting 4 from each group to training set
[train_sd1,train_sd1_idx] = datasample(saudaveis1,4,1,'Replace',false);
[train_sd2,train_sd2_idx] = datasample(saudaveis2,4,1,'Replace',false);
[train_dt1,train_dt1_idx] = datasample(doentes1,4,1,'Replace',false);
[train_dt2,train_dt2_idx] = datasample(doentes2,4,1,'Replace',false);

%{
function statusfun(x)
status = cell(size(x,1),1);
for i=1:length(status)
    if i < length(x)/2
        status{i} = 'saudavel';
    else
        status{i} = 'doente';
    end
end
end
%}

train_x = vertcat(train_sd1,train_sd2,train_dt1,train_dt2);
train_y = cell(size(train_x,1),1);
for i=1:length(train_y)
    if i <= length(train_y)/2
        train_y{i} = 'saudavel';
    else
        train_y{i} = 'doente';
    end
end
%train_y = cellfun(@(x) x(1:8,'saudavel') , train_y);

test_sd1 = removerows(saudaveis1,train_sd1_idx);
test_sd2 = removerows(saudaveis2,train_sd2_idx);
test_dt1 = removerows(doentes1,train_dt1_idx);
test_dt2 = removerows(doentes2,train_dt2_idx);

test_x = vertcat(test_sd1,test_sd2,test_dt1,test_dt2);
test_y = cell(size(test_x,1),1);
for i=1:length(test_y)
    if i <= length(test_y)/2
        test_y{i} = 'saudavel';
    else
        test_y{i} = 'doente';
    end
end

%% DIVINDE THE DATA INTO TRAINING AND TEST SETS
% Here we divide the data for training and testing.
% Divides using kfold = 10
cpkfold = cvpartition(parameter_status,'k',10);
% Divides using holdout with 75% test size.
cpholdout = cvpartition(parameter_status,'holdout',0.75);
%% GENERATING THE DEFAULT CLASSIFICATION TREE

% Generate the default tree
DefaultTree01 = ClassificationTree.fit(people_meas,people_status,...
    'PredictorNames',features_label);
%view(DefaultTree01, 'mode', 'graph');

DefaultTree02 = ClassificationTree.fit(people_meas(:,best_feats),...
    people_status,'PredictorNames',best_featsLabel);
%view(DefaultTree02, 'mode','graph');
%% RESUBSTITUTION ERROR
% Computes resubstitution error for decision trees.
%resubErr01 = resubLoss(DefaultTree01);
%resubErr02 = resubLoss(DefaultTree02);
dtclass01 = DefaultTree01.predict(people_meas);
bad01 = ~strcmp(dtclass01,people_status);
dtResubErr01 = sum(bad01) / length(people_status)

dtclass02 = DefaultTree02.predict(people_meas(:,best_feats));
bad02 = ~strcmp(dtclass02,people_status);
dtResubErr02 = sum(bad02) / length(people_status)
%% CROSS_VALIDATION ERROR
% Computes cross-validation error for decision trees.
% Classification function handler
dtClassFun = @(xtrain,ytrain,xtest)...
    (predict(ClassificationTree.fit(xtrain,ytrain),xtest));
dtClassFun01 = @(xtrain,ytrain,xtest)...
    (predict(DefaultTree01,xtest));
dtClassFun02 = @(xtrain,ytrain,xtest)...
    (predict(DefaultTree02,xtest));
%% CROSS VALIDATION USING KFOLD PARTITION
% Here we use the partition created with kfold
dtCVkf01 = zeros(1,100);
for i=1:100
    dtCVkf01(i) = crossval('mcr',newinput,parameter_status,'predfun',...
        dtClassFun01,'partition',cpkfold);
end
dtCVkfErr01 = mean(dtCVkf01)
dtCVkf02 = zeros(1,100);
for i=1:100
    dtCVkf02(i) = crossval('mcr',newinput(:,best_feats),...
        parameter_status,'predfun',dtClassFun02,'partition',cpkfold);
end
dtCVkfErr02 = mean(dtCVkf02)
%% CROSS VALIDATION USING HOLDOUT PARTITION
% Here we use the partition created with holdout
dtCVho01 = zeros(1,100);
for i=1:100
    dtCVho01(i) = crossval('mcr',newinput,parameter_status,'predfun',...
        dtClassFun01,'partition',cpholdout);
end
dtCVhoErr01 = mean(dtCVho01)
dtCVho02 = zeros(1,100);
for i=1:100
    dtCVho02(i) = crossval('mcr',newinput(:,best_feats),...
        parameter_status,'predfun',dtClassFun02,'partition',cpholdout);
end
dtCVhoErr02 = mean(dtCVho02)
%% COMPUTES CROSS-VALIDATION ERROR FOR DEFAULT TREES
%cvErrors01 = zeros(1,100);
%cvErrors02 = zeros(1,100);
%for i=1:100
%    cvErrors01(i) = kfoldLoss(crossval(DefaultTree01));
%    cvErrors02(i) = kfoldLoss(crossval(DefaultTree02));
%end
%cvErr01 = mean(cvErrors01)
%cvErr02 = mean(cvErrors02)
%% USE FITTED MODEL FOR PREDICTIONS
%
% Predict new inputs using the Classification Tree
YpredictedDefault01 = predict(DefaultTree01, newinput);
YpredictedDefault02 = predict(DefaultTree02, newinput(:,best_feats));

%w0 = xlswrite(predictWrite,YpredictedDefault);

%% COMPARE THE PREDICTIONS WITH THE PARAMETER
%
score01 = sum(~strcmp(parameter_status,YpredictedDefault01));
score02 = sum(~strcmp(parameter_status,YpredictedDefault02));

%error01 = sum(~strcmp(parameter_status,YpredictedDefault01));
%error02 = sum(~strcmp(parameter_status,YpredictedDefault02));

% Shows the scores of the predictions in percentage.
disp(fprintf('Score for DefaultTree01 = %f\n',...
    score01/length(parameter_status)));
disp(fprintf('Score for DefaultTree02 = %f\n',...
    score02/length(parameter_status)));