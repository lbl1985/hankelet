function [HHp HHpFrob m] = calHHp(W)
% prepare function for H*Hp, (Hp stands for H prime)

[Nf, Np]=size(W);
Nf=Nf/2;

% each column is the trajectory of a single point
%

X=W(1:2:end,:);
Y=W(2:2:end,:);


xp=X(:,1);
yp=Y(:,1);
Hxp=hankel(xp(1:round(Nf/2)),xp(round(Nf/2):Nf));
Hyp=hankel(yp(1:round(Nf/2)),yp(round(Nf/2):Nf));
HH=[Hxp;Hyp];

Hp = [X; Y];
n = size(X, 1); m = size(Hxp, 1); p = n - m + 1;
maxRep = min(m, p);
if 2 * maxRep == n + 1
    R = [1 : maxRep maxRep - 1 : -1 : 1];
else
    R = [1 : maxRep ones(1, n - 2 * maxRep)*maxRep maxRep : -1 : 1];
end

Rmat = repmat(R, 1, 2);
HpFrob = sqrt(Rmat * Hp.^2);
HpNorm = Hp .* repmat(1 ./ HpFrob, size(Hp, 1), 1);

HHp = dividedH_Ht(HpNorm, m);

HHpFrob = dividedH_HtFrob(HHp, m);
