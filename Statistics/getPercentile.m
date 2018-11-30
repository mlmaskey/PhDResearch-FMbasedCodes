function [ valPercentData, idPercentData, valPercentdy, idPercentdy, ...
    params] = getPercentile( prgm, Nyears,best, ndays, dtype)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[ nparam ] = FMvariants_cont( prgm );
expr   = ['dy = fm_model_' int2str(prgm) ,'(p,ndata);'];
params = zeros(Nyears, nparam);
percent = 1:100;
valPercentData = zeros(Nyears, length(percent));
idPercentData  = zeros(Nyears, length(percent));
valPercentdy = zeros(Nyears, length(percent));
idPercentdy    = zeros(Nyears, length(percent));

for i = 1:Nyears
    [~, ~, Filein, ~, FileOut] = drawer(i, prgm);
    R = load(Filein);        
    [data, baseflow] = getdata(Filein, Nyears, prgm); data = data(:);
    Rnobase = R - baseflow;
    VolRnoBase = sum(Rnobase);
    ndata = length(data);
    p = getparam(FileOut,4,best);
    params(i,:) = p;
    eval(expr);
    dy = stat_moving(dy, ndays);dy = dy(:);
    switch dtype
        case 'Normalize'
            P = dy * VolRnoBase;
            [valPercentData(i,:), idPercentData(i,:), ...
                valPercentdy(i,:), idPercentdy(i,:)] =...
                getPercent(Rnobase,P, percent);
        case 'Denormalize'
            P = dy * VolRnoBase + baseflow;
            [valPercentData(i,:), idPercentData(i,:), ...
                valPercentdy(i,:), idPercentdy(i,:)] =...
                getPercent(R,P, percent); 
    end     
end
end

function [valPercentX, idPercentX, valPercentY, idPercentY] = ...
    getPercent(X, Y, percent)
    valPercentX = zeros(1, length(percent));
    idPercentX  = zeros(1, length(percent));
    valPercentY = zeros(1, length(percent));
    idPercentY  = zeros(1, length(percent));
    Xnorm = X/sum(X);
    Ynorm = Y/sum(Y);
    for k = 1:length(percent)
        [valPercentX(1, k), idPercentX(1,k)] = percentile(Xnorm,percent(k));
        [valPercentY(1,k), idPercentY(1,k) ] = percentile(Ynorm,percent(k));
    end  
    valPercentX = valPercentX.*sum(X);
    valPercentY = valPercentY.*sum(Y);
end
