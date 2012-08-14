function [X labels] = find_weight_labels_various_HHp_newProtocal(trainCenter, allVideoTraj, info_indices, params, module)
% This function is only used for finding weight DF distance, video
% distribution.
    switch module
        case 'cor'
            params.actualFilterThreshold = -1;
        case 'raw'
            params.actualFilterThreshold = -1;
    end
%     pool_turner
    params = cal_cluster_info(params);
    X = cell(params.num_km_init_word, 1);
    labels = cell(params.num_km_init_word, 1);
    for i = 1 : params.num_km_init_word
        [X{i} labels{i}] = formhistBagOfWord_weight(trainCenter(i), allVideoTraj, info_indices, params, module);        
    end
%     matlabpool close

end

function [X labels] = formhistBagOfWord_weight(center, allVideoTraj, info_indices, params, module)
    num_movies = length(info_indices);
    num_centroids = size(center{1}, 2);

    X = zeros(num_movies, num_centroids);
    tmpLabels = cell(num_movies, 1);

    parfor i = 1 : num_movies
        tmpVideoTraj = allVideoTraj(:, info_indices{i}.start : info_indices{i}.end);
        switch module
            case 'raw'
                [tLabels, ~, X(i, :)] = find_weight_labels_df_HHp(center, tmpVideoTraj, params);
                tmpLabels{i} = tLabels;
            case 'cor'
                [tLabels, ~, X(i, :)] = find_weight_labels_df_HHp_newProtocal(center, tmpVideoTraj, params); 
                tmpLabels{i} = tLabels';
        end
        writenum2(i);
    end
    labels = cell2mat(tmpLabels);
end


function params = cal_cluster_info(params)
    for init_word = 1 : params.num_km_init_word
        variance = params.trainClusterInfo{init_word}.sigma.^2;
        a = params.trainClusterInfo{init_word}.mu.^2 ./ variance;
        a(a<1) = 1.1;  % a <=1, numerial unstable.
        b = variance ./ (-params.trainClusterInfo{init_word}.mu);
        prior = params.trainClusterInfo{init_word}.num / sum(params.trainClusterInfo{init_word}.num);
        prior = prior';

        params.trainClusterInfo{init_word}.variance = variance;
        params.trainClusterInfo{init_word}.a = a;
        params.trainClusterInfo{init_word}.b = b;
        params.trainClusterInfo{init_word}.prior = prior;
    end
end