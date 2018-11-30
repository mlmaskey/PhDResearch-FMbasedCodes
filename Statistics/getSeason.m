function [ valMonth, cumMonth, valSeason, cumSeason ] = getSeason( X )
%Distribute the mass monthly and seasonally over a year
%   Mahesh Maskey 6/19/2015
ndata = numel(X);
if ndata == 366
    monthdays = [31 30 31 31 29 31 30 31 30 31 31 30];
else
    monthdays = [31 30 31 31 28 31 30 31 30 31 31 30];
end
cmonthdays = cumsum(monthdays);
nmonth = numel(monthdays);
valMonth = zeros (nmonth,1);
k = 1;
for i = 1:nmonth
    Y = X(k:cmonthdays(i));
    valMonth(i,1) = sum(Y);
    k = cmonthdays(i)+1;
end
cumMonth = cumsum(valMonth);
cseasondays = cmonthdays(3:3:nmonth);
Xcum = cumsum(X);
nSeason = 4;
valSeason = zeros (nSeason,1);
cumSeason = zeros (nSeason,1);
k = 1;
for j = 1:nSeason
    y = valMonth(k:k+2);
    valSeason(j,1) = sum(y);
    k = k + 3;
    cumSeason(j,1) = Xcum(cseasondays(j));
end
end

