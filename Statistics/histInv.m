function [p] = histInv(data, mindata, maxdata,nbins, locExtreme)
% function [p] = histInv(data, nbins, locExtreme)
% Computes the area under certain percent of data
% Carrlos E Puente Mahesh Maskey 11/27/2014
% Modified 5/28/2015
%     mindata = min(data);
%     maxdata = max(data);
%     binrange = linspace(mindata, maxdata, nbins);
%     ll = histc(data,binrange);
    ll = myhist(data, mindata, maxdata, nbins);
    ll_normalized = ll/sum(ll)*100;
    ll_cum = cumsum(ll_normalized);
    i1 = floor(locExtreme);
    i2 = ceil(locExtreme);
    if i1 ==0
         p = ll_cum(1) + (ll_cum(2)-ll_cum(1))/locExtreme;
    else
         p = ll_cum(i1) + (ll_cum(i2)-ll_cum(i1))/(i2-i1)*(locExtreme-i1);
    end        
end