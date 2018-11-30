function [ gammas ] = acovf( X, tau)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
lags = 0:1:tau;
gammas = zeros(tau+1, 1);
for i = 1:tau+1
    lag = lags(i);
    gammas(i) = acov(X,lag);
end   

end

