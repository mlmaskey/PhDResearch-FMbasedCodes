function locExtreme = locateExtereme(data, binrange, p)
     nbins = numel(binrange);
    ll = histc(data, binrange);
    cdf = cumsum(ll); % Sum histogram counts to get cumulative distribution function.
    cdf = cdf / cdf(end); % Normalize.
    % Get data value where p% is.
    id1 = find(cdf<= p/100, 1, 'last')
    id2 = find(cdf>= p/100, 1, 'first')
    locExtreme = id1+ (p/100 - cdf(id1))/(cdf(id2)-cdf(id1));
end