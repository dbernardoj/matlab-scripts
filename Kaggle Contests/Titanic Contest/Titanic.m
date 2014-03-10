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
%RAW_DATA = xlsreadstruct('train.xls');
%RAW_X_TEST = xlsreadstruct('test.xls');
load('Titanic Raw Data');
%% PROCESSING TRAINING DATA
PClass = RAW_DATA.Pclass;
Sex = zeros(length(RAW_DATA.Sex),1);
for i = 1:length(RAW_DATA.Sex)
    if  strcmp(RAW_DATA.Sex{i}, 'male')
        Sex(i) = 1;
    else
        Sex(i) = 0;
    end
end
Age = RAW_DATA.Age;
AgeNaNIdx = isnan(Age);
Age(AgeNaNIdx) = nanmedian(Age);
SibSp = RAW_DATA.SibSp;
ParCh = RAW_DATA.Parch;
Fare = RAW_DATA.Fare;
Embarked = zeros(length(RAW_DATA.Embarked),1);
for i = 1:length(RAW_DATA.Embarked)
    if  strcmp(RAW_DATA.Embarked{i}, 'C')
        Embarked(i) = 0;
    elseif strcmp(RAW_DATA.Embarked{i}, 'S')
        Embarked(i) = 1;
    else
        Embarked(i) = 2;
    end
end
Title = RAW_DATA.Name;
expression = '[A-Z]+[a-z]+\.';
Title = regexp(Title,expression,'match','once');
Titles = unique(Title);
for i=1:length(Titles)
    Titles{i,2} = sum(strcmp(Title,Titles{i}));
end

X = horzcat(PClass, Sex, Age, SibSp, ParCh, Fare, Embarked);

% Discover mean for Fare accordingly to class
cIdx1 = X(:,1)==1;
cIdx2 = X(:,1)==2;
cIdx3 = X(:,1)==3;
faremeanC1 = mean(X(cIdx1,6));
faremeanC2 = mean(X(cIdx2,6));
faremeanC3 = mean(X(cIdx3,6));

Y = RAW_DATA.Survived;
tmp3 = regexp(sprintf('%i ',Y),'(\d+)','match');
Y = tmp3';
clear RAW_DATA PClass Sex Age AgeNaNIdx SibSp ParCh Fare Embarked tmp3 ...
    cIdx1 cIdx2 cIdx3
%% PROCESSING TEST DATA
PClassTest = RAW_X_TEST.Pclass;
SexTest = zeros(length(RAW_X_TEST.Sex),1);
for i = 1:length(RAW_X_TEST.Sex)
    if  strcmp(RAW_X_TEST.Sex{i}, 'male')
        SexTest(i) = 1;
    else
        SexTest(i) = 0;
    end
end
AgeTest = RAW_X_TEST.Age;
AgeNaNIdxTest = isnan(AgeTest);
AgeTest(AgeNaNIdxTest) = nanmedian(AgeTest);
SibSpTest = RAW_X_TEST.SibSp;
ParChTest = RAW_X_TEST.Parch;
FareTest = RAW_X_TEST.Fare;
if PClassTest(isnan(FareTest),:) == 1
    FareTest(isnan(FareTest),:) = faremeanC1;
elseif PClassTest(isnan(FareTest),:) == 2
    FareTest(isnan(FareTest),:) = faremeanC2;
else
    FareTest(isnan(FareTest),:) = faremeanC3;
end
EmbarkedTest = zeros(length(RAW_X_TEST.Embarked),1);
for i = 1:length(RAW_X_TEST.Embarked)
    if  strcmp(RAW_X_TEST.Embarked{i}, 'C')
        EmbarkedTest(i) = 0;
    elseif strcmp(RAW_X_TEST.Embarked{i}, 'S')
        EmbarkedTest(i) = 1;
    else
        EmbarkedTest(i) = 2;
    end
end
TitleTest = RAW_X_TEST.Name;
TitleTest = regexp(TitleTest,expression,'match');

XTEST = horzcat(PClassTest, SexTest, AgeTest, SibSpTest, ParChTest, ...
    FareTest, EmbarkedTest, TitleTest);

pID = RAW_X_TEST.PassengerId(2:end);
clear RAW_X_TEST RAW_Y_TEST PClassTest SexTest AgeTest AgeNaNIdxTest ...
    SibSpTest ParChTest FareTest EmbarkedTest
%% DIVIDING DATA
%cvpart = cvpartition(Y,'kfold',20);
cvpart = cvpartition(Y,'leaveout');
%Xtrain = X(training(cvpart),:);
%Ytrain = Y(training(cvpart),:);
%Xtest = X(test(cvpart),:);
%Ytest = Y(test(cvpart),:);

% Data to predict and send
XtestComp = XTEST;

% Select the features to use in the model
usedfeats = [1,2,6];
X = X(:,usedfeats);
XtestComp = XtestComp(:,usedfeats);
clear XTEST YTEST
%% COMPUTE CROSS_VALIDATION MISCLASSIFICATION ERROR
%fun = @bagclassif;
%rate = sum(crossval(fun,X,Y,'partition',cvpart))/sum(cvpart.TestSize)

% Discriminant Analysis Classifier
%classf = @(XTRAIN, ytrain,XTEST)(classify(XTEST,XTRAIN,ytrain));
% Ensemble of Decision Tree Classifier
%classf = @(XTRAIN, ytrain,XTEST)(predict(fitensemble(XTRAIN,ytrain,...
%    'Bag',500,'Tree','type','classification'),XTEST));
% Decision Tree Classifier
classf = @(XTRAIN, ytrain,XTEST)(predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST));
mcr = crossval('mcr',X,Y,'predfun',classf,'partition',cvpart)
%% TRAIN A CLASSIFIER USING RANDOM FOREST
%bag = fitensemble(Xtrain,Ytrain,'Bag',500,'Tree',...
%    'type','classification');
% Fit a Random Forest Classifier
%bag100 = fitensemble(X,Y,'Bag',500,'Tree',...
%    'type','classification');

% Fit a Discriminant Analysis Classifier
bag100 = ClassificationDiscriminant.fit(X,Y);

% Fit a Decision Tree Classifier
%bag100 = ClassificationTree.fit(X,Y);
%{
tree = ClassificationTree.fit(Xtrain,Ytrain,'PredictorNames', ...
    {'Class','Sex','Age','SibSp','ParCh','Fare','Embarked'});

figure;
plot(loss(bag,Xtest,Ytest,'mode','cumulative'));
xlabel('Number of trees');
ylabel('Test classification error');
%}
%% PREDICT TEST SET AND TEST FULL
%[predtest1, scores] = bag.predict(Xtest);
[predtest100, scores100] = bag100.predict(XtestComp);
%[predttest, tscores] = tree.predict(Xtest);
%% EVALUATE LOGARITHMIC LOSS
%logloss1 = log_loss(Ytest,predtest1)
%log_loss(Ytest,predttest)
%% EVALUATE PREDICT PERFORMANCE
%errb = sum(~arrayfun(@ismember,predtest1,Ytest))/length(Ytest)
%errt = sum(~arrayfun(@ismember,predttest,Ytest))/length(Ytest)
%% WRITE SUBMISSION FILE
%[predComptest, Compscores] = bag.predict(XtestComp);
predtest100 = cellfun(@str2double, predtest100); % Convert cell of strings to array of doubles.
resultsRF_struct = struct('PassengerId', pID, 'Survided', predtest100);
resultsRF = struct2array(resultsRF_struct);
csvwrite_with_headers('ResultsRandomForest.csv',resultsRF, ...
    {'PassengerID','Survived'});
%{
[predCompttest, Comptscores] = tree.predict(XtestComp);
resultsDT_struct = struct('PassengerId', pID, 'Survided', predCompttest);
resultsDT = struct2array(resultsDT_struct);
csvwrite_with_headers('ResultsDecisionTree.csv',resultsDT, ...
    {'PassengerID','Survived'});
%}