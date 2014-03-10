%% TITANIC CONTEST
% IMPLEMENTS A CLASSIFIER USING RANDOM FOREST TO PREDICT TITANIC SURVIVORS
%% PRELIMINARIES
% Clear our workspace
clear all
clc
rehash
% Close all figures
close all
%% IMPORTING DATA
load train_data.mat
load test_data.mat
load sel_feats.mat
%% PROCESSING TRAINING DATA
%selected_feats = forwardfeatsel(X_TRAIN,y_train);
%{
allfeatures = zeros(1,size(X_TRAIN,2));
for i=1:size(X_TRAIN,2)
    allfeatures(i) = i;
end

tenfoldCVP = cvpartition(y_train,'kfold',10);

classf = @(XTRAIN,ytrain,XTEST,ytest)(sum(~strcmp(ytest,predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST))));

fsLocal = sequentialfs(classf,X_TRAIN,y_train,'cv',tenfoldCVP);

fsCVLocal = allfeatures(fsLocal)
%}
% Select the features to use in the model
X_train = X_TRAIN(:,selected_feats);
Y_train = y_train;
%% PROCESSING TEST DATA
% Data to predict and send
X_test = X_TEST(:,selected_feats);
%% DIVIDING DATA
cvpart = cvpartition(y_train,'kfold',10);
%cvpart = cvpartition(Y,'leaveout');
%Xtrain = X(training(cvpart),:);
%Ytrain = Y(training(cvpart),:);
%Xtest = X(test(cvpart),:);
%Ytest = Y(test(cvpart),:);
%% COMPUTE CROSS_VALIDATION MISCLASSIFICATION ERROR

% Ensemble of Decision Tree Classifier
classf_rf = @(XTRAIN,ytrain,XTEST)(predict(fitensemble(XTRAIN,ytrain,...
    'Bag',500,'Tree','type','classification'),XTEST));
mcr_rf = crossval('mcr',X_train,Y_train,'predfun',classf_rf,...
    'partition',cvpart);

% Decision Tree Classifier
classf_dt = @(XTRAIN,ytrain,XTEST)(predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST));
mcr_dt = crossval('mcr',X_train,Y_train,'predfun',classf_dt,...
    'partition',cvpart);
%% TRAIN A CLASSIFIER USING RANDOM FOREST
bag = fitensemble(X_train,Y_train,'Bag',500,'Tree',...
    'type','classification');
%{
figure;
plot(loss(bag,Xtest,Ytest,'mode','cumulative'));
xlabel('Number of trees');
ylabel('Test classification error');
%}
%% TRAIN A CLASSIFIER USING DECISION TREE
% Fit a Decision Tree Classifier
tree = ClassificationTree.fit(X_train,Y_train);
%% PREDICT TEST SET AND TEST FULL
[predtest_rf, scores_rf] = bag.predict(X_test);
[predtest_dt, scores_dt] = tree.predict(X_test);
%% EVALUATE LOGARITHMIC LOSS
%logloss1 = log_loss(Ytest,predtest1)
%log_loss(Ytest,predttest)
%% EVALUATE PREDICT PERFORMANCE
%errb = sum(~arrayfun(@ismember,predtest1,Ytest))/length(Ytest)
%errt = sum(~arrayfun(@ismember,predttest,Ytest))/length(Ytest)
%% WRITE SUBMISSION FILE
% Put in the predicition in numeric format
predtest_rf_final = conv_to_num(predtest_rf);
predtest_dt_final = conv_to_num(predtest_dt);

% Ids for output format
pID = zeros(size(X_test,1),1);
for i=1:size(X_test,1)
    pID(i) = i;
end

% Convert cell of strings to array of doubles.
predtest_rf = predtest_rf_final;
predtest_dt = predtest_dt_final;

results_rf_struct = struct('Id', pID, 'Genres', predtest_rf);
results_rf = struct2array(results_rf_struct);
csvwrite_with_headers('ResultsRandomForest.csv',results_rf,{'Id','Genres'});

results_dt_struct = struct('Id', pID, 'Genres', predtest_dt);
%results_dt = conv_struct_2_array(results_dt_struct);
results_dt = struct2array(results_dt_struct);
csvwrite_with_headers('ResultsDecitionTree.csv',results_dt,{'Id','Genres'});