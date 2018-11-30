function [cumSet] = partialcum(X, n)
    ndata = numel(X);
    npts = getpnts(ndata, n);
    idPos =npts:npts:npts*n;
    cumX = cumsum(X);
    cumSet = cumX(idPos); 
end

function npts = getpnts(ndata, n)
    val = ndata/(n+1);
    valInt = floor(val);
    dif = val-valInt;
    if dif <= 0.5
        npts = valInt;
    else
        npts = valInt + 1;
    end    
end