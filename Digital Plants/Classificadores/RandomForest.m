%% CLASSIFICATION USING RANDOM FOREST
% THIS SCRIPT USE THE TECHNIQUES OF RANDOM FOREST TO CLASSIFY THE DATA OF
% PLANTS LEAFS

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
%% LOAD DATA

%% DIVIDE DATA INTO TEST AND TRAINING SET
X = load('x_train.csv');
Y = load('y_train.csv');

cvpart = cvpartition(Y,'holdout',0.3);
Xtrain = X(training(cvpart),:);
Ytrain = Y(training(cvpart),:);
Xtest = X(test(cvpart),:);
Ytest = Y(test(cvpart),:);

%% TRAIN A CLASSIFIER USING RANDOM FOREST
bag = fitensemble(Xtrain,Ytrain,'Bag',400,'Tree',...
    'type','classification');

figure;
plot(loss(bag,Xtest,Ytest,'mode','cumulative'));
xlabel('Number of trees');
ylabel('Test classification error');

[predtest, scores] = bag.predict(Xtest);
%scores_norm = norm_score(scores);
scores_final = replaceonezero(scores(:,2));
logloss(Ytest,scores_final)