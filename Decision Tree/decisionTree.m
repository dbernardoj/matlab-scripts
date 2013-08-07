%Le o arquivo no formato do Excell
%filename = '/Users/iraquitanfilho/Desktop/TCC Data/Dados mfVEP.xlsx';
%status_fn = '/Users/iraquitanfilho/Desktop/TCC Data/status mfVEP.xlsx';

%Le o arquivo no formato do Excell
filename = '/Users/pma007/Dropbox/TCC/Dados/Dados mfVEP.xlsx';
status_fn = '/Users/pma007/Dropbox/TCC/Dados/status mfVEP.xlsx';

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
people_meas = vertcat(saudaveis1',saudaveis2',doentes1',doentes2');

[~,~,raw] = xlsread(status_fn);

people_status = raw;

names_label = {'1','2','3','4','5','6','7','8','9','10','11','12','13',...,
    '14','15','16','17','18','19','20','21','22','23','24','25','26',...,
    '27','28','29','30','31','32','33','34','35','36','37','38','39',...,
    '40','41','42','43','44','45','46','47','48','49','50','51','52',...,
    '53','54','55','56','57','58','59','60'};

%t = classregtree(people_meas, people_status);
%t = classregtree(people_meas, people_status, 'names',names_label,...,
%'splitcriterion', 'deviance');
%view(t);

tree = ClassificationTree.fit(people_meas,people_status);
view(tree, 'mode', 'graph');

%Resubstitution Error of a Classification Tree
%{
Resubstitution error is the difference between the response training data and
the predictions the tree makes of the response based on the input training
data. If the resubstitution error is high, you cannot expect the predictions
of the tree to be good. However, having low resubstitution error does not
guarantee good predictions for new data. Resubstitution error is often an
overly optimistic estimate of the predictive error on new data.
%}

resuberror = resubLoss(tree);
formatResuberror = 'Resubstitution Error is %f.';
asw1 = sprintf(formatResuberror,resuberror);
disp(asw1);

%Cross Validate the tree.
%{
To get a better sense of the predictive accuracy of your tree for new data,
cross validate the tree. By default, cross validation splits the training
data into 10 parts at random. It trains 10 new trees, each one on nine parts
of the data. It then examines the predictive accuracy of each new tree on the
data not included in training that tree. This method gives a good estimate of
the predictive accuracy of the resulting tree, since it tests the new trees
on new data.
%}
cvtree = crossval(tree);
cvloss = kfoldLoss(cvtree);
formatCrossValidation = 'Cross Validation error is %f.';
asw2 = sprintf(formatCrossValidation,cvloss);
disp(asw2);


%Determining best tree depth
leafs = logspace(1,2,10);

rng('default')
N = numel(leafs);
err = zeros(N,1);
for n=1:N
    t = ClassificationTree.fit(people_meas,people_status,'crossval','on',...
        'minleaf',leafs(n));
    err(n) = kfoldLoss(t);
end
plot(leafs,err);
xlabel('Min Leaf Size');
ylabel('cross-validated error');