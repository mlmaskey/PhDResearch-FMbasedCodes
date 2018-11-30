function [ p ] = denormparam( prgm, p )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
M = 2;
D = 1;
switch prgm
    case 1
        p(2) = M*(2*p(2)-1);
        p(3:4) = D*(2*p(2)-1);
    case 131
        p(3:4) = M*(2*p(3:4)-1);
        p(5:7) = D*(2*p(5:7)-1);        
    case 2
        p(3:4) = M*(2*p(3:4)-1);
        p(5:6) = D*(2*p(5:6)-1);         
    case 231
        p(5:8) = M*(2*p(5:8)-1);
        p(9:11) = D*(2*p(9:11)-1); 
end
end 

