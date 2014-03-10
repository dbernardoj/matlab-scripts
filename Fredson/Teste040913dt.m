%% TESTE DE CLASSIFICACAO USANDO DECISION TREE
% TUTORIAL RECOMENDADO PELO PROFESSOR SCHUBERT, AQUI FOI IMPLEMENTADO UM
% LACO PARA A REALIZACAO DO CALCULO VARIAS VEZES REMOVENDO A CADA VEZ UM
% ELETRODO DIFERENTE E ARMAZENANDO O RESULTADO DE DESEMPENHO.
% AQUI SE REALIZA OS PASSOS I, II E III DO TUTORIAL

%% ABOUT
% * Author: Iraquitan Cordeiro Filho
% * Mentor: Schubert Carvalho
% * Company: Institudo Tecnologico Vale - Desenvolvimento Sustentavel

%% PRELIMINARIES
% Clear our workspace
clc;clear;

INICIO = datestr(clock);

OBS = 'Teste  de classicação implementando o tutorial recomendado pelo Schubert, aqui se realiza os passos I, II e III do tutorial seguindo o passo III do tutorial aqui foi utilizado Decision Tree no lugar do pwelch';

load sp1s_aa.mat

xnew = []; 
xtrial = [];

for i = 1:size(x_train,3)
 for j = 1:28;
 
 a = x_train(:,j,i);
 [cA1,cD1] = dwt(a,'bior5.5');
 xtrial = [xtrial cA1'];
 
 end
 
 xnew = [xnew; xtrial];
 xtrial = [];
 end
 
 score = 0;
 
 for n = 1:size(x_train,3)
 xnewer = [xnew(1:n-1,:); xnew(n+1:end, :)];
 y_train_newer = [y_train(:,1:n-1) y_train(:,n+1:end)];
 
% solve
 
 c = pinv(xnewer'*xnewer)*(xnewer'*y_train_newer');
 
% test
 
 testit = xnew(n,:)*c;
 
 if testit < 0.4637 
    testit = 0;
 else
    testit = 1;
 end
 
 if testit == y_train(:,n)
    score = score + 1;
    whichtrialsright(1,n) = 1;
 else
    whichtrialsright(1,n) = 0;
 end
 
 end
 
 pscore = (score/n)*100;


nick = ['SaidaTesteDT.mat']
FIM = datestr(clock);
save(nick)

beep

Teste130813bdwt2
