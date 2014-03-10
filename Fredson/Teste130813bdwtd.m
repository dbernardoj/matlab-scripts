% teste de calssicação implementado o tutorial recomendado pelo prof
% Schubert
% aqui foi implementado um laço para a realização do caculo varias varias
% vezes removendo a cada vez um eletrodo diferente e armazenando o reultado
% de desempenho

% aqui se realiza os passos I, II e III do tutorial 

clc;clear;

INICIO = datestr(clock);

OBS = 'teste de calssicação implementado o tutorial recomendado pelo pro Schubert aqui se realiza os passos I, II e III do tutorial seguindo o passo III do tutorial aqui foi utilizado a Wavelet (DWT) no lugar do pwelch';

load sp1s_aa.mat

xnew = []; 
xtrial = [];

for i = 1:size(x_train,3)
 for j = 13:19;
 
 a = x_train(:,j,i);
 [cA1,cD1] = dwt(a,'bior5.5');
 xtrial = [xtrial cD1'];
 
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


nick = ['SaidaTesteDWTd.mat']
FIM = datestr(clock);
save(nick)

beep

