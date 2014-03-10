% teste de calssicação implementado o tutorial recomendado pelo pro
% Schubert

% aqui se realiza os passos I e II do tutorial 

clc;clear;

ti = cputime;

load sp1s_aa.mat

xnew = []; 
xtrial = [];


for i = 1:size(x_train,3)
%     for j = 13:19
    for j = 13:19; %1:28
        a = x_train(:,j,i);
        xtrial = [xtrial a'];
    end
    
    xnew = [xnew; xtrial];
    xtrial = [];

end

score = 0;

for n=1:size(x_train,3)
    
    xnewer = [xnew(1:n-1,:); xnew(n+1:end, :)];
    y_train_newer = [y_train(:,1:n-1) y_train(:,n+1:end)];
    
    %solve
    
    c = pinv(xnewer'*xnewer)*(xnewer'*y_train_newer');
    
    %test
    
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

pscore = (score/n)*100

nick = ['SaidaTesteAmp.mat']
FIM = datestr(clock);
save(nick)

beep

tempo = cputime - ti

