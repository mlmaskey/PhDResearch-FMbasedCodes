function [ newLocp ] = shiftHist( X, Y, nbins, p )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% [~, locExLX] = histLoc(X, nbins, p);
% [~, locExLY] = histLoc(Y, nbins, p);
locExLX = histLoc(X, nbins, p);
locExLY = histLoc(Y, nbins, p);
if locExLX > locExLY
   diff =  -1*(locExLX - locExLY);
elseif locExLX < locExLY
    diff = locExLY - locExLX;
else
    diff = 0;
end
newLocp = p + diff;
end

