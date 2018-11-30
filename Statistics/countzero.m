function [nzero] = countzero(data)
    idzero = find(data==0);
    nzero = length(idzero);
end