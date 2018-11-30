prgm = 1;
Nyears = 51;
best = 1;
runoff = FM_obj(prgm,Nyears,best);
param = cell2mat(runoff.parray);
nparam = size(param,2);
pz = zscore(param);
covm = cov(param);
% covm = cov(pz);
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
[maxcase, id] = max(fractionVar)
maxstate = states(id,:)
[ idtake, totvar, statetake ] = filterstate( states, fractionVar, 3 )
idparams = find(statetake ==1);
paramPC = zeros(nparams, numel(idparams));
for i = 1:numel(idparams)
    paramPC(:,i) = param(:,idparams(i));
end