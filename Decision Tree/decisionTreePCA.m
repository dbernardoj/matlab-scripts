%Le o arquivo no formato do Excell
filename = '/Users/iraquitanfilho/Desktop/TCC Data/Dados mfVEP.xlsx';
status_fn = '/Users/iraquitanfilho/Desktop/TCC Data/status mfVEP.xlsx';


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

%Criacao da matriz menos a media
[d, n] = size(X);
Xbarra = mean(X);
%Xbarra2 = mean(X,1);
Xchapeu = X - ones(d,1)*Xbarra;

%Matri de covariancia
Covx = Xchapeu*Xchapeu';
Cx = cov(Xchapeu');

%PCA usando funcao pcacov
[eigvectors,eigvalues] = pcacov(Cx);
pc = eigvectors'*Xchapeu;

%Using all components
people_meas = pc;
%Using first 30 components
%people_meas = pc(:, 1:30);
%Using last 30 components
%people_meas = pc(:,31:60);
%Using the mid components (15~45)
%people_meas = pc(:,15:45);

[~,~,raw] = xlsread(status_fn);

people_status = raw;

names_label = {'1','2','3','4','5','6','7','8','9','10','11','12','13',...,
    '14','15','16','17','18','19','20','21','22','23','24','25','26',...,
    '27','28','29','30','31','32','33','34','35','36','37','38','39',...,
    '40','41','42','43','44','45','46','47','48','49','50','51','52',...,
    '53','54','55','56','57','58','59','60'};

t = classregtree(people_meas, people_status);
%t = classregtree(people_meas, people_status, 'names',names_label);
view(t);