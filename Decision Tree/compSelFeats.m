function [ fsCVforMins, fsCVforMinsLabels, TestTrees ] = compSelFeats( minIdxs )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
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

end