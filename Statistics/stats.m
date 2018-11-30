function [ stats ] = stats( N )
%computes basic stattistic
%   Detailed explanation goes here
minX = zeros(N,1);
meanX = zeros(N,1);
stdX = zeros(N,1);
maxX = zeros(N,1);
totalX = zeros(N,1);
CVX = zeros(N,1);

 for i = 1:N
     [~, ~, Filein, ~, ~] = drawer(i, 1);
     data = load(Filein);
     minX(i,1) = min(data);
     meanX(i,1) = mean(data);
     stdX(i,1) = std(data);
     maxX(i,1) = max(data);
     CVX(i,1) = stdX(i,1)/meanX(i,1);
     totalX(i,1) = sum(data);
end
 stats.minX = minX;   
 stats.meanX = meanX;   
 stats.maxX = maxX;   
 stats.stdX = stdX;   
 stats.CVX = CVX;   
 stats.totalX = totalX;   


end

