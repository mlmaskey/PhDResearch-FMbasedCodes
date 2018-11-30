function [ Y ] = denormalize( X, y, xm )
%denormalize the projection y for X
%   xm is the minimum value of X
% if xm = 0 it computes minimum by default
if xm ~= 0;
    xmin = xm;
else
    xmin = min(X);
end
Xw0Min = X- xmin;
Xsum = sum(Xw0Min);
Yw0Min = y*Xsum;
Y = Yw0Min + xmin; 
end

