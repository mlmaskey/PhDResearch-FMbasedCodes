function [locExtreme] = histLoc(data, nbins, p)
% Computes the area under certain percent of data
% Carrlos E Puente Mahesh Maskey 10/09/2014
    mindata = min(data);
    maxdata = max(data);
    binrange = linspace(mindata, maxdata, nbins);
    ll = histc(data,binrange);
    ll_normalized = ll/sum(ll)*100;
    ll_cum = cumsum(ll_normalized);
for i = 1: nbins
        if ll_cum(i) < p && ll_cum(i+1)>p
            i1 = i;
            i2 = i+1;
             locExtreme = i1*1/nbins+ (p - ll_cum(i1))/(ll_cum(i2)-ll_cum(i1))*1/nbins;
        elseif ll_cum(1) > p 
            i1 = 0;
            i2 = 1;
            locExtreme = i1*1/nbins+ (p )/ll_cum(i2)*1/nbins;
        end
end 
end