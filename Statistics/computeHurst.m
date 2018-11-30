function hurstExp = computeHurst(data)
cumdata = cumsum(data);
ndata = length(data);
perfectY = linspace(0,1,ndata);
perfectY = perfectY(:);
diff = cumdata - perfectY;
maxDiff = max(diff);
minDiff = abs(min(diff));
stdD = std(data);
range = abs(maxDiff-minDiff);
Exp = range/stdD;
hurstExp.positiveSide = max(diff);
hurstExp.negativeSide = min(diff);
hurstExp.range = range;
hurstExp.exp = Exp;
end
