function [Iq, q] = entroRenyi( X, LL, UL, inc )
% UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    X = X(find(X~=0));
    pi = X/sum(X);
    q =  LL:inc:UL; q = q(:);
    nq = length(q);
    for i = 1:nq
        if q(i) == 1
            Xq = pi.*log(pi);
            Xqsum = sum(double(Xq));
            Iq(i) = -Xqsum;
        else
            Xq = pi.^q(i);
            Xqsum = sum(double(Xq));
            Iq(i) = 1/(1-q(i))*log(Xqsum);
            
        end
    end
    Iq = Iq(:);
    Iq = double(Iq);

end
