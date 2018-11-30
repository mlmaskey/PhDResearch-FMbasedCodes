function spden = stat_period(cor)

nlag = length(cor);

ndata = 2 * nlag;

m = nlag / 2;

nf = ndata / 2;

% spectral density
spden = zeros(1,ndata/2);

for iw=1:nf
	w = iw * 2 * pi / ndata;
	ff = 1;
	for k=1:m
		if k <= m/2
			xlamk = 1 - 6*(k/m)^2 + 6*(k/m)^3;
		else
			xlamk = 2 * (1 - k/m)^3;
		end
		ff = ff + 2 * xlamk * cor(k) * cos(w*k);
	end
	spden(iw) = ff/pi;
end

return