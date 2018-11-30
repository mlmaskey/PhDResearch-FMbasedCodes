function [ fDim ] = fractalDim( p, prgm, datatype )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
switch datatype
    case 'C'
        fracObj = coeffsFMCont(prgm, p);
    case 'c'
        fracObj = coeffsFMCont(prgm, p);
    case 'I'
        fracObj = coeffsFMInt(prgm, p);
    case 'i'
         fracObj = coeffsFMInt(prgm, p);
end
a = fracObj.a;
d = fracObj.d;
X = fzero(@(x) sum(abs(d).*a.^(x-1))-1,1) ;
fDim = max(X,1);
end

