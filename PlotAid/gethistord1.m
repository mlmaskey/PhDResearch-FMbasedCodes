function [ histobj ] = gethistord( X, Y, nbins)
%Computes the histograms for X and Y vectors
%  adjust the ordinates
binrange = linspace(min(X), max(X), nbins);
xx = histc(X, binrange);
yy = histc(Y, binrange);
if max(Y) > max(X)
    nexcess = sum(xx)-sum(yy);
    yy(end) = yy(end) + nexcess;
end
[ xx, xx3 ] = histord( X, xx );
[ yy, yy3 ] = histord( Y, yy );
histobj.nbins = nbins;
histobj.xx = xx;
histobj.xx3 = xx3;
histobj.X = X;
histobj.yy = yy;
histobj.yy3 = yy3;
histobj.Y = Y;
end

function [ xx, xx3 ] = histord( X, xx )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
N = numel(X);
xx2 = zeros(2*length(hist(X)),2);
for i=1:length(xx)
    xx2(2*i-1,:) = [i-1 xx(i)/N];
    xx2(2*i,:) = [i xx(i)/N];       
end
xx3 = [0 0; xx2; i 0];
end
