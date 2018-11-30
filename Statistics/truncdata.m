function [ Y ] = truncdata( X, t )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    N = numel(X);
    nscale = floor(N/t);
    Nnew = nscale*t;
%     Xnew = zeros(Nnew, 1);
    Xnew = X(1:Nnew);
    Y = Xnew;
end

