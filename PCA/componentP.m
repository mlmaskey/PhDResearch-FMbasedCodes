function [PC]  = componentP(param, npk, method)
% extracts the principal components based on number of parameters to keep
% param = set of variables
% method = to be normalized or raw if normalization require 'z' case
% sensitive
nparam = size(param,2);
nseries = size(param,1);
if method == 'z'
    pz = zscore(param);
    covm = cov(pz);
else
    covm = cov(param);
end
[V, D] = eig(covm);
lambda = zeros(nparam,1);
for i = 1:nparam
    lambda(i) = D(i,i);
end
Ncombine = 2^nparam;
states = zeros(Ncombine, nparam);
for i = 1: Ncombine
    binparam = dec2bin(i, nparam);
    for j = 1: nparam
        states(i,j) = str2num(binparam(j));
    end
end
totVar = sum(lambda);
states = [states(1:end-2,:); states(end,:)];
states = flipud(states);
nsates = size(states,1);
partialVar = zeros(nsates, 1);
fractionVar = zeros(nsates, 1);
for i = 1: nsates
    combCase = states(i, :); combCase = combCase(:);
    varCase = combCase.*lambda;
    partialVar(i,1) = sum(varCase);
    fractionVar(i,1) =  partialVar(i,1)/totVar;
end
[ idtake, totvar, statetake ] = filterstate( states, fractionVar, npk);
idparams = find(statetake ==1);
paramPC = zeros(nseries, numel(idparams));
eigVP = V(:, idparams);
for i = 1:numel(idparams)
    paramPC(:,i) = param(:,idparams(i));    
end
PC.eigVec = V;
PC.eigval = lambda;
PC.idtake = idtake;
PC.totvar = totvar;
PC.statetake = statetake;
PC.paramPC = paramPC;
PC.eigVP = eigVP;
end