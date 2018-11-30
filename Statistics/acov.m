function [ gamma ] = acov( X, tau )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
N = numel(X);
mu = mean(X);
if tau == 0
    gamma = var(X);
else
    Xtau = X(tau+1:end);
    Ntau = numel(Xtau);
    X = X(1:Ntau);
    gammai = (X-mu).*(Xtau-mu);
    gamma = sum(gammai);
end
end

