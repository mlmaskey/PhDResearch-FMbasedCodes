function [ YY ] = myhist( Y, minX, maxX, nbins )
%Computes the histogram based on given limits
%  Carlos E Puente and Mahesh L Maskey 05282015
YY = zeros(nbins,1);

for i = 1:numel(Y)
    yi = Y(i);
    if minX <= yi && yi <= maxX
        n = floor((yi - minX)/(maxX - minX)*nbins)+ 1;
        if n > nbins, n = nbins; end
        YY(n) = YY(n) + 1;
    end
end  
yySum = sum(YY);
if yySum < numel(Y)
    YY(nbins) = YY(nbins) + numel(Y) - yySum;
end
end

