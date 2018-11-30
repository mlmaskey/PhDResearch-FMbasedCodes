function [ maxhole ] = holemax( X )
% function [ keep, maxhole ] = holemax( X )
%calculates the length of zeros in data set
%   Detailed explanation goes here
    N = length(X);
    lz = zeros(N,1);
    for i = 2:N
        if X(i) == 0
            lz(i) = 0; % sets inititial element zero when encounters zero
            if X(i) ==0 && X(i-1) ==0 
                lz(i) = 1; % assign one after first zero if second one is zero
            else 
                lz(i) = 0;
            end
        end
    end
    holelen = zeros(N,1);
    for i = 1:N
        if lz(i) == 1
%             ln = 1;
            if lz(i) == lz(i-1)
                ln = ln+1;
            else
                ln = 0;
            end
        else
            ln = 0;
        end
        holelen(i) = ln;
    end
%     keep = [lz holelen];
    maxhole = max(holelen);
end

