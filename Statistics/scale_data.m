function [ X_sc ] = scale_data( X,t )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    X = X(:);
    N = numel(X);
    if rem(N, t) == 0
        ncol = N/t;
    else 
        ncol = floor(N/t);
    end
    X = truncdata(X, t);
    X = X(:);
    X_sort = reshape(X, t, ncol);
    X_sc = sum(X_sort);
end

