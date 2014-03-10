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

prompt = 'What data do you want to work on? [1-Old | 2-New]';
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
            status_fn = sprintf('/Users/%s/Dropbox/TCC/Dados/status mfVEP.xlsx',user);
            pass = true;
        otherwise
            asw = input(prompt);
    end
end

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
elseif asw == 2
    saudaveis = xlsread(filename1, sheet1, 'b2:w61');
    neuromielite = xlsread(filename1, sheet2, 'b2:x61');
    esclerose = xlsread(filename1, sheet3, 'b2:q61');
end

% Create *people_meas* matrix using vertcat to join all data.
% * (64 observations x 60 features)
if asw == 1
    people_meas = vertcat(saudaveis1',saudaveis2',doentes1',doentes2');
% Create *people_status* matrix.
    [~,~,people_status] = xlsread(status_fn);
elseif asw == 2
    people_meas = vertcat(saudaveis',neuromielite',esclerose');
% Create parameter status to compare with the predictions.
    people_status = cell(size(people_meas,1),1);
    for i=1:length(people_meas)
        if i <= size(saudaveis,2)
            people_status{i} = 'saudavel';
        elseif i <= size(saudaveis,2) + size(neuromielite,2)
            people_status{i} = 'neuromielite otica';
        else
            people_status{i} = 'esclerose multipla';
        end
    end
end

% Assing label to the features.
features_label = {'1','2','3','4','5','6','7','8','9','10','11','12',...,
    '13','14','15','16','17','18','19','20','21','22','23','24','25',...,
    '26','27','28','29','30','31','32','33','34','35','36','37','38',...,
    '39','40','41','42','43','44','45','46','47','48','49','50','51',...,
    '52','53','54','55','56','57','58','59','60'};


%% FEATURE SELECTION
%{
% Here we apply feature selection to reduce the number of features of the
% original data. 
% 
% * Filter Method (Pre-Processing)
% * Wrapper Method
%
%%% FILTER METHOD (PRE-PROCESSING)
% Filter methods rely on general characteristics of the data to evaluate
% and to select the feature subsets without involving the chosen learning
% algorithm (Classification Tree in this case).
%
% Here we divide the data into a Training Set(75%) and a Test Set(25%).

holdoutCVP = cvpartition(people_status, 'holdout', 48);
measTrain = people_meas(training(holdoutCVP),:);
measTest = people_meas(test(holdoutCVP),:);
statusTrain = people_status(training(holdoutCVP));
statusTest = people_status(test(holdoutCVP));

% We might apply the _t-test_ on each feature and compare _p-value_ (or the
% absolute values of _t-statistics_) for each feature as a measure of how
% effective it is at separating groups.

measTrainG1 = measTrain(grp2idx(statusTrain)==1,:);
measTrainG2 = measTrain(grp2idx(statusTrain)==2,:);
[h,p,ci,stat] = ttest2(measTrainG1,measTrainG2,[],[],'unequal');

% In order to get a better idea of how well-separated the two groups are by
% each feature, we plot the empirical cumulative distribution function
% (CDF) of the _p-values_.

figure;
subplot(2,2,1);
ecdf(p);
title('Empirical CDF');
xlabel('P Value');
ylabel('CDF Value');
grid on

featSmallPoFive = find(p < 0.05);

% There are about 35% of features having _p-values_ close to zero and over
% 65% of features having _p-values_ smaller than 0.05, meaning there are
% more than 39 features among the original 60 features that have strong
% discrimination power. One cas sort these features according to their
% _p-values_ (or the absolute values of _t-statistics_) and select some
% features from the sorted list. However, it is usually difficult to decide
% how many features are needed.
%
% One quick way to decide the number of needed features is to plot the MCE
% (misclassification error, i.e., the number of misclassified observations
% divided by the number of observations) on the test set as a function of
% the number of features.

[~,featureIdxSortbyp] = sort(p,2); % sort the features;
testMCE = zeros(1,12);
resubMCE = zeros(1,12);
nfs = 5:5:60;

classif = @classf;
resubCVP = cvpartition(length(people_status),'resubstitution');
for i=1:12
    fs = featureIdxSortbyp(1:nfs(i));
    testMCE(i) = crossval(classif,people_meas(:,fs),people_status,...
        'partition',holdoutCVP)/holdoutCVP.TestSize;
    resubMCE(i) = crossval(classif,people_meas(:,fs),people_status,...
        'partition',resubCVP)/resubCVP.TestSize;
end
subplot(2,2,2);
plot(nfs, testMCE, 'o', nfs, resubMCE, 'r^');
xlabel('Number of Features');
ylabel('MCE');
legend({'MCE on the test set','Resubstitution MCE'}, 'location', 'NW');
title('Simple Filter Feature Selection Method');
grid on

%The Resubstitution MCE is over-optimistic. It consistenly decreases when
%more features are used. However, if the test erro increases while the
%resubstitution error still decreases, then overfitting may have occurred.
%
%%% WRAPPER METHOD (SEQUENTIAL FEATURE SELECTION)
% Wrapper methods use the performance of the chosen learning algorithm
% (Classification Tree in this case) to evaluate each feature subset.
% Wrapper metohds search for features better fit for the chosen learning
% algorithm, but they can be significantly slower than filter methods if
% the learning algoritm takes a long time to run.
% Sequential feature selection is one of the most widely used techniques.
% It selects a subset of features by sequentially adding (foward search) or
% removing (backward search) until certain stop conditions are satisfied.
% Here we use the MCE of the learning algorithm Classification Tree on each
% candidate feature subset as the performance indicator of the subset.
% The training set is used to select the features and to fit the
% Classification Tree model, and the test set is used to evaluate the
% performance of the finally selected feature. During the feature selection
% procedure, to evaluate and to compare the performance of the each
% candidate feature subset, we apply stratified 10-fold cross-validation to
% the trainig set.
%
% First we generate a stratified 10-fold partition for the training set:

tenfoldCVP = cvpartition(statusTrain,'kfold',5);

% Then we use the filter results from previous section as a pre-processing
% step to select features.

fs1 = featureIdxSortbyp(1:60);

% We apply foward sequential feature selection on these features. The
% function _sequentialfs_ provides a simple way (the default option)to
% decide how many features are needed. It stops when the first local
% minimum of the cross-validation MCE is found.

fsLocal = sequentialfs(classif, measTrain(:,fs1),statusTrain,'cv',...
    tenfoldCVP);

% The selected features are the following:

fsCVLocal = fs1(fsLocal)

% To evaluate the performance of the selected model with these features, we
% compute the MCE on the 16 test samples.

testMCELocal = crossval(classif,people_meas(:,fs1(fsLocal)),...
    people_status,'partition',holdoutCVP)/holdoutCVP.TestSize

% Sometimes a small MCE is achievable by looking for the minimum of the
% cross-validation MCE over a reasonable number of features. For isntance,
% we draw the plot of the cross-validation MCE as a function of the number
% of features.

[fsCVforBest,historyCV] = sequentialfs(classif, measTrain(:,fs1),...
    statusTrain,'cv',tenfoldCVP,'Nf',length(featSmallPoFive));
subplot(2,2,3);
plot(historyCV.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('FS Feature Selection with cross-validation');
grid on

% We need to find where the cross-validation MCE reaches the minimum value
% to determine the minimum number of features, because it is usually
% preferable to have fewer features.
% Here we find the minimum number of features that return the lowest MCE.

minIdx = find(historyCV.Crit == min(historyCV.Crit),1,'first');

% All Minimum Indexes
minIdxs = find(historyCV.Crit == min(historyCV.Crit));

% Generates the trees using the minimum indexes:
%[fsCVforMins01, fsCVforMinsLabels01, TestTrees01] = compSelFeats(minIdxs);

fsCVforMins = cell(1,length(minIdxs));
fsCVforMinsLabels = cell(1,length(minIdxs));
TestTrees = cell(1,length(minIdxs));
for i=1:length(minIdxs)
    % Here we show the selected features:
    fsCVforMins{i} = fs1(historyCV.In(minIdxs(i),:));
    labelsTmp = cell(1,length(fsCVforMins{i}));
    for ii=1:length(fsCVforMins{i})
        labelsTmp{ii} = num2str(fsCVforMins{i}(ii));
    end
    fsCVforMinsLabels{i} = labelsTmp;
    TestTrees{i} = ClassificationTree.fit(people_meas...
        (:,fsCVforMins{i}),people_status,...
        'PredictorNames',fsCVforMinsLabels{i});
end

% Here we show the selected features:
fsCVforMin = fs1(historyCV.In(minIdx,:))

% To show these features in the order in which they are selected in the
% sequential forward procedure, we find the row in which they first become
% true in the |historyCV| output.

%[orderlist,ignore] = find( [historyCV.In(1,:);...
%    diff(historyCV.In(1:minIdx,:))]' );

% Here we show the ordered features:
%fs1(orderlist)

% To evaluate the selected features, we compute their MCE for
% Classification Tree on the test set.
testMCEforMin = crossval(classif,people_meas(:,fsCVforMin),...
    people_status,'partition',holdoutCVP)/holdoutCVP.TestSize

% It is interesting to look at the plot of resubstitution MCE values on the
% training set(i.e.m without performing cross-validation during the feature
% selection procedure) as a function of the number of features:
[fsResubforBest,historyResub] = sequentialfs(classif,measTrain(:,fs1),...
    statusTrain,'cv','resubstitution','Nf',length(featSmallPoFive));
subplot(2,2,4);
plot(1:length(featSmallPoFive),historyCV.Crit,'bo',...
    1:length(featSmallPoFive),historyResub.Crit,'r^');
xlabel('Number of Features');
ylabel('MCE');
title('Comparison of Resub and FS Feature Selection');
legend({'10-fold CV MCE','Resubstitution MCE'},'location','NE');
grid on

% In order to compare the MCE of the resubstitution with the one using
% cross-validation, we have evaluate the MCE for the minimum features using
% resubstitution.
% Here we find the minimum number of features that return the lowest MCE.
minResubIdx = find(historyResub.Crit == min(historyResub.Crit),1,'first');

% Here we show the selected features using resubstitution:
fsResubforMin = fs1(historyResub.In(minResubIdx,:))

% To evaluate the selected features, we compute their MCE for
% Classification Tree on the test set using resubstitution.
testMCEResubforMin = crossval(classif,people_meas(:,fsResubforMin),...
    people_status,'partition',holdoutCVP)/holdoutCVP.TestSize
%}
%% GENERATING THE DEFAULT CLASSIFICATION TREE

% Generate the default tree
DefaultTree01 = ClassificationTree.fit(people_meas,people_status,...
    'PredictorNames',features_label);
view(DefaultTree01, 'mode', 'graph');

% Generate the 'optimal' tree
%OptimalTree = ClassificationTree.fit(people_meas,people_status,...
%    'minleaf',3.5,'PredictorNames',features_label);
%view(OptimalTree, 'mode', 'graph');

%% RESUBSTITUTION ERROR OF A CLASSIFICATION TREE
% Resubstitution error is the difference between the response training data
% and the predictions the tree makes of the response based on the input
% training data. If the resubstitution error is high, you cannot expect the
% predictions of the tree to be good. However, having low resubstitution
% error does not guarantee good predictions for new data. Resubstitution
% error is often an overly optimistic estimate of the predictive error on
% new data.

%{
resubdefault = resubLoss(DefaultTree01);
formatResubDefault = 'Resubstitution Error for Default Tree is %f.';
asw1 = sprintf(formatResubDefault,resubdefault);
disp(asw1);

resuboptimal = resubLoss(OptimalTree);
formatResubOptimal = 'Resubstitution Error for Optimal Tree is %f.';
asw2 = sprintf(formatResubOptimal,resuboptimal);
disp(asw2);
%}

%% CROSS VALIDATE DE TREE
% To get a better sense of the predictive accuracy of your tree for new
% data, cross validate the tree. By default, cross validation splits the
% training data into 10 parts at random. It trains 10 new trees, each one
% on nine parts of the data. It then examines the predictive accuracy of
% each new tree on the data not included in training that tree. This method
% gives a good estimate of the predictive accuracy of the resulting tree,
% since it tests the new trees on new data.

%{
lossDefault = kfoldLoss(crossval(DefaultTree01));
formatCrossValDefault = 'Cross Validation error for Default Tree is %f.';
asw3 = sprintf(formatCrossValDefault,lossDefault);
disp(asw3);

lossOptimal = kfoldLoss(crossval(OptimalTree));
formatCrossValOptimal = 'Cross Validation error for Optimal Tree is %f.';
asw4 = sprintf(formatCrossValOptimal,lossOptimal);
disp(asw4);
%}

%% DETERMINING BEST TREE DEPTH
%{
%leafs = logspace(1,2,10);
leafs = logspace(0,1,10);

rng('default')
N = numel(leafs);
err = zeros(N,1);
for n=1:N
    t = ClassificationTree.fit(people_meas,people_status,'crossval',...
    'on','minleaf',leafs(n));
    err(n) = kfoldLoss(t);
end
plot(leafs,err);
xlabel('Min Leaf Size');
ylabel('cross-validated error');
%}

%% FEATURE SELECTION USING CROSS-VALIDATION ON CLASSIFICATION TREE

% Here we use cross-validation on the Classification Tree as a method to
% select the most discriminant features, by selecting the features most
% used in the cross-validation procedure of the classification tree.

keyFeaturesTemp = [];
keyCutPointsTemp = [];

% Here we repeat the process 100 times to select the features
for n=1:100
    % Cross validate the trees
    cvDefaultTree01 = crossval(DefaultTree01,'kfold',10);
    %cvOptimalTree = crossval(OptimalTree);
    for i=1:10
        % Show all trees generated by cross validating the DefaultTree01 and
        % OptimalTree.
        %view(cvDefaultTree01.Trained{n},'mode','graph');
        %view(cvOptimalTree.Trained{n},'mode','graph');

        % Extract features and cut points from all ten trees generated by
        % cross-validation
        noRepeatFeatsTmp = unique(cvDefaultTree01.Trained{i}.CutVar);
        keyFeaturesTemp = vertcat(keyFeaturesTemp,noRepeatFeatsTmp);

        noRepeatCutPTmp = unique(cvDefaultTree01.Trained{i}.CutPoint);
        keyCutPointsTemp = vertcat(keyCutPointsTemp,noRepeatCutPTmp);
    end
end

% Remove empties from keyFeaturesTemp and keyCutPointsTemp
keyFeaturesTemp2 = keyFeaturesTemp(~cellfun('isempty',keyFeaturesTemp));
keyCutPoints = keyCutPointsTemp(~arrayfun(@isnan,keyCutPointsTemp));

% Converting cell array to numeric array
[m,n] = size(keyFeaturesTemp2);
keyFeatures = zeros(m,1);
for i=1:m
    keyFeatures(i) = str2double(keyFeaturesTemp2{i});
end

% Clear temp variables
clearvars keyFeaturesTemp keyFeaturesTemp2 keyCutPointsTemp ...
    noRepeatFeatsTmp noRepeatCutPTmp

% Concatenate the features with their cut points values
%Feats = horzcat(keyFeatures,keyCutPoints);

% Export features to CSV
%cell2csv('/Users/pma007/Dropbox/TCC/Dados/teste-features.csv',...
%    keyFeatures);
%cell2csv('/Users/iraquitanfilho/Dropbox/TCC/Dados/teste-features.csv',...
%    keyFeatures);

% Write the features and cut points to excell
%w1 = xlswrite(featWrite, Feats);

% Plot histogram graph to show the most used features.
figure;
nelements = hist(keyFeatures,60);
xcenters = (1:1:60);
bar(xcenters,nelements);
colormap summer
grid on

% Find the features with a threshold
selFeats = find(nelements >= 300);

%% GENERATES NEW TREES WITH THE SELECTED FEATURES
%{
%%% FROM CROSS_VALITATION METHOD
% Here we set the names for the predictors, using the selected features
% from the cross-validation.
%selFeatsLabel = num2cell(selFeats,1);
selFeatsLabel = cell(1,length(selFeats));
for i=1:length(selFeats)
    selFeatsLabel{i} = num2str(selFeats(i));
end
% Generating a new tree with features selected using cross-validation:
DefaultTree02 = ClassificationTree.fit(people_meas(:,selFeats),...
    people_status,'PredictorNames',selFeatsLabel);
view(DefaultTree02, 'mode', 'graph');
%}
%{
%%% FROM WRAPPER METHOD
% Here we set the names for the predictors, using the selected features
% from the wrapper method sequential forward feature selection.
fsCVforMinLabel = cell(1,length(fsCVforMin));
for i=1:length(fsCVforMin)
    fsCVforMinLabel{i} = num2str(fsCVforMin(i));
end
% Generating a new tree with features selected using the wrapper method
% sequential forward feature selection:
DefaultTree03 = ClassificationTree.fit(people_meas(:,fsCVforMin),...
    people_status,'PredictorNames',fsCVforMinLabel);
view(DefaultTree03, 'mode', 'graph');
%}
%% USE FITTED MODEL FOR PREDICTIONS
% Inputs to predict
new1 = xlsread(filename1, sheet1, 'b1:w60');
new2 = xlsread(filename1, sheet2, 'b1:x60');
new3 = xlsread(filename1, sheet3, 'b1:z60');
new4 = xlsread(filename1, sheet4, 'b1:q60');
new = horzcat(new1, new2, new3, new4);
newinput = new';

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

% Predict new inputs using the Classification Tree
YpredictedDefault01 = predict(DefaultTree01, newinput);
%YpredictedDefault02 = predict(DefaultTree02, newinput(:,selFeats));
YpredictedDefault03 = predict(DefaultTree03, newinput(:,fsCVforMin));
%YpredictedOptimal = predict(OptimalTree, newinput);

% Predict for the Test Trees:
YpredictedTestTrees = cell(1,length(TestTrees));
for i=1:length(TestTrees)
    YpredictedTestTrees{i} = predict(TestTrees{i},...
        newinput(:,fsCVforMins{i}));
end

% Predict using one of the trees generated by cross validation
%resposta = predict(cvDefaultTree01.Trained{4}, newinput);

%w0 = xlswrite(predictWrite,YpredictedDefault);

%% COMPARE THE PREDICTIONS WITH THE PARAMETER
%
score01 = sum(strcmp(parameter_status,YpredictedDefault01));
%score02 = sum(strcmp(parameter_status,YpredictedDefault02));
score03 = sum(strcmp(parameter_status,YpredictedDefault03));

% Scores for Test Trees:
scoresTestTrees = zeros(2,length(TestTrees));
for i=1:length(scoresTestTrees)
    scoresTestTrees(1,i) = sum(strcmp(parameter_status,...
        YpredictedTestTrees{i}));
    scoresTestTrees(2,i) = sum(~strcmp(parameter_status,...
        YpredictedTestTrees{i}));
end

% Shows the scores of the predictions in percentage.
disp(fprintf('Score for DefaultTree01 = %f\n',...
    score01/length(parameter_status)));
%disp(fprintf('Score for DefaultTree02 = %f\n',...
%    score02/length(parameter_status)));
disp(fprintf('Score for DefaultTree03 = %f\n',...
    score03/length(parameter_status)));

% Shows the scores for Test Trees:
for i=1:length(scoresTestTrees)
    disp(fprintf('Score for TestTree%d = %f\n',i,...
    scoresTestTrees(1,i)/length(parameter_status)));
end

%%
% Show the loss for all trees generated by cross validation
%defaultIndLoss = cvDefaultTree01.kfoldLoss('mode','individual');
%optimalIndLoss = cvOptimalTree.kfoldLoss('mode','individual');