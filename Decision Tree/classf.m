function err = classf(xtrain,ytrain,xtest,ytest)
%CLASSF - Classification algorithm using Classification Tree, return the
%misclassification error.
%   Train a Classifier using the Training Set
ClassTree_Model = ClassificationTree.fit(xtrain,ytrain);
%   Evaluate accuracy using the Test Set
[ClassTree_Predicted] = ClassTree_Model.predict(xtest);
err = sum(~strcmp(ytest,ClassTree_Predicted));
end

