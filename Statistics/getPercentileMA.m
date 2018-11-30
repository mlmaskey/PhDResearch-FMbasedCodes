function [ valPercentData, idPercentData, valPercentdy, idPercentdy, ...
    params] = getPercentileMA( prgm, Nyears,best, ndays, tau, dtype)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[ nparam ] = FMvariants_cont( prgm );
expr   = ['dy = fm_model_' int2str(prgm) ,'(p,ndata);'];
N = Nyears -tau+1;
params = zeros(N, nparam);
percent = 1:100;
valPercentData = zeros(N, length(percent));
idPercentData  = zeros(N, length(percent));
valPercentdy = zeros(N, length(percent));
idPercentdy    = zeros(N, length(percent));
series_name = '';
for i = 1:Nyears
    [~, RName, ~, ~, FileOut] = drawer(i, prgm, series_name);
    dataname{i,1} = RName;
end
baseflow = getmin(Nyears, prgm);
namecell = cellstr(dataname);
for i = 1:N
    series_name = [char(namecell(i)) '-' char(namecell(i+tau-1))];        
    [~, ~, Filein, FileOut] = drawer2(prgm, series_name, tau);
    [data] = setdata(Filein); data = data(:);
    R = load(Filein)+baseflow;        
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
