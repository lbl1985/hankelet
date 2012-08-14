function [label center muFinal sigmaFinal nEachCluster] = litekmeans_subspace(X, k, params)
% Main entries for Hankelet k-means algorithms
% Input: 
% X:    input data with m x n, m stands for feature dimension with (x, y)
% coordiante. such as 15 points with m = 30; [x1; y1; x2; y2; ... x15;
% y15], n stands for number of samples.
% k:    number of clusters for k-means algorithms.
% params: supports vector with fields: 
%       1. MaxInteration:       max interation for k-means
%       2. find_labels_mode:    'DF' (it will be removed later on)
% Output:
% label:        labels for each sample after kmeans
% center:       k cluster centers
% muFinal:      mu for each cluster center
% sigmaFinal:   sigma for each cluster center
% nEachCluster: number of samples for each cluster
% 
% Example: 
% load testData.mat
% [label center mu sigma nSamples] = litekmeans_subspace(X, ncenter,params);
% Binlong Li    18 June 2012



n = size(X,2);
last = 0;
label = ceil(k*rand(1,n));  % random initialization
% MaxInteration = 50;
MaxInteration = params.MaxInteration;
mode = params.find_labels_mode;

muBatch = zeros(k, MaxInteration);
sigmaBatch = zeros(k, MaxInteration);

[XInfo.XHHp XInfo.XHHpFrob m] = calHHp(X);
XInfo.w = [ones(1, 2 * m) 2 * ones(1, length(2*m+1 : size(XInfo.XHHp, 1)))];

count = 1;
% matlabpool open
pool_turner;
while any(label ~= last) && count <= MaxInteration
    [~,~,label] = unique(label);   % remove empty clusters
    k = length(unique(label));      % Chang the number of clusters accordingly
    fprintf('cluster #: %d\n', k);
    E = sparse(1:n,label,1,n,k,n);  % transform label into indicator matrix

        [center, indAbsolute muBatch(1:k, count) sigmaBatch(1:k, count)] = ...
            estimateCenters_final(X, E, k, XInfo);      % compute center of each cluster
        
    last = label;
           
            centerDistances = relativeDynamicsDistance_HHp(XInfo.XHHp, XInfo.XHHpFrob, indAbsolute, XInfo.w);
    
    [~, label] = max(centerDistances);

    writenum2(count);
    count = count + 1;
end
matlabpool close

display(num2str(std(sigmaBatch(1:k, :))));

muFinal = muBatch(1:k, end);
sigmaFinal = sigmaBatch(1:k, end);
nEachCluster = histc(label, 1 : k);

% Sort the order of cluster by number of instances in each cluster
[nEachCluster, IX] = sort(nEachCluster, 'descend');

center = center(:, IX);
muFinal = muFinal(IX);
sigmaFinal = sigmaFinal(IX);

end

function [centers indAbsolute mu sigma] = estimateCenters_final(X, indicator, k, XInfo)
centers = zeros(size(X, 1), k);
indAbsolute = zeros(1, k);
indicatorI = cell(k, 1);
tempX = cell(k, 1);
tempXHHp = cell(k, 1);
tempXHHpFrob = cell(k, 1);


for i = 1 : k
    indicatorI{i} = find(indicator(:, i));
    tempX{i} = X(:, indicatorI{i});
    tempXHHp{i} = XInfo.XHHp(:, indicatorI{i});
    tempXHHpFrob{i} = XInfo.XHHpFrob(:, indicatorI{i});
end
w = XInfo.w;
clear X;    clear XInfo;

mu = zeros(k, 1);
sigma = zeros(k, 1);
% matlabpool open
for i = 1 : k
    % depend on mode. DF could be DF1 or DF2.
    DF = relativeDynamicsDistance_HHp(tempXHHp{i}, tempXHHpFrob{i}, 1, w);
    
    [centers(:, i) ind]= getCenter(tempX{i}, DF);
    indAbsolute(i) = indicatorI{i}(ind);
    
    % Compute the distance to the cluster representative
    DF2 = relativeDynamicsDistance_HHp(tempXHHp{i}, tempXHHpFrob{i}, ind, w);
    mu(i) = mean(DF2);
    sigma(i) = std(DF2);
    %     fprintf('cluster %d at relative\\abs entry: %d\\%d \n', i, ind, indAbsolute(i));
end
% matlabpool close
end

function [center ind]= getCenter(data, distanceMeasure)
[~, ind] = min((distanceMeasure - mean(distanceMeasure)).^2);
center = data(:, ind);
end