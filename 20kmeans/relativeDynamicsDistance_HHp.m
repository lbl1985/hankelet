function DF = relativeDynamicsDistance_HHp(HHp, HHpFrob, index, w)
% compute the relative distance from all samples to each cluster centers,
% which is indicated by index
% Input:
% HHp:      pre computed H * Hp for each sample
% HHpFrob:  pre computed Frob norm for each data sample
% index:    index for cluster center
% w:        weighting matrix for saving computation cost(more detail
% explainations will be documented soon)
% Output:
% DF:       distance for each sample according to size(index) cluster
% centers
% 
% Binlong Li        18 June 2012

% --------  Following section for new Metrics: --------------
% HHp = (Hp * Hp') / norm(Hp * Hp', 'frob');
% d(p, q) = 2 - norm(HHp + HHq, 'frob');

HHpFrobNorm = bsxfun(@power, (w * bsxfun(@power, HHp, 2)), 1/2);
HHp = bsxfun(@times, HHp, 1./HHpFrobNorm);
% -----------------------------------------------------------

Np = size(HHp, 2);

indexHHp = HHp(:, index);
indexHHpFrob = HHpFrob(index);
  
HHk = zeros(length(index), Np);
parfor k = 1 : length(index)
    HHk(k, :) = bsxfun(@power, (w * bsxfun(@power, bsxfun(@plus, HHp, indexHHp(:, k)), 2)), 1/2);
end
% --------  Following section for new Metrics: --------------
DF = bsxfun(@minus, 2, HHk);

DF = -DF;

return
