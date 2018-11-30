function [ newData ] = adjustData( data, r)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
ndata = numel(data);
a = ndata/r;
b = floor(a);
if a == b
    newData = data;
elseif a < b+0.5
    b = b;
    nx = b*r
    nxe = ndata - nx;   
    if nxe == 1
        newData = data(1:end-1);
    else
        nL = floor(nxe/2);
        nr = nxe - nL;
        newData = data(nL:end-nr-1);
    end
else
    b = ceil(a);
    nx = b*r;
    nxe = nx - ndata;
    newData = [data; zeros(nxe,1)];   

end
end

