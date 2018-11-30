function [ XX ] = myhist( X, minX, maxX, nbins )
%Computes the histogram based on given limits
%  Carlos E Puente and Mahesh L Maskey 05282015
XX = zeros(nbins,1);
xminX = (minX-min(X))/(max(X)-min(X));
xmaxX = (maxX-min(X))/(max(X)-min(X));
for i = 1:numel(X)
    xi = (X(i) - min(X))/(max(X) - min(X));
    if xminX < xi || xi < xmaxX
        n = floor(xi*nbins)+ 1;
        if n > nbins, n = nbins; end
        XX(n) = XX(n) + 1;
    end
end     
end

