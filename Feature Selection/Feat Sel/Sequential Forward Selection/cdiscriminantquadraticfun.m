function [ err ] = cdiscriminantquadraticfun( xtrain,ytrain,xtest,ytest )
%CLASSFUN Classification algorithm using Classification Tree, return the
%predicted values
global progresscount h tot_iter
%% Train a Classifier using the Training Set
ClassDiscr_Model = ClassificationDiscriminant.fit(xtrain,ytrain,'discrimType','quadratic');
%% Predict using the Test Set
[ClassDiscr_Predicted] = ClassDiscr_Model.predict(xtest);
%% Evaluate missclassification error rate
err = sum(~strcmp(ytest,ClassDiscr_Predicted));
progresscount = progresscount + 1;
%disp(progresscount)
perc = progresscount/tot_iter*100;
waitbar(progresscount/tot_iter,h,sprintf('(%d/%d) - %3.2f%% concluido... [QDA]',progresscount,tot_iter,perc))
end