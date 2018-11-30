function [ idtake, totvar, statetake ] = filterstate(states, fractionVar,...
    npk)
% Filters the parameter based on the number of parameters to keep i.e.
% npreduce
%   Detailed explanation goes here
ssum = sum(states,2);
idcheckstate  = find(ssum == npk);
X = fractionVar(idcheckstate);
[totvar, idmax] = max(X);
idtake = idcheckstate(idmax);
statetake = states(idtake, :);
return

