function [ Result ] = statsummaryV1( data, baseflow, dataR, dy, q, datatype)
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
    if or(datatype == 'i', datatype == 'I')
        sumdata = sum(dataR);
        dyP = dy * sumdata; 
        holemax_data = holemax(data);
        holemax_dy = holemax(dy);
        hole_diff = holemax_data - holemax_dy;
        datazero = countzero(data);
        dyzero = countzero(dy);
        zero_percent = (datazero - dyzero)/datazero;
        %     zero_percent = dyzero/datazero;
        idatazero = data ==0;
        idyzero = dy==0;
        matchzero = idatazero ==1 & idyzero == 1;
        nmatch = sum(matchzero);
        pmatch = nmatch/datazero;
    else
       sumdata = sum(dataR-baseflow);
       dyP = dy * sumdata + baseflow ; 
    end
         
    [Iqr, ar] = entroRenyi(dataR,llr, ulr,incr);
    nEntro = numel(Iqr);    
    [Iqp, ap] = entroRenyi( dyP, llr, ulr, incr );
    err_entro = norm(Iqp-Iqr)/sqrt(nEntro);
    nsutEntro = stat_nsee(Iqp,Iqr);
     hh = myhist(data, min(data), max(data), 10);
    ii = myhist(dy, min(data), max(data), 10);
    diffhist= norm(hh-ii)/numel(sqrt(hh)); % difference in histogram
    nsuthist = stat_nsee(hh,ii);
    locExtreme90Lr = histLoc(data, min(data), max(data), 10, 90);
    locExtreme90Lp = histLoc(dy, min(data), max(data), 10, 90);
    err_shift_Ex = histInv(dy, 0, max(data), 10, locExtreme90Lr);    
        
    [~, p10] = computePo(data, dy, 20);
    
    [~, p20] = computePo(data, dy, 40);
    Result.err_data = err_data;
    Result.err_cuml = err_cuml;
    Result. max_cuml = max_cuml;
    Result.error_corr = error_corr ;
    Result.diffhist= diffhist;
    Result.decayR = decayR;
    Result.decayP = decayP;
    Result.decayRe = decayRe;
    Result.decayPe = decayPe;
    Result.nsutdata =  nsutdata;
    Result.nsutCor =  nsutCor;
    Result.nsuthist = nsuthist;
    Result.nsutcum = nsutcum;
    Result.nsut3 = nsut3;
    Result.nsut7 = nsut7;
    Result.rhowcum = rhowcum;
    Result.rhow = rhow;          
    Result.err_entro = err_entro;          
    Result.nsutEntro = nsutEntro;          
    Result.locExtreme90Lr = locExtreme90Lr;          
    Result.locExtreme90Lp = locExtreme90Lp;          
    Result.err_shift_Ex = err_shift_Ex; 
    Result.p10 = p10;
    Result.p20 = p20; % store key results
    if or(datatype == 'i', datatype == 'I');
        Result.datazero = datazero;
        Result.dyzero = dyzero;
        Result.zero_percent = zero_percent;
        Result.nmatch = nmatch;
        Result.pmatch = pmatch;
        Result.holemax_data = holemax_data;
        Result.holemax_dy = holemax_dy;        
        Result.hole_diff = hole_diff;        
    end
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