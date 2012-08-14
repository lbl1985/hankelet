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