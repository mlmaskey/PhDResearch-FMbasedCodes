function [ VolR, VolP, params] = getVolume( prgm, Nyears,Nyears2, best, ndays, dtype)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if Nyears2 ~= Nyears
    Nyearsb = Nyears2;
else
    Nyearsb = Nyears;
end
[ nparam ] = FMvariants_cont( prgm );
expr   = ['dy = fm_model_' int2str(prgm) ,'(p,ndata);'];
VolR   = zeros(Nyears, 1);
VolP   = zeros(Nyears, 1);
params = zeros(Nyears, nparam);

for i = 1:Nyears
    [~, RName, Filein, ~, FileOut] = drawer(i, prgm);
    disp(['Evaluating the set: ' RName])
    R = load(Filein); 
    [data, baseflow] = getdata(Filein, Nyearsb, prgm); 
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

