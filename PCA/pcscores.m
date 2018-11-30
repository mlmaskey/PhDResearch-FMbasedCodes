function [ PCAtake, PCAvar, pc, idPC, pcscores,V] = pcscores(X, ncomp)

[N, nX ]= size(X);
Xscores = zscore(X);
covm = cov(Xscores);
[V, D] = eig(covm);
lambda = zeros(nX,1);
for i = 1:nX
    lambda(i) = D(i,i);
end
Ncombine = 2^nX;
states = zeros(Ncombine, nX);
for i = 1: Ncombine
    binX = dec2bin(i, nX);
    for j = 1: nX
        states(i,j) = str2num(binX(j));
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
[ PCAtake, PCAvar, statetake ] = filterstate( states, fractionVar, ncomp );
idPC = find(statetake ==1);
pc = zeros(N, numel(idPC));
for i = 1:numel(idPC)
    pc(:,i) = X(:,idPC(i));
end
pcscores = X*V;
end