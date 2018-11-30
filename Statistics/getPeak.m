function maxpk = getPeak(data_choice, Nyears, prgms, ndays, icases)
nsets = numel(prgms);
[~, ~, Filein, ~,~] = drawer(data_choice, prgms(1));
[data] = getdata(Filein, Nyears, prgms(1)); data = data(:);
ndata = numel(data);
dyset = zeros(ndata, nsets);
for i = 1:nsets
    prgm = prgms(i);
    [~, ~, ~, ~,FileOut] = drawer(data_choice, prgm);
    nparam  = FMvariants_cont( prgm );
    [p, itn] = paramget(FileOut, nparam, 4, icases);
    dy = getprojection(p, prgm, ndata);
    dy = stat_moving(dy, ndays);
    dyset(:,i) = dy;
end
dyset(:,nsets+1) = data;
maxpk = max(max(dyset));
end

function dy = getprojection(p, prgm, ndata)
p; ndata;
expr = ['dy = fm_model_' int2str(prgm) '(p, ndata);'];
eval(expr);
end