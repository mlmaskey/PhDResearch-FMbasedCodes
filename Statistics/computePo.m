function [ Pob, po ] = computePo( data, dy, bandwidth )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    ndata = numel(data);
    x = data/max(data);
    y = dy/max(dy);  
    idU = y > x + bandwidth/200;
    idL = y < x - bandwidth/200;
    Pob = sum(idU) + sum(idL);
    po = Pob/ndata;
end

