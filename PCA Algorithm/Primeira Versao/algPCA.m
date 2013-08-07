%Le o arquivo no formato do Excell
filename = '/Users/iraquitanfilho/Desktop/TCC Data/Dados mfVEP.xlsx';

%Especifica o nome das tabelas internas do arquivo
sheet1 = 'Saudavel 1';
sheet2 = 'Doentes 1';
sheet3 = 'Saudavel 2';
sheet4 = 'Doentes 2';

%Cria uma variavel para receber os valores de daca tabela
saudaveis1 = xlsread(filename, sheet1, 'a1:p60');
doentes1 = xlsread(filename, sheet2, 'a1:p60');
saudaveis2 = xlsread(filename, sheet3, 'a1:p60');
doentes2 = xlsread(filename, sheet4, 'a1:p60');

% Matriz media dos saudaveis
Mhealth = arrayfun(@(saudaveis1,saudaveis2) mean([saudaveis1,saudaveis2]),saudaveis1,saudaveis2);

% Matriz media dos doentes
Msick = arrayfun(@(doentes1,doentes2) mean([doentes1,doentes2]),doentes1,doentes2);

% Matriz media dos saudaveis e doentes
Xhs = [Mhealth,Msick];
size(Xhs(1:30,:)')

X = [saudaveis1,saudaveis2,doentes1,doentes2];
%plot(saudaveis1);
%size(X)
%plot(saudaveis2);
figure;
%[W,pc] = princomp(X(16:30,:)); %pc = pc'; W = W';

%{
% Aplica o PCA na matriz Xhs' e separa entre saudaveis e doentes
[W,pc] = princomp(Xhs(30:60,:)'); %pc = pc'; W = W';
size(W)
plot(pc(1:16,1),pc(1:16,2),'.');
%legend('saudaveis');
hold on
%figure;
plot(pc(17:32,1),pc(17:32,2),'x');
title('{\bf PCA} Everyone - Xhs(32x60)feat(1-30)'); xlabel('PC 1'); ylabel('PC 2')
%legend('doentes');
legend('saudaveis','doentes');
%}

% Aplica o PCA na matriz Xhs e separa entre saudaveis e doentes
[pc,score,latent,tsquare] = princomp(Xhs(15:60,:)); %pc = pc'; W = W';
plot(pc(1:16,1),pc(1:16,2),'.');
%legend('saudaveis');
hold on
%figure;
%biplot(pc(:,1:2),'Scores',score(:,1:2),'VarLabels',x);
plot(pc(17:32,1),pc(17:32,2),'x');
title('{\bf PCA} Everyone - Xhs(32x60)feat(1-30)'); xlabel('PC 1'); ylabel('PC 2')
%legend('doentes');
legend('saudaveis','doentes');

%{
% Aplica o PCA na matriz X' e separa entre saudaveis e doentes
[W,pc] = princomp(X(30:60,:)'); %pc = pc'; W = W';
size(W)
plot(pc(1:32,1),pc(1:32,2),'.');
%legend('saudaveis');
hold on
%figure;
plot(pc(32:64,1),pc(32:64,2),'x');
title('{\bf PCA} Everyone - Xhs(32x60)feat(1-30)'); xlabel('PC 1'); ylabel('PC 2')
%legend('doentes');
legend('saudaveis','doentes');
%}

%{
%Aplica o PCA na tabela de saudaveis1
[W,pc] = princomp(saudaveis1(1:30,:)'); pc = pc'; W = W';
plot(pc(1,:),pc(2,:),'.');
title('{\bf PCA} saudaveis1'); xlabel('PC 1'); ylabel('PC 2')
hold on
figure;
%Aplica o PCA na tabela de saudaveis2
[W,pc] = princomp(saudaveis2(1:30,:)'); pc = pc'; W = W';
plot(pc(1,:),pc(2,:),'o');
title('{\bf PCA} saudaveis2'); xlabel('PC 1'); ylabel('PC 2')
hold on
figure;
%Aplica o PCA na tabela de doentes1
[W,pc] = princomp(doentes1(1:30,:)'); pc = pc'; W = W';
plot(pc(1,:),pc(2,:),'x');
title('{\bf PCA} doentes1'); xlabel('PC 1'); ylabel('PC 2')
hold on
figure;
%Aplica o PCA na tabela de doentes2
[W,pc] = princomp(doentes2(1:30,:)'); pc = pc'; W = W';
plot(pc(1,:),pc(2,:),'v');
title('{\bf PCA} doentes2'); xlabel('PC 1'); ylabel('PC 2')
%}

%{
% Apply PCA to saudaveis1
% remove the mean variable-wise (row-wise)
    s1=saudaveis1-repmat(mean(saudaveis1,2),1,size(saudaveis1,2));

% calculate eigenvectors (loadings) W, and eigenvalues of the covariance matrix
    [W, EvalueMatrix] = eig(cov(s1'));
    Evalues = diag(EvalueMatrix);

% order by largest eigenvalue
    Evalues = Evalues(end:-1:1);
    W = W(:,end:-1:1); W=W';

% generate PCA component space (PCA scores)
    pc = W * s1;

% plot PCA space of the first two PCs: PC1 and PC2
    plot(pc(1,:),pc(2,:),'.');
    title('{\bf PCA} saudaveis1'); xlabel('PC 1'); ylabel('PC 2')
    hold on

%Apply PCA to saudaveis2
% remove the mean variable-wise (row-wise)
    s2=saudaveis2-repmat(mean(saudaveis2,2),1,size(saudaveis2,2));

% calculate eigenvectors (loadings) W, and eigenvalues of the covariance matrix
    [W, EvalueMatrix] = eig(cov(s2'));
    Evalues = diag(EvalueMatrix);

% order by largest eigenvalue
    Evalues = Evalues(end:-1:1);
    W = W(:,end:-1:1); W=W';

% generate PCA component space (PCA scores)
    pc = W * s2;

% plot PCA space of the first two PCs: PC1 and PC2
    plot(pc(1,:),pc(2,:),'o');
    title('{\bf PCA} saudaveis2'); xlabel('PC 1'); ylabel('PC 2')
    hold on

%Apply PCA to doentes1
% remove the mean variable-wise (row-wise)
    d1=doentes1-repmat(mean(doentes1,2),1,size(doentes1,2));

% calculate eigenvectors (loadings) W, and eigenvalues of the covariance matrix
    [W, EvalueMatrix] = eig(cov(d1'));
    Evalues = diag(EvalueMatrix);

% order by largest eigenvalue
    Evalues = Evalues(end:-1:1);
    W = W(:,end:-1:1); W=W';

% generate PCA component space (PCA scores)
    pc = W * d1;

% plot PCA space of the first two PCs: PC1 and PC2
    plot(pc(1,:),pc(2,:),'x');
    title('{\bf PCA} doentes1'); xlabel('PC 1'); ylabel('PC 2')
    hold on

%Apply PCA to doentes2
% remove the mean variable-wise (row-wise)
    d2=doentes2-repmat(mean(doentes2,2),1,size(doentes2,2));

% calculate eigenvectors (loadings) W, and eigenvalues of the covariance matrix
    [W, EvalueMatrix] = eig(cov(d2'));
    Evalues = diag(EvalueMatrix);

% order by largest eigenvalue
    Evalues = Evalues(end:-1:1);
    W = W(:,end:-1:1); W=W';

% generate PCA component space (PCA scores)
    pc = W * d2;

% plot PCA space of the first two PCs: PC1 and PC2
    plot(pc(1,:),pc(2,:),'v');
    title('{\bf PCA} doentes2'); xlabel('PC 1'); ylabel('PC 2')
    hold on
%}

%plotagem dos graficos
%figure1 = plot(saudaveis1);
%figure2 = plot(doentes1);
%figure3 = plot(saudaveis2);
%figure4 = plot(doentes2);