% teste de calssicação implementado o tutorial recomendado pelo prof
% Schubert
% aqui foi implementado um laço para a realização do caculo varias varias
% vezes removendo a cada vez um eletrodo diferente e armazenando o reultado
% de desempenho

% aqui se realiza os passos I, II e III do tutorial 

clc;clear;

OBS = 'aqui foi utilizada a FFT no lugar do pwelch';

load sp1s_aa.mat

xnew = []; 
xtrial = [];

NC = size(x_train,2);
 
for i = 1:size(x_train,3)
    for j = 1:28;
        a = x_train(:,j,i);
        Fs = 100;
        T = 1/NC;
        t = (0:NC-1)*T;
        NFFT = 2^nextpow2(NC);
        Y = abs(fft(a,NFFT)/NC);
        
        Y = Y(2:NFFT/2+1);
        
        xtrial = [xtrial Y'];
    
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
 

nick = ['SaidaTesteFFT.mat']
FIM = datestr(clock);
save(nick)

beep

Teste130813bdwt

