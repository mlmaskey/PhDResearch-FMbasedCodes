function [baseFlow] = getmin(Nyears, prgm)
mindata = zeros(Nyears, 1);
for i = 1:Nyears
    [~, ~, Filein, ~, ~] = drawer(i, prgm, '');
    data = load(Filein);
    mindata(i,1) = min(data);
end
baseFlow = min(mindata);

end