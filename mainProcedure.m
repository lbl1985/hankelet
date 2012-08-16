%% Adding Path 
addpath(genpath(getProjectBaseFolder));

%% Testing Section 1: loading and testing on large data set
% 
% Load data
load testData.mat
params.num_km_init_word = 3;
params.MaxInteration = 3;
params.labelBatchSize = 200000;
params.actualFilterThreshold = -1;
params.find_labels_mode = 'DF';

X_train = X(:, 1:end/2);
X_test  = X(:, end/2 + 1 : end);
clear X;

% kmeans to learn cluster centers
trainCenter = cell(1, params.num_km_init_word);
for i = 1 : params.num_km_init_word    
    
    [~, trainCenter{i} trainClusterMu trainClusterSigma trainClusterNum] = litekmeans_subspace(X_train, ncenter,params);

    params.trainClusterInfo{i}.mu = trainClusterMu;
    params.trainClusterInfo{i}.sigma = trainClusterSigma;
    params.trainClusterInfo{i}.num = trainClusterNum;
    
    params.trainClusterNum{i} = size(trainCenter{i}, 2);       

end

% labeling 
LABEL = cell(params.num_km_init_word, 1);
CLASS_HIST  = cell(params.num_km_init_word, 1);
params = cal_cluster_info(params);

for i = 1 : params.num_km_init_word
    [LABEL{i}, ~, CLASS_HIST{i}] = find_weight_labels_df_HHp_newProtocal({trainCenter{i}}, X_test, params);
end

%% Testing Section 2: loading and testing on Video
clear;
load person_trial.mat;
params.num_km_init_word = 1;
params.MaxInteration = 3;
params.labelBatchSize = 200000;
params.actualFilterThreshold = -1;
params.find_labels_mode = 'DF';


word = litekmeans_subspace(X_train, ncenter,params);
visualTrajectories(word, trajectory, frameId, isRecord);