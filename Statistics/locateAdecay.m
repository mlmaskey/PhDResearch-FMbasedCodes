function [ decay ] = locateAdecay( acor, val )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here
    idBelow = find(acor < val);
    if isempty(idBelow)
        decay = NaN;
    else
        decay = idBelow(1);
    end
    
end

