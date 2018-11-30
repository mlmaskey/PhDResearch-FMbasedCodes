function [ params, volume, Result ] = resultSummary( prgm, Nyears, Nyearsb, ndays, best, tau)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if tau == 0
    objData = getSet(Nyears, Nyearsb, prgm, ndays, best);
else
    objData = getSetMA(prgm, Nyears, Nyearsb, tau, ndays, best);
end
params = objData.params;
Result = objData.Result;
volume = objData.volume;

end

function objData = getSet(Nyears, Nyearsb, prgm, ndays, best)
expr = ['dy = fm_model_' int2str(prgm) ,'(p,ndata);'];
nparam  = FMvariants_cont( prgm );
params = zeros(Nyears, nparam);
Result = zeros(Nyears, 24);
Vol = zeros(Nyears, 1);
for i = 1:Nyears
    disp(['Evaluating the set: ' int2str(i)]);
    [~, ~, Filein, ~, FileOut] = drawer(i, prgm);
    [data, baseflow] = getdata(Filein, Nyearsb, prgm); data= data(:);
    objData.data{i} = data;
    dataR = load(Filein); dataR = dataR(:);
    objData.dataR{i} = dataR;    
    ndata = numel(data);
    [p, itn] = paramget(FileOut, nparam, 4, best);
    eval(expr);
    dy = stat_moving(dy, ndays); dy = dy(:);
    objData.dy{i} = dy;
    sumdata = sum(dataR - baseflow);
    dataP = dy*sumdata + baseflow;
    objData.dataP{i} = dataP;    
    params(i,:) = p;
    Vol(i) = sum(dataR);
    Result(i,:) = statsummary( data, dy, dataR, [-5 5 0.1]);
end
objData.params = params;
objData.Result = Result;
objData.volume = Vol;
end

function objData = getSetMA(prgm, Nyears, Nyearsb, tau, ndays, best)
expr = ['dy = fm_model_' int2str(prgm) ,'(p,ndata);'];
nparam  = FMvariants_cont( prgm );
Result = zeros(Nyears-tau+1, 24);
params = zeros(Nyears-tau+1, nparam);
Vol = zeros(Nyears-tau+1, 1);
series_name = '';
for i = 1:Nyears
    [~, RName, ~, ~, FileOut] = drawer(i, prgm, series_name);
    dataname{i,1} = RName;
end 
baseflow = getmin(Nyearsb, prgm);
namecell = cellstr(dataname);

for i = 1:Nyears-tau+1
    disp(['Evaluating the set: ' int2str(i)]);
    series_name = [char(namecell(i)) '-' char(namecell(i+tau-1))];        
    [~, ~, Filein, FileOut] = drawer2(prgm, series_name, tau);
    [data] = setdata(Filein); data= data(:);
    objData.data{i} = data;
    dataR = load(Filein)+ baseflow; dataR = dataR(:);
    objData.dataR{i} = dataR;    
    ndata = numel(data);
    [p, itn] = paramget(FileOut, nparam, 4, best);
    eval(expr);
    dy = stat_moving(dy, ndays); dy = dy(:);
    objData.dy{i} = dy;
    sumdata = sum(dataR - baseflow);
    dataP = dy*sumdata + baseflow;
    objData.dataP{i} = dataP;    
    params(i,:) = p;
    Vol(i) = sum(dataR);
    Result(i,:) = statsummary( data, dy, dataR, [-5 5 0.1]);
end
objData.params = params;
objData.Result = Result;
objData.volume = Vol;

end


function [ Result ] = statsummary( data, dy, dataR, q)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    llr = q(1);
    ulr = q(2);
    incr = q(3);
    ndata = length(data);
    nlag = floor(ndata/4);
    
    err_cuml	= norm(cumsum(dy) - cumsum(data))/sqrt(ndata); 
	
	err_data	= norm(dy - data)/sqrt(ndata); % not used in objective function

	max_cuml	= max(abs(cumsum(dy)-cumsum(data))); % max cumulative difference
		
    [rcor, rpsp] = stat_sw(data, nlag); % p.cor is correlation of dy
    [pcor, ppsp] = stat_sw(dy, nlag); % p.cor is correlation of dy
    error_corr = norm(rcor - pcor)/sqrt(nlag);
    decayR = locateAdecay(rcor,0);
    if isnan(decayR) == 1
        [rcor1, rpsp] = stat_sw(data, 2*nlag);
        decayR = locateAdecay(rcor1,0);
    end
    decayP = locateAdecay(pcor,0);
    if isnan(decayP) == 1
        [pcor1, ppsp] = stat_sw(dy, 2*nlag);
        decayP = locateAdecay(pcor1,0);
    end
    decayRe = locateAdecay(rcor,1/exp(1));
    decayPe = locateAdecay(pcor,1/exp(1));
    nsutdata = stat_nsee(data,dy);
    nsutcum = stat_nsee(cumsum(data),cumsum(dy));
    nsut3 = nsd_scale( data, dy, 3 );
    nsut7 = nsd_scale( data, dy, 7 );
    nsutCor = stat_nsee(pcor,rcor);
    R = corrcoef(data, dy);
    rhow = R(3);
    Rcum = corrcoef(cumsum(data), cumsum(dy));
    rhowcum = Rcum(3);
    mindata = min(dataR); 
    sumdata = sum(dataR-mindata);
    dyP = dy * sumdata + mindata ;        
    Iqr = entroRenyi(dataR,llr, ulr,incr);
    Iqp = entroRenyi( dyP, llr, ulr, incr );
    nEntro = numel(Iqr);    
    err_entro = norm(Iqp-Iqr)/sqrt(nEntro);
    nsutEntro = stat_nsee(Iqp,Iqr);
    hh = myhist(data, min(data), max(data), 10);
    ii = myhist(dy, min(data), max(data), 10); 
    diffhist= norm(hh-ii)/numel(sqrt(hh)); % difference in histogram
    nsuthist = stat_nsee(hh,ii);
    locExtreme90Lr = histLoc(data, 0, max(data), 10, 90);
    locExtreme90Lp = histLoc(dy, 0, max(data), 10, 90);
    err_shift_Ex = histInv(dy, 0, max(data), 10, locExtreme90Lr);    
    [~, p10] = computePo(data, dy, 20);
    [~, p20] = computePo(data, dy, 40);
    Result(1) = err_data; Result(2) = err_cuml; Result(3) = max_cuml;
    Result(4) = error_corr ; Result(5) = diffhist;
    Result(6) = decayR; Result(7) = decayP;
    Result(8) = decayRe; Result(9) = decayPe;
    Result(10) =  nsutdata; Result(11) = nsutcum;
    Result(12) =  nsutCor;  Result(13) = nsuthist;    
    Result(14) = nsut3; Result(15)= nsut7;
    Result(16) = rhowcum; Result(17) = rhow;              
    Result(18) = err_entro; Result(19) = nsutEntro;          
    Result(20) = locExtreme90Lr; Result(21) = locExtreme90Lp;         
    Result(22) = err_shift_Ex; % store key results
    Result(23) = p10; % store key results
    Result(24) = p20; % store key results
end



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
end

