function [ stats ] = statsmov( N, tau )
%computes basic stattistic
%   Detailed explanation goes here
minX = zeros(N-tau+1,1);
meanX = zeros(N-tau+1,1);
stdX = zeros(N-tau+1,1);
maxX = zeros(N-tau+1,1);
totalX = zeros(N-tau+1,1);
CVX = zeros(N-tau+1,1);
series_name = '';
year_begin = 1950;
for i = 1:N
     [dirGraph, RName, Filein, DiaryFile, FileOut] = drawer(i, 1, series_name);
  dataname{i,1} = RName;
  year_end = year_begin + tau -1;
  periodName{i,1} = [int2str(year_begin) '-' int2str(year_end)];
  year_begin = year_begin+1;
end
namecell = cellstr(dataname);

 for i = 1:N-tau+1
     series_name = [char(namecell(i)) '-' char(namecell(i+tau-1))];
     [~, ~, Filein, ~] = drawer2(i, series_name, tau);
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

