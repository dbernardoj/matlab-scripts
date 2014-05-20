function [ err ] = LDA_cl( xtrain,ytrain,xtest,ytest )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%% Train a Classifier using the Training Set
%ClassDiscr_Model = ClassificationDiscriminant.fit(xtrain,ytrain,'discrimType','linear');
ClassDiscr_Model = fitcdiscr(xtrain,ytrain,'discrimType','linear');
%% Predict using the Test Set
[ClassDiscr_Predicted] = ClassDiscr_Model.predict(xtest);
%% Evaluate missclassification error rate
err = sum(~strcmp(ytest,ClassDiscr_Predicted));

end