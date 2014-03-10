function [ W,bestidx ] = ReliefF( X,Y,k,T )
%RELIEFF Summary of this function goes here
%   Detailed explanation goes here

if ~exist('T','var')
    T=size(X,1);
end

% Set all weights W[A]=0
W = zeros(1,size(X,2));
% Randomly select instances Ri
R = randperm(length(Y));
R = R(1:T);
classes = unique(Y);

h1 = waitbar(0,'Inicializando ReliefF...',...
    'Name','ReliefF Feature Selection');

for i=1:T
    Ci = X(R(i),:); % Current instance
    rep_Ci = repmat(Ci,size(X,1),1); % Current instance
    CiC = Y{R(i)}; % Current instance class
    %measure the distance from x to every other example
    distances = sqrt(sum((X-rep_Ci).^2,2));
    %sort them according to distances (find nearest neighbours)
    [distances, originalidx] = sortrows(distances,1);
    distances = distances(2:end);
    originalidx = originalidx(2:end);
    hits = [];
    idx = 1;
    % Find k nearest hits H
    while (length(hits) < k)
        if strcmp(Y{originalidx(idx)},CiC)
            hits = [hits originalidx(idx)];
            %foundhit = true;
        end
        idx=idx+1;
    end
    classes_m = classes;
    ind = ismember(classes,CiC);
    classes_m{ind} = [];
    classes_m(cellfun(@(classes_m) isempty(classes_m),classes_m))=[];
    misses_all = [];
    % Find k nearest misses M for every class
    for j=1:length(classes_m)
        misses = [];
        idx = 1;
        while (length(misses) < k)
            if strcmp(Y{originalidx(idx)},classes_m{j})
                misses = [misses originalidx(idx)];
            end
            idx=idx+1;
        end
        misses_all = vertcat(misses_all,misses);
    end
    alpha = 1/(T*k);
    for f=1:size(X,2)
        hitpenalties = 0;
        misspenalties = 0;
        for j=1:k
            hitpenalty  = abs((Ci(f)-X(hits(j),f)))  / (max(X(:,f))-min(X(:,f)));
            for c=1:length(classes_m)
                misspenalty = abs((Ci(f)-X(misses_all(c,j),f))) / (max(X(:,f))-min(X(:,f)));
                prob = (sum(ismember(Y,classes_m{c}))/length(Y))/(1-(sum(ismember(Y,CiC))/length(Y)));
                misspenalties = misspenalties + prob * misspenalty;
            end
            % WORK HERE!
            
            hitpenalties = hitpenalties + hitpenalty;
        end
        W(f) = W(f) - alpha*hitpenalties^2 + alpha*misspenalties^2;
    end
    [~,bestidx] = sort(W,'descend');
    
    perc1 = i/T*100;
    waitbar(i/T,h1,sprintf('%3.2f%% concluido...',perc1))
end

end