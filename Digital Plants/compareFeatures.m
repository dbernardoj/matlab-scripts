function [ results,eval_results ] = compareFeatures( X,y,features1,features2 )
%COMPARE THE CROSS-VALIDATION ERROR FOR FEATURES SELECTED FROM DIFFERENT
%METHODS
%   Compare the Cross-Validation Error for features selected usind two
%   different feature selection methods, such like Cross-Validation Method
%   and Forward Sequentia Method.
%% CHECK NUMBER OF CLASSES
nclasses = length(unique(grp2idx(y)));
%% DIVIDES THE DATA INTO TRAINING AND TEST SETS
cpKfold = cvpartition(y,'k',10);
cpHoldout = cvpartition(y,'holdout',0.25);
cpLeaveoneout = cvpartition(y,'leaveout');
%% CROSS-VALIDATION ERROR
classf = @(XTRAIN, ytrain,XTEST)(predict(...
    ClassificationTree.fit(XTRAIN,ytrain),XTEST));

% Compute confusion matrix for cross-validation
order = unique(y); % Order of the group labels
f_conf_mat = @(XTRAIN,ytrain,XTEST,ytest)confusionmat(ytest,...
predict(ClassificationTree.fit(XTRAIN,ytrain),XTEST),'order',order);

% Using k-fold
cvErrKF01 = crossval('mcr',X,y,'predfun',classf,'partition',cpKfold);
cvErrKF02 = crossval('mcr',X(:,features1),y,'predfun',classf,...
    'partition',cpKfold);
cvErrKF03 = crossval('mcr',X(:,features2),y,'predfun',classf,...
    'partition',cpKfold);

% Using Holdout
cvErrHo01 = crossval('mcr',X,y,'predfun',classf,'partition',cpHoldout);
cvErrHo02 = crossval('mcr',X(:,features1),y,'predfun',classf,...
    'partition',cpHoldout);
cvErrHo03 = crossval('mcr',X(:,features2),y,'predfun',classf,...
    'partition',cpHoldout);

% Using Leave One Out
cvErrLO01 = crossval('mcr',X,y,'predfun',classf,'partition',cpLeaveoneout);
cvErrLO02 = crossval('mcr',X(:,features1),y,'predfun',classf,...
    'partition',cpLeaveoneout);
cfMat1 = crossval(f_conf_mat,X(:,features1),y,'partition',cpLeaveoneout);
if nclasses ~= 2
    cfMat1 = reshape(sum(cfMat1),nclasses,nclasses);
else
    cfMat1 = reshape(sum(cfMat1),2,2);
end

cvErrLO03 = crossval('mcr',X(:,features2),y,'predfun',classf,...
    'partition',cpLeaveoneout);
cfMat2 = crossval(f_conf_mat,X(:,features2),y,'partition',cpLeaveoneout);
if nclasses ~= 2
    cfMat2 = reshape(sum(cfMat2),nclasses,nclasses);
else
    cfMat2 = reshape(sum(cfMat2),2,2);
end

%% RESULTS CALCULATIONS
% For features selected 01
N1 = sum(sum(cfMat1));
Acc1 = sum(diag(cfMat1)) / N1;
pe1 = 0;
SpecAcc1 = zeros(1,length(cfMat1));
for i = 1:length(cfMat1)
    pe1 = pe1 + (sum(cfMat1(:,i)) * sum(cfMat1(i,:)));
    SpecAcc1(i) = 2 * cfMat1(i,i) / (sum(cfMat1(:,i)) + sum(cfMat1(i,:)));
end
pe1 = pe1 / N1^2;
Kappa1 = (Acc1 - pe1) / (1 - pe1);
%SpecAcc11 = 2 * cfMat1(1,1) / (sum(cfMat1(:,1)) + sum(cfMat1(1,:)));
%SpecAcc12 = 2 * cfMat1(2,2) / (sum(cfMat1(:,2)) + sum(cfMat1(2,:)));

% For features selected 02

N2 = sum(sum(cfMat2));
Acc2 = sum(diag(cfMat2)) / N2;
pe2 = 0;
SpecAcc2 = zeros(1,length(cfMat2));
for i = 1:length(cfMat2)
    pe2 = pe2 + (sum(cfMat2(:,i)) * sum(cfMat2(i,:)));
    SpecAcc2(i) = 2 * cfMat2(i,i) / (sum(cfMat2(:,i)) + sum(cfMat2(i,:)));
end
pe2 = pe2 / N2^2;
Kappa2 = (Acc2 - pe2) / (1 - pe2);
%SpecAcc21 = 2 * cfMat2(1,1) / (sum(cfMat2(:,1)) + sum(cfMat2(1,:)));
%SpecAcc22 = 2 * cfMat2(2,2) / (sum(cfMat2(:,2)) + sum(cfMat2(2,:)));
%% RESULTS
% Here we gather the results and put into a matrix
results = cell(5,4);
% LABELS
results{2,1} = 'All Features';
results{3,1} = 'Selected Features 1';
results{4,1} = 'Selected Features 2';
results{5,1} = 'Gain Percentage with Features 1';
results{6,1} = 'Gain Percentage with Features 2';
results{1,2} = 'MCR K-fold Cross-Validation';
results{1,3} = 'MCR holdout Cross-Validation';
results{1,4} = 'MCR Leave Out Cross-Validation';
% RESULTS ALL FEATURES
results{2,2} = cvErrKF01;
results{2,3} = cvErrHo01;
results{2,4} = cvErrLO01;

% RESULTS FEATURES 01
results{3,2} = cvErrKF02;
results{3,3} = cvErrHo02;
results{3,4} = cvErrLO02;

% RESULTS FEATURES 02
results{4,2} = cvErrKF03;
results{4,3} = cvErrHo03;
results{4,4} = cvErrLO03;

% GAIN WITH CROSS_VALIDATION FEATURES
%results{5,2} = (cvErrKF01/cvErrKF02 - 1) * 100;
%results{5,3} = (cvErrHo01/cvErrHo02 - 1) * 100;
%results{5,4} = (cvErrLO01/cvErrLO02 - 1) * 100;

% GAIN WITH FORWARD_SEQUENTIAL FEATURES
%results{6,2} = (cvErrKF01/cvErrKF03 - 1) * 100;
%results{6,3} = (cvErrHo01/cvErrHo03 - 1) * 100;
%results{6,4} = (cvErrLO01/cvErrLO03 - 1) * 100;

%% EVALUATION RESULTS
eval_results = cell(2,2);
eval_results1 = cell(4,length(cfMat1)+2);
% LABELS
eval_results1{1,2} = 'Measure';
for i = 1:length(cfMat1)
    eval_results1{1,i+2} = sprintf('Class %d - %s',i,order{i});
    eval_results1{3,i+2} = SpecAcc1(i);
end
%eval_results1{1,3} = 'Class 1';
%eval_results1{1,4} = 'Class 2';
eval_results1{2,1} = 'Accuracy';
eval_results1{3,1} = 'Specific Accuracy';
eval_results1{4,1} = 'Kappa';
% RESULTS
eval_results1{2,2} = Acc1;
%eval_results1{3,3} = SpecAcc1(1,1);
%eval_results1{3,4} = SpecAcc1(1,2);
eval_results1{4,2} = Kappa1;

eval_results2 = cell(4,length(cfMat2)+2);
% LABELS
eval_results2{1,2} = 'Measure';
for i = 1:length(cfMat2)
    eval_results2{1,i+2} = sprintf('Class %d - %s',i,order{i});
    eval_results2{3,i+2} = SpecAcc2(i);
end
eval_results2{2,1} = 'Accuracy';
eval_results2{3,1} = 'Specific Accuracy';
eval_results2{4,1} = 'Kappa';
% RESULTS
eval_results2{2,2} = Acc2;
%eval_results2{3,3} = SpecAcc2(1,1);
%eval_results2{3,4} = SpecAcc2(1,2);
eval_results2{4,2} = Kappa2;

eval_results{1,1} = eval_results1;
eval_results{2,1} = cfMat1;
eval_results{1,2} = eval_results2;
eval_results{2,2} = cfMat2;
end