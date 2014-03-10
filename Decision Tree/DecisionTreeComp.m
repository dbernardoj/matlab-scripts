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
load('selFeats01');
% Place variables to point to the raw data in the Excell format.
user = getenv('USER');
%{
filename1 = '/Users/pma007/Dropbox/TCC/Dados/Dados mfVEP.xlsx';
filename2 = '/Users/pma007/Dropbox/TCC/Dados/Dados mfVEP Reduzido.xlsx';
status_fn = '/Users/pma007/Dropbox/TCC/Dados/status mfVEP.xlsx';
%}

prompt = 'What data do you want to work on? (1-Old | 2-New): ';
asw = input(prompt);
pass = false;
while pass == false
    switch asw
        case 1
            filename1 = sprintf('/Users/%s/Dropbox/TCC/Dados/Dados mfVEP.xlsx',user);
            %filename2 = sprintf('/Users/%s/Dropbox/TCC/Dados/Dados mfVEP Reduzido.xlsx',user);
            status_fn = sprintf('/Users/%s/Dropbox/TCC/Dados/status mfVEP.xlsx',user);
            pass = true;
        case 2
            filename1 = sprintf('/Users/%s/Dropbox/TCC/Dados/Dados mfVEP - Novos.xlsx',user);
            pass = true;
        otherwise
            asw = input(prompt);
    end
end

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

if asw == 1
    sheet1 = 'Saudavel 1';
    sheet2 = 'Doentes 1';
    sheet3 = 'Saudavel 2';
    sheet4 = 'Doentes 2';
elseif asw == 2
    sheet1 = 'UFPA';
    sheet2 = 'Neuromielite optica UFPA';
    sheet3 = 'Esclerose Multipla UFPA';
end

% Create one variable to receive the values of each sheet (original data).

if asw == 1
    saudaveis1 = xlsread(filename1, sheet1, 'a1:p60');
    doentes1 = xlsread(filename1, sheet2, 'a1:p60');
    saudaveis2 = xlsread(filename1, sheet3, 'a1:p60');
    doentes2 = xlsread(filename1, sheet4, 'a1:p60');
    %
    saudaveis1 = saudaveis1';
    doentes1 = doentes1';
    saudaveis2 = saudaveis2';
    doentes2 = doentes2';
elseif asw == 2
    saudaveis = xlsread(filename1, sheet1, 'b2:w61');
    neuromielite = xlsread(filename1, sheet2, 'b2:x61');
    esclerose = xlsread(filename1, sheet3, 'b2:q61');
    %
    saudaveis = saudaveis';
    neuromielite = neuromielite';
    esclerose = esclerose';
end

% Create *people_meas* matrix using vertcat to join all data.
% * (64 observations x 60 features)
if asw == 1
    people_meas = vertcat(saudaveis1,saudaveis2,doentes1,doentes2);
% Create *people_status* matrix.
    [~,~,people_status] = xlsread(status_fn);
elseif asw == 2
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
end

% Assing label to the features.
[~,y] = size(people_meas);
features_label = cell(1,y);
for i=1:y
    features_label{i} = num2str(i);
end
clear y i

% Organizing Selected Features
prompt = 'What selected features do you want to use? (1-Old | 2-New): ';
aswsf = input(prompt);
pass = false;
while pass == false
    switch aswsf
        case 1
            best_feats = csvread(fileBest);
            best_featsLabel = cell(1,length(best_feats));
            for i=1:length(best_feats)
                best_featsLabel{i} = num2str(best_feats(i));
            end
            clear i
            pass = true;
        case 2
            best_feats = selFeatsNew;
            best_featsLabel = cell(1,length(best_feats));
            for i=1:length(best_feats)
                best_featsLabel{i} = num2str(best_feats(i));
            end
            clear i
            pass = true;
        otherwise
            aswsf = input(prompt);
    end
end

% Inputs to predict
if asw == 1
    new1 = xlsread(filename1, sheet1, 'b1:w60');
    new2 = xlsread(filename1, sheet2, 'b1:x60');
    new3 = xlsread(filename1, sheet3, 'b1:z60');
    new4 = xlsread(filename1, sheet4, 'b1:q60');
    new = horzcat(new1, new2, new3, new4);
    newinput = new';
    clear new1 new2 new3 new4 new
end

% Create parameter status to compare with the predictions.
if asw == 1
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
end

% Selecting n from each group to training set
pass = false;
while pass == false
    nsample = input('Enter a number of samples to be selected for each group: ');
    if isnumeric(nsample)
        pass = true;
    end
end
if asw == 1
    [train_sd1,train_sd1_idx] = datasample(saudaveis1,nsample,1,'Replace',false);
    [train_sd2,train_sd2_idx] = datasample(saudaveis2,nsample,1,'Replace',false);
    [train_dt1,train_dt1_idx] = datasample(doentes1,nsample,1,'Replace',false);
    [train_dt2,train_dt2_idx] = datasample(doentes2,nsample,1,'Replace',false);
elseif asw == 2
    [train_sd,train_sd_idx] = datasample(saudaveis,nsample,1,'Replace',false);
    [train_nm,train_nm_idx] = datasample(neuromielite,nsample,1,'Replace',false);
    [train_em,train_em_idx] = datasample(esclerose,nsample,1,'Replace',false);
end

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

% Assign label for train data
if asw == 1
    train_x = vertcat(train_sd1,train_sd2,train_dt1,train_dt2);
    train_y = cell(size(train_x,1),1);
    for i=1:length(train_y)
        if i <= length(train_y)/2
            train_y{i} = 'saudavel';
        else
            train_y{i} = 'doente';
        end
    end
elseif asw == 2
    train_x = vertcat(train_sd,train_nm,train_em);
    train_y = cell(size(train_x,1),1);
    for i=1:length(train_y)
        if i <= nsample
            train_y{i} = 'saudavel';
        elseif i <= nsample * 2
            train_y{i} = 'neuromielite otica';
        else
            train_y{i} = 'esclerose multipla';
        end
    end
end
%train_y = cellfun(@(x) x(1:8,'saudavel') , train_y);

% Determining the Test Set
if asw == 1
    test_sd1 = removerows(saudaveis1,train_sd1_idx);
    test_sd2 = removerows(saudaveis2,train_sd2_idx);
    test_dt1 = removerows(doentes1,train_dt1_idx);
    test_dt2 = removerows(doentes2,train_dt2_idx);
elseif asw == 2
    test_sd = removerows(saudaveis,train_sd_idx);
    test_nm = removerows(neuromielite,train_nm_idx);
    test_em = removerows(esclerose,train_em_idx);
end

if asw == 1
    test_x = vertcat(test_sd1,test_sd2,test_dt1,test_dt2);
    test_y = cell(size(test_x,1),1);
    for i=1:length(test_y)
        if i <= length(test_y)/2
            test_y{i} = 'saudavel';
        else
            test_y{i} = 'doente';
        end
    end
elseif asw == 2
    test_x = vertcat(test_sd,test_nm,test_em);
    test_y = cell(size(test_x,1),1);
    for i=1:length(test_y)
        if i <= size(saudaveis,1) - nsample
            test_y{i} = 'saudavel';
        elseif i<= (size(saudaveis,1) - nsample) + (size(neuromielite,1) - nsample)
            test_y{i} = 'neuromielite otica';
        else
            test_y{i} = 'esclerose multipla';
        end
    end
end

%% DIVIDE THE DATA INTO TRAINING AND TEST SETS
% Here we divide the data for training and testing.
if asw == 1
% Divides using kfold = 10
    cpkfold = cvpartition(people_status,'k',5);
% Divides using holdout with 75% test size.
    cpholdout = cvpartition(people_status,'holdout',0.75);
elseif asw == 2
% Divides using kfold = 10
    cpkfold = cvpartition(people_status,'k',5);
% Divides using holdout with 75% test size.
    cpholdout = cvpartition(people_status,'holdout',0.75);
end
%% GENERATING THE DEFAULT CLASSIFICATION TREE

prompt = 'How do you want to generate the Decision Tree? (1-All data | 2-Train data): ';
aswtree = input(prompt);
pass = false;
while pass == false
    switch aswtree
        case 1
            % Generate the default tree
            DefaultTree01 = ClassificationTree.fit(people_meas,people_status,...
                'PredictorNames',features_label);
            view(DefaultTree01, 'mode', 'graph');

            DefaultTree02 = ClassificationTree.fit(people_meas(:,best_feats),...
                people_status,'PredictorNames',best_featsLabel);
            view(DefaultTree02, 'mode','graph');
            pass = true;
        case 2
            % Generate the default tree
            DefaultTree01 = ClassificationTree.fit(train_x,train_y,...
                'PredictorNames',features_label);
            view(DefaultTree01, 'mode', 'graph');

            DefaultTree02 = ClassificationTree.fit(train_x(:,best_feats),...
                train_y,'PredictorNames',best_featsLabel);
            view(DefaultTree02, 'mode','graph');
            pass = true;
        otherwise
            asw = input(prompt);
    end
end
%% FEATURE SELECTION USING CROSS-VALIDATION ON CLASSIFICATION TREE
%{
% Here we use cross-validation on the Classification Tree as a method to
% select the most discriminant features, by selecting the features most
% used in the cross-validation procedure of the classification tree.

keyFeaturesTemp01 = [];
keyCutPointsTemp01 = [];

% Here we repeat the process 100 times to select the features
for n=1:100
    % Cross validate the tree
    cvDefaultTree01 = crossval(DefaultTree01,'kfold',5);
    for i=1:5
        % Extract features and cut points from all ten trees generated by
        % cross-validation
        noRepeatFeatsTmp01 = unique(cvDefaultTree01.Trained{i}.CutVar);
        keyFeaturesTemp01 = vertcat(keyFeaturesTemp01,noRepeatFeatsTmp01);

        %noRepeatCutPTmp01 = unique(cvDefaultTree01.Trained{i}.CutPoint);
        %keyCutPointsTemp01 = vertcat(keyCutPointsTemp01,noRepeatCutPTmp01);
    end
end

% Remove empties from keyFeaturesTemp and keyCutPointsTemp
keyFeaturesTemp1 = keyFeaturesTemp01(~cellfun('isempty',keyFeaturesTemp01));
%keyCutPoints01 = keyCutPointsTemp01(~arrayfun(@isnan,keyCutPointsTemp01));

% Converting cell array to numeric array
[m1,~] = size(keyFeaturesTemp1);
keyFeatures01 = zeros(m1,1);
for i=1:m1
    keyFeatures01(i) = str2double(keyFeaturesTemp1{i});
end

% Clear temp variables
clearvars keyFeaturesTemp01 keyFeaturesTemp1 keyCutPointsTemp01 ...
    noRepeatFeatsTmp01 noRepeatCutPTmp01

% Concatenate the features with their cut points values
%Feats = horzcat(keyFeatures,keyCutPoints);

% Export features to CSV
%csv_feats = sprintf('/Users/%s/Dropbox/TCC/Dados/teste-features.csv',user);
%cell2csv(csv_feats, keyFeatures01);

% Write the features and cut points to excell
%w1 = xlswrite(featWrite, Feats);

% Plot histogram graph to show the most used features.
figure;
nelements = hist(keyFeatures01,60);
xcenters = (1:1:60);
bar(xcenters,nelements);
title('Feature Selection using Cross-Validation Tree01');
xlabel('Features');
ylabel('Repetition');
colormap summer
grid on

% Find the features with a threshold
selFeats = find(nelements >= 100);
%selFeatsNew = selFeats;
%}
%% RESUBSTITUTION ERROR
% Computes resubstitution error for decision trees.
dt01ResubErr = resubLoss(DefaultTree01)
dt02ResubErr = resubLoss(DefaultTree02)

%dtclass01 = DefaultTree01.predict(train_x);
%bad01 = ~strcmp(dtclass01,train_y);
%dt01ResubErr = sum(bad01) / length(people_status)

%dtclass02 = DefaultTree02.predict(train_x(:,best_feats));
%bad02 = ~strcmp(dtclass02,train_y);
%dt02ResubErr = sum(bad02) / length(people_status)
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
if asw == 1
% Here we use the partition created with kfold
    dt01CVkf = zeros(1,100);
    for i=1:100
        dt01CVkf(i) = crossval('mcr',newinput,parameter_status,'predfun',...
            dtClassFun01,'partition',cpkfold);
    end
    dt01CVkfErr = mean(dt01CVkf)
    dt02CVkf = zeros(1,100);
    for i=1:100
        dt02CVkf(i) = crossval('mcr',newinput(:,best_feats),...
            parameter_status,'predfun',dtClassFun02,'partition',cpkfold);
    end
    dt02CVkfErr = mean(dt02CVkf)
elseif asw == 2
% Here we use the partition created with kfold
    dt01CVkf = zeros(1,100);
    for i=1:100
        dt01CVkf(i) = crossval('mcr',people_meas,people_status,'predfun',...
            dtClassFun01,'partition',cpkfold);
    end
    dt01CVkfErr = mean(dt01CVkf)
    dt02CVkf = zeros(1,100);
    for i=1:100
        dt02CVkf(i) = crossval('mcr',people_meas(:,best_feats),...
            people_status,'predfun',dtClassFun02,'partition',cpkfold);
    end
    dt02CVkfErr = mean(dt02CVkf)    
end
%% CROSS VALIDATION USING HOLDOUT PARTITION
if asw == 1
% Here we use the partition created with holdout
    dt01CVho = zeros(1,100);
    for i=1:100
        dt01CVho(i) = crossval('mcr',newinput,parameter_status,'predfun',...
            dtClassFun01,'partition',cpholdout);
    end
    dt01CVhoErr = mean(dt01CVho)
    dt02CVho = zeros(1,100);
    for i=1:100
        dt02CVho(i) = crossval('mcr',newinput(:,best_feats),...
            parameter_status,'predfun',dtClassFun02,'partition',cpholdout);
    end
    dt02CVhoErr = mean(dt02CVho)
elseif asw == 2
% Here we use the partition created with holdout
    dt01CVho = zeros(1,100);
    for i=1:100
        dt01CVho(i) = crossval('mcr',people_meas,people_status,'predfun',...
            dtClassFun01,'partition',cpholdout);
    end
    dt01CVhoErr = mean(dt01CVho)
    dt02CVho = zeros(1,100);
    for i=1:100
        dt02CVho(i) = crossval('mcr',people_meas(:,best_feats),...
            people_status,'predfun',dtClassFun02,'partition',cpholdout);
    end
    dt02CVhoErr = mean(dt02CVho)
end
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
%YpredictedDefault01 = predict(DefaultTree01, newinput);
%YpredictedDefault02 = predict(DefaultTree02, newinput(:,best_feats));

%w0 = xlswrite(predictWrite,YpredictedDefault);

%% COMPARE THE PREDICTIONS WITH THE PARAMETER
%
%score01 = sum(~strcmp(parameter_status,YpredictedDefault01));
%score02 = sum(~strcmp(parameter_status,YpredictedDefault02));

%error01 = sum(~strcmp(parameter_status,YpredictedDefault01));
%error02 = sum(~strcmp(parameter_status,YpredictedDefault02));

% Shows the scores of the predictions in percentage.
%disp(fprintf('Score for DefaultTree01 = %f\n',...
%    score01/length(parameter_status)));
%disp(fprintf('Score for DefaultTree02 = %f\n',...
%    score02/length(parameter_status)));
%% RESULTS
% Here we gather the results and put into a matrix
results = cell(3,4);
results{2,1} = 'All Features';
results{3,1} = 'Selected Features';
results{1,2} = 'MCE Resubstitution';
results{1,3} = 'MCE K-fold Cross-Validation';
results{1,4} = 'MCE Holdout Cross-Validation';
results{2,2} = dt01ResubErr;
results{3,2} = dt02ResubErr;
results{2,3} = dt01CVkfErr;
results{3,3} = dt02CVkfErr;
results{2,4} = dt01CVhoErr;
results{3,4} = dt02CVhoErr;