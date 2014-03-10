% Loads
load 'especie'
load 'novo_nao_norm_vetorABCHVD'
load 'novo_norm_vetorABCHVD'

% cell array of strings from character array
especie = cellstr(especie);

features_label = cell(1,size(vetor,2));
for i=1:size(vetor,2)
    features_label{i} = num2str(i);
end

features1_label = cell(1,length(features));
for i=1:length(features)
    features1_label{i} = num2str(features(i));
end

% Generating the trees
Tree = ClassificationTree.fit(vetor(:,features),new_spe,'PredictorNames',features1_label);
view(Tree, 'mode', 'graph');