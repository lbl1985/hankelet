%quick wrapper for min Euclidean distance for kmeans labeling
% X contains columsn wised feature.
function [vword dis score] = findaword_HHp_newProtocal(centerInfo, XInfo, params)

% if ~isempty(params.trainClusterInfo{1})  
% %     [centerHHp centerHHpFrob params.m] = calHHp(center);
%     % Since center and testing data are using the same hankelWindowSize. we
%     % only need one m here.
%     [dataHHp dataHHpFrob] = calHHp(X);
%     vword = findawordKNN(center.centerHHp, center.centerHHpFrob, dataHHp, dataHHpFrob, params);
% else

    ncenter = size(centerInfo.centerHHp, 2);
    tmpScore = relativeDynamicsDistance_HHp([centerInfo.centerHHp XInfo.XHHp], ...
        [centerInfo.centerHHpFrob XInfo.XHHpFrob], 1 : ncenter, params.w);
    score = tmpScore(:, ncenter + 1 : end);
    
    score = score .* bsxfun(@ge, score, params.actualFilterThreshold);
    qualifiedId = find(sum(score, 1));
    score = score(:, qualifiedId); %#ok<FNDSB>

    [dis,vword] = max(score, [], 1); 
% end


end