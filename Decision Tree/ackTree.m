%% GENERATES A NEW TREE TO ACKNOWLEDGE THE FEATURES
% Execute this script to acknowledge the best features so far.

% Reads the best features so far.
bestFeats = '/Users/pma007/Dropbox/TCC/Dados/Best Feats.csv';
BF = csvread(bestFeats);

% Here we set the names for the predictors, using the selected features
% from the wrapper method sequential forward feature selection.
BFLabel = cell(1,length(BF));
for i=1:length(BF)
    BFLabel{i} = num2str(BF(i));
end

% Generate the tree with the best features
AckTree = ClassificationTree.fit(people_meas(:,BF),people_status,...
    'PredictorNames',BFLabel);

% Predict using the Acknowledge Tree
YpredictedAckTree = predict(AckTree, newinput(:,BF));
responseAckTree = cellfun(@strcmp,parameter_status,YpredictedAckTree);
scoreAckTree = 0;
for i=1:length(parameter_status)
    if responseAckTree(i) == true
        scoreAckTree = scoreAckTree + 1;
    end
end
disp(fprintf('Score for AckTree = %f\n',...
    scoreAckTree/length(parameter_status)));