function [plot_h,lgd_h] = plotMeanStd( X,Y,gTitle,mColors )
%PLOTMEANSTD
%   Plots the mean with standard deviations of the data X by features per
%   classes Y, can accept a color matrix to maintain same color for all
%   plots.
%% PRELIMINARIES
[~,index] = unique(Y,'first');      % Capture the index, ignore junk
classes = Y(sort(index));     % Index y with the sorted index

if ~exist('gTitle','var')
    gTitle = '';
elseif isempty(gTitle)
    gTitle = '';
else
    gTitle = [' - ',gTitle];
end

if ~exist('mColors','var')
    mColors = random_color(length(classes));
end
%% EVALUATE MEAN AND STANDARD DEVIATION BY CLASSES
meanClasses = [];
stdClasses = [];
for i=1:length(unique(Y))
    meanTemp = mean(X(grp2idx(Y)==i,:),1);
    stdTemp = std(X(grp2idx(Y)==i,:),0,1);
    meanClasses = vertcat(meanClasses,meanTemp);
    stdClasses = vertcat(stdClasses,stdTemp);
end
%% PLOT MEAN WITH STANDARD DEVIATIONS BY CLASSES
for i=1:size(meanClasses,1)
%    errorbar(meanClasses(i,:)',stdClasses(i,:)',strcat(getPlotColor(i),...
%        getPlotMarker(1),getPlotLine(0)),'MarkerFaceColor',...
%        mColors(i,:),'MarkerSize',8,'LineWidth',1);
    plot_h = errorbar(meanClasses(i,:)',stdClasses(i,:)','Color',abs([0.7,0.7,0.7]-mColors(i,:)),...
        'Marker',getPlotMarker(1),'LineStyle',getPlotLine(0),...
        'MarkerFaceColor',mColors(i,:),'MarkerSize',8,'LineWidth',1);
    hold all
end
%title(strcat('Mean and Standard Deviation of Classes',gTitle),...
%    'FontSize', 20);
title(gTitle,'FontSize',20);
%xlabel('Features','FontSize', 15);
xlabel('Features');
xlim([0,size(X,2)+1])
%ylabel('Mean with Standard Deviation','FontSize', 15);
ylabel('Mean with Standard Deviation');
lgd_h = legend(classes);
grid on
hold all
end