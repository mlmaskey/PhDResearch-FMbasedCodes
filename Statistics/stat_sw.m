function [cor, spden] = stat_sw(data, nlag)
ndata = length(data);
dmean = mean(data);
dvar = var(data);

k = 0;
cor = zeros(1,nlag);
for lag=1:nlag
	ndata1 = ndata - lag;
	dcor = 0;
	for n=1:ndata1
		dcor = dcor + (data(n)-dmean)*(data(n+lag)-dmean);
	end
	k = k+1;
	cor(k) = dcor/(ndata*dvar);
end

spden = stat_period(cor);
return