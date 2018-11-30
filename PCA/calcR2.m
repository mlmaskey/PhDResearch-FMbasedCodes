function [ rsquared ] = calcR2( Y, Yhat )
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here
TSS = sum((Y-mean(Y)).^2);
RSS = sum((Y-Yhat).^2);
rsquared = 1 - RSS/TSS;
end

