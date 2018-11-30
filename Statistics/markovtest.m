function markovMatrix = getMarkovian(data)
nmax = max(data);
nseries = numel(data);
jumpstates = zeros(nmax);
jmps = 1:nmax;
for i = 1:nmax
    X = jmps(i);
    for j = 1:nmax        
        Y = jmps(j);
        P = transitionProbability(data, X, Y);
        jumpstates(i,j) = P;        
    end    
end
markovMatrix = zeros(nmax);

for i = 1:nmax
    rowsum = sum(jumpstates(i,:));
    markovMatrix(i,:) = jumpstates(i,:)/rowsum;
    
end