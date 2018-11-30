function [ VolR, VolP, params] = getVolumeMA( prgm, Nyears, Nyears2, best, ndays, tau, dtype)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if Nyears2 ~= Nyears
    Nyearsb = Nyears2;
else
    Nyearsb = Nyears;
end
[ nparam ] = FMvariants_cont( prgm );
expr   = ['dy = fm_model_' int2str(prgm) ,'(p,ndata);'];
N = Nyears -tau+1;
VolR   = zeros(N, 1);
VolP   = zeros(N, 1);
params = zeros(N, nparam);
series_name = '';
for i = 1:Nyears
    [~, RName, ~, ~, FileOut] = drawer(i, prgm, series_name);
    dataname{i,1} = RName;
end 
namecell = cellstr(dataname);
for i = 1:N
    series_name = [char(namecell(i)) '-' char(namecell(i+tau-1))];  
    disp(['Evaluating the set: ' series_name])
    [~, ~, Filein, FileOut] = drawer2(prgm, series_name, tau);
    [data, baseflow] = getdata(Filein, Nyearsb, prgm); 
    R = load(Filein)+baseflow;        
    Rnobase = R - baseflow;
    VolRnoBase = sum(Rnobase);
    ndata = length(data);
    p = getparam(FileOut,4,best);
    params(i,:) = p;
    eval(expr);
    dy = stat_moving(dy, ndays);
    switch dtype
        case 'Normalize'
            P = dy * VolRnoBase;
            VolR(i,1) = VolRnoBase;
            VolP(i,1) = sum(P); 
        case 'Denormalize'
            P = dy * VolRnoBase + baseflow;
            VolR(i,1) = sum(R);
            VolP(i,1) = sum(P);    
    end 
    
end


end

