%% ABOUT
% * Author: Iraquitan Cordeiro Filho
% * Company: Institudo Tecnologico Vale - Desenvolvimento Sustentavel
% * Date: 05 feb 2014
%% PRELIMINARIES
% Clear our workspace
clear all
clc

% Close all figures
close all
%% LOAD THE DATA
%load('N4_vetorAHVD_db3_14c');
load('mami_absMom_N4_vetorAHVD_db3_14c.mat')
load('species');
%% PRE-PROCESS DATA
sp1 = vetor(1:59,1:108);
sp2 = vetor(60:122,1:108);
vetor = vetor(:,1:108);
%% FIRST STEP
% Plot of all the data in species 1 and 2 (No Normalization)
h1 = figure;
subplot(2,1,1);
plot(abs(sp1'));
title('Espécie 1');
xlabel('Features');
ylabel('Samples');
grid on

subplot(2,1,2);
plot(abs(sp2'));
title('Espécie 2');
xlabel('Features');
ylabel('Samples');
grid on

suptitle('Plot of all the data in species 1 and 2 (No Normalization)');
% Save first plot
saveas(h1,'First Step Plot','fig')
%% SECOND STEP
% First normalization, normalize by energy
nfeats = size(sp1,2);
tp_size = size(sp1,2)/3;
tpSps = sum_by_n(abs(vetor),3);
tpSp1 = sum_by_n(abs(sp1),3);
tpSp2 = sum_by_n(abs(sp2),3);

tp = [];
tp1 = [];
tp2 = [];
for i=1:tp_size
    cl = tpSps(:,i);
    cl1 = tpSp1(:,i);
    cl2 = tpSp2(:,i);
    temp = [cl cl cl];
    temp1 = [cl1 cl1 cl1];
    temp2 = [cl2 cl2 cl2];
    tp = [tp temp];
    tp1 = [tp1 temp1];
    tp2 = [tp2 temp2];
end
clear temp1 temp2 temp
Vsps = abs(vetor)./tp;
Vsp1 = abs(sp1)./tp1;
Vsp2 = abs(sp2)./tp2;

%%% Plot of all the data in species 1 and 2 (First Normalization)
h2 = figure;
subplot(2,1,1);
plot(Vsp1');
title('Espécie 1');
xlabel('Features');
ylabel('Samples');
grid on

subplot(2,1,2);
plot(Vsp2');
title('Espécie 2');
xlabel('Features');
ylabel('Samples');
grid on

suptitle('Plot of all the data in species 1 and 2 (First Normalization)');

% Save second plot
saveas(h2,'Second Step Plot 1','fig')

%%% Plot of the mean with std in species 1 and 2 (First Normalization)
Vsp1_mean = mean(Vsp1,1);
Vsp2_mean = mean(Vsp2,1);
Vsp1_std = std(Vsp1,0,1);
Vsp2_std = std(Vsp2,0,1);

h3 = figure;
subplot(2,1,1);
plot(Vsp1_mean,'mo','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
hold
errorbar(Vsp1_mean,Vsp1_std);
title('Espécie 1');
xlabel('Features');
ylabel('Mean with Standard Deviation');
grid on

subplot(2,1,2);
plot(Vsp2_mean,'r^-','MarkerFaceColor',[.29 .5 .23],'MarkerSize',10);
hold
errorbar(Vsp2_mean,Vsp2_std);
title('Espécie 2');
xlabel('Features');
ylabel('Mean with Standard Deviation');
grid on

suptitle('Plot of the mean with std in species 1 and 2 (First Normalization)');

% Save thrid plot
saveas(h3,'Second Step Plot 2','fig')

%%% Plot of the mean of species 1 and 2 (First Normalization)
h4 = figure;
plot(Vsp1_mean,'bo-','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
hold
errorbar(Vsp1_mean,Vsp1_std);
plot(Vsp2_mean,'r^-','MarkerFaceColor',[.29 .5 .23],'MarkerSize',10);
errorbar(Vsp2_mean,Vsp2_std,'r');
title('Mean of species 1 and 2 (First normalization)');
xlabel('Features');
ylabel('Mean');
legend('Specie 1','Specie 2');
grid on

% Save fourth plot
saveas(h4,'Second Step Plot 3','fig')

%% THIRD STEP
% Second normalization, remove mean
Vsps_minus_mean = Vsps - repmat(mean(Vsps),size(vetor,1),1);
Vsp1_minus_mean = Vsp1 - repmat(Vsp1_mean,size(sp1,1),1);
Vsp2_minus_mean = Vsp2 - repmat(Vsp2_mean,size(sp2,1),1);
Vsp1_minus_mean_std = std(Vsp1_minus_mean,0,1);
Vsp2_minus_mean_std = std(Vsp2_minus_mean,0,1);
% Second normalization, remove mean and use absolute value
Vsps_minus_mean_abs = abs(Vsps - repmat(mean(Vsps),size(vetor,1),1));
Vsp1_minus_mean_abs = abs(Vsp1 - repmat(Vsp1_mean,size(sp1,1),1));
Vsp2_minus_mean_abs = abs(Vsp2 - repmat(Vsp2_mean,size(sp2,1),1));
Vsp1_minus_mean_abs_std = std(Vsp1_minus_mean_abs,0,1);
Vsp2_minus_mean_abs_std = std(Vsp2_minus_mean_abs,0,1);

%%% Plot of the mean with std in species 1 and 2 (Second Normalization)
h5 = figure;
subplot(2,1,1);
plot(mean(Vsp1_minus_mean,1),'mo','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
hold
errorbar(mean(Vsp1_minus_mean,1),Vsp1_minus_mean_std);
title('Espécie 1');
xlabel('Features');
ylabel('Mean with Standard Deviation');
grid on

subplot(2,1,2);
plot(mean(Vsp2_minus_mean,1),'r^-','MarkerFaceColor',[.29 .5 .23],'MarkerSize',10);
hold
errorbar(mean(Vsp2_minus_mean,1),Vsp2_minus_mean_std);
title('Espécie 2');
xlabel('Features');
ylabel('Mean with Standard Deviation');
grid on

suptitle('Plot of the mean with std in species 1 and 2 (Second Normalization)');

% Save fifth plot
saveas(h5,'Third Step Plot 1','fig')

%%% Plot of the mean with std in species 1 and 2 Absolute Values (Second Normalization)
h6 = figure;
subplot(2,1,1);
plot(mean(Vsp1_minus_mean_abs,1),'mo','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
hold
errorbar(mean(Vsp1_minus_mean_abs,1),Vsp1_minus_mean_abs_std);
title('Espécie 1');
xlabel('Features');
ylabel('Mean with Standard Deviation');
grid on

subplot(2,1,2);
plot(mean(Vsp2_minus_mean_abs,1),'r^-','MarkerFaceColor',[.29 .5 .23],'MarkerSize',10);
hold
errorbar(mean(Vsp2_minus_mean_abs,1),Vsp2_minus_mean_abs_std);
title('Espécie 2');
xlabel('Features');
ylabel('Mean with Standard Deviation');
grid on

suptitle('Plot of the mean with std in species 1 and 2 Absolute Values (Second Normalization)');

% Save sixth plot
saveas(h6,'Third Step Plot 2','fig')

%%% Plot of the mean of species 1 and 2 Absolute Values (Second Normalization)
h7 = figure;
plot(mean(Vsp1_minus_mean_abs,1),'bo-','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
hold
errorbar(mean(Vsp1_minus_mean_abs,1),Vsp1_minus_mean_abs_std);
plot(mean(Vsp2_minus_mean_abs,1),'r^-','MarkerFaceColor',[.29 .5 .23],'MarkerSize',10);
errorbar(mean(Vsp2_minus_mean_abs,1),Vsp2_minus_mean_abs_std,'r');
title('Mean of species 1 and 2 Absolute Values (Second normalization)');
xlabel('Features');
ylabel('Mean');
legend('Specie 1','Specie 2');
grid on

% Save seventh plot
saveas(h7,'Third Step Plot 3','fig')

%% FOURTH STEP
% Third normalization, divide the second normalization by mean of features
Vsa1_mean_vector = mean(Vsp1_minus_mean_abs,1);
Vsa1_mean_vector = repmat(Vsa1_mean_vector,size(sp1,1),1);
Vsa2_mean_vector = mean(Vsp2_minus_mean_abs,1);
Vsa2_mean_vector = repmat(Vsa2_mean_vector,size(sp2,1),1);

Vsa1 = Vsp1_minus_mean_abs./Vsa1_mean_vector;
Vsa2 = Vsp2_minus_mean_abs./Vsa2_mean_vector;

Vsa1_std = std(Vsa1,0,1);
Vsa2_std = std(Vsa2,0,1);

%%% Plot of the mean with std in species 1 and 2 Absolute Values (Third Normalization)
h8 = figure;
subplot(2,1,1);
plot(mean(Vsa1),'mo','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
hold
errorbar(mean(Vsa1),Vsa1_std);
title('Espécie 1');
xlabel('Features');
ylabel('Mean with Standard Deviation');
grid on

subplot(2,1,2);
plot(mean(Vsa2),'r^-','MarkerFaceColor',[.29 .5 .23],'MarkerSize',10);
hold
errorbar(mean(Vsa2),Vsa2_std);
title('Espécie 2');
xlabel('Features');
ylabel('Mean with Standard Deviation');
grid on

suptitle('Plot of the mean with std in species 1 and 2 Absolute Values (Third Normalization)');

% Save eighth plot
saveas(h8,'Fourth Step Plot 1','fig')

%%% Plot of the mean of species 1 and 2 Absolute Values (Third Normalization)
h9 = figure;
plot(mean(Vsa1),'bo-','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
hold
plot(mean(Vsa2),'r^-','MarkerFaceColor',[.29 .5 .23],'MarkerSize',10);
title('Mean of species 1 and 2 Absolute Values (Second normalization)');
xlabel('Features');
ylabel('Mean');
legend('Specie 1','Specie 2');
grid on

% Save ninth plot
saveas(h9,'Fourth Step Plot 2','fig')
clear h1 h2 h3 h4 h5 h6 h7 h8 h9