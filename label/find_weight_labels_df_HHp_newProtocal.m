function [labels dis histX] = find_weight_labels_df_HHp_newProtocal(center,X, params)
% compute the distance for testing data samples to the trained cluster
% centers
% Input:
% center:       cluster center samples
% X:            Testing samples
% params:       container for supporting information for previous functions
% Output:
% labels:       label for each testing samples
% dis:          distance to cluster centers according to each data sample
% histX:        histogram of X for different cluster centers (histogram for
%               labels)
% 
% Binlong Li        18 June 2012



% X features are column wised.
% since the num_km_init_word loop is outside this function, in
% find_labels_df_HHp_invest functioin. 
% Therefore, we only need to care one init in this function.
blksize = params.labelBatchSize;
nr_desc = size(X, 2);

histX = zeros(1, size(center{1}, 2));

centerInfo = cell(1, params.num_km_init_word);

nr_calculated = 0;

[centerInfo{1}.centerHHp centerInfo{1}.centerHHpFrob params.m] = calHHp(center{1});

m = params.m;
params.w = [ones(1, 2 * m) 2 * ones(1, length(2*m+1 : size(centerInfo{1}.centerHHp, 1)))];

while(nr_calculated<nr_desc)
    nr_tocalc = min(nr_desc-nr_calculated, blksize);
    head = nr_calculated+1;
    tail = nr_calculated+nr_tocalc;
    X_blk = X(:, head:tail);
    X_blk = double(X_blk);
    
    [X_blkInfo.XHHp X_blkInfo.XHHpFrob] = calHHp(X_blk);
    
    [labels dis score]= findaword_HHp_newProtocal(centerInfo{1}, ...
        X_blkInfo, params);
    
    histX = histX + histc(labels, (1 : size(center{1}, 2)));
    
    nr_calculated  = nr_calculated + nr_tocalc;
end

end