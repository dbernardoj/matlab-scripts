%Le o arquivo no formato do Excell
filename = '/Users/iraquitanfilho/Desktop/TCC Data/Dados mfVEP.xlsx';


%Especifica o nome das tabelas internas do arquivo
sheet1 = 'Saudavel 1';
sheet2 = 'Doentes 1';
sheet3 = 'Saudavel 2';
sheet4 = 'Doentes 2';


%Cria uma variavel para receber os valores de cada tabela
saudaveis1 = xlsread(filename, sheet1, 'a1:p60');
doentes1 = xlsread(filename, sheet2, 'a1:p60');
saudaveis2 = xlsread(filename, sheet3, 'a1:p60');
doentes2 = xlsread(filename, sheet4, 'a1:p60');


%Cria matriz X concatenando verticalmente 64x60
X = vertcat(saudaveis1',saudaveis2',doentes1',doentes2');

%Cria matriz X concatenando verticalmente 64x30 (31-60)
%X = vertcat(saudaveis1(31:60,:)',saudaveis2(31:60,:)',doentes1(31:60,:)',doentes2(31:60,:)');

%Cria matriz X concatenando verticalmente 64x30 (1-30)
%X = vertcat(saudaveis1(1:30,:)',saudaveis2(1:30,:)',doentes1(1:30,:)',doentes2(1:30,:)');

%Cria matriz X concatenando verticalmente 64x30 (15-45)
%X = vertcat(saudaveis1(16:45,:)',saudaveis2(16:45,:)',doentes1(16:45,:)',doentes2(16:45,:)');

%Cria matriz X concatenando horizontalmente 60x64
%X = horzcat(saudaveis1,saudaveis2,doentes1,doentes2);


%Criacao da matriz menos a media
[d, n] = size(X);
Xbarra = mean(X);
%Xbarra2 = mean(X,1);
Xchapeu = X - ones(d,1)*Xbarra;
%Xchapeu2 = X - repmat(Xbarra2,d,1);

%Matri de covariancia
Covx = Xchapeu*Xchapeu';
Cx = cov(Xchapeu');

%PCA usando funcao pcacov
[eigvectors,eigvalues] = pcacov(Cx);
pc = eigvectors'*Xchapeu;


%plot of original data set
figure;
plot(X(1:32,1),X(1:32,2),'.');
%legend('saudaveis');
hold all
%figure;
plot(X(33:64,1),X(33:64,2),'x');
title('{\bf Original Data} Everyone with all features (1-60)'); xlabel('Principal Component 1'); ylabel('Principal Component 2')
%legend('doentes');
%view([30 40]);
legend('saudaveis','doentes');

%plot PCA space of the first two PCs: PC1 and PC2
figure;
plot(pc(1:32,1),pc(1:32,2),'.');
%legend('saudaveis');
hold all
%figure;
plot(pc(33:64,1),pc(33:64,2),'x');
title('{\bf PCA} Everyone with all features (1-60)'); xlabel('Principal Component 1'); ylabel('Principal Component 2')
%legend('doentes');
%view([30 40]);
legend('saudaveis','doentes');


%{
%Plot dos PCs (pc = eigvectors'*Xchapeu)
figure;
plot(pc);
title('{\bf PCA} Plot dos PCs');
%}

%{
%plot PCA space of the first two PCs: PC1 and PC2
figure;
plot(eigvectors(1:32,1),eigvectors(1:32,2),'.');
%legend('saudaveis');
hold all
%figure;
plot(eigvectors(33:64,1),eigvectors(33:64,2),'x');
title('{\bf PCA} Everyone with all features (1-60)'); xlabel('Principal Component 1'); ylabel('Principal Component 2')
%legend('doentes');
%view([30 40]);
legend('saudaveis','doentes');
%}

%Reconstrucao de X
Xrec = eigvectors*pc + ones(d,1)*Xbarra;