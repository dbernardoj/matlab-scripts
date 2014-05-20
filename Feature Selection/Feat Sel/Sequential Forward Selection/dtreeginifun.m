function [ err ] = dtreeginifun( xtrain,ytrain,xtest,ytest )
%CLASSFUN Classification algorithm using Classification Tree, return the
%predicted values
global progresscount h tot_iter
%% Train a Classifier using the Training Set
ClassTree_Model = ClassificationTree.fit(xtrain,ytrain,'SplitCriterion','gdi');
%% Predict using the Test Set
[ClassTree_Predicted] = ClassTree_Model.predict(xtest);
%% Evaluate missclassification error rate
err = sum(~strcmp(ytest,ClassTree_Predicted));
progresscount = progresscount + 1;
%disp(progresscount)
perc = progresscount/tot_iter*100;
waitbar(progresscount/tot_iter,h,sprintf('(%d/%d) - %3.2f%% concluido... [DT GINI]',progresscount,tot_iter,perc))
end