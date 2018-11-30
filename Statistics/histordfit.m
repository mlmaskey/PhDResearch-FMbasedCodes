function [ hh, hh3 ] = histordfit( X, minX, maxX, nbins )
% function [ hh, hh3 ] = histord( X, binrange )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
N = numel(X);
hh = myhist( X, minX, maxX, nbins );
hh2 = zeros(2*numel(hh),2);
for kkr=1:length(hh)
    hh2(2*kkr-1,:) = [kkr-1 hh(kkr)/N];
    hh2(2*kkr,:) = [kkr hh(kkr)/N];       
end
hh3 = [0 0; hh2; kkr 0];
end

