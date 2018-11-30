function [ Result ] = statsumSimul( data, dy, datatype)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    ndata = length(data);
    nlag = floor(ndata/4);
    
    err_cuml	= norm(cumsum(dy) - cumsum(data))/sqrt(ndata); 
	
	err_data	= norm(dy - data)/sqrt(ndata); % not used in objective function

	max_cuml	= max(abs(cumsum(dy)-cumsum(data))); % max cumulative difference
	
 	
    [rcor, rpsp] = stat_sw(data, nlag); % p.cor is correlation of dy
    [pcor, ppsp] = stat_sw(dy, nlag); % p.cor is correlation of dy
    error_corr = norm(rcor - pcor)/sqrt(nlag);
    decayR = locateAdecay(rcor,0);
    decayP = locateAdecay(pcor,0);
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
        datazero = countzero(data);
        dyzero = countzero(dy);
        zero_percent = (datazero - dyzero)/datazero;
        %     zero_percent = dyzero/datazero;
        idatazero = data ==0;
        idyzero = dy==0;
        matchzero = idatazero ==1 & idyzero == 1;
        nmatch = sum(matchzero);
        pmatch = nmatch/datazero;
    end
    
    hh = histc(data,linspace(min(data), max(data), 10))/ndata;
	ii = histc(dy,linspace(min(dy), max(dy), 10))/ndata;       
    diffhist= norm(hh-ii); % difference in histogram
    nsuthist = stat_nsee(hh,ii);
    locExtreme90p = histLoc(dy, 10, 90);
    err_shift_Ex = histInv(data, 10, locExtreme90p*10);

    Result.err_data = err_data;
    Result.err_cuml = err_cuml;
    Result. max_cuml = max_cuml;
    Result.error_corr = error_corr ;
    Result.diffhist= diffhist;
    Result.decayR = decayP;
    Result.decayRe = decayRe;
    Result.nsutdata =  nsutdata;
    Result.nsutCor =  nsutCor;
    Result.nsuthist = nsuthist;
    Result.nsutcum = nsutcum;
    Result.nsut3 = nsut3;
    Result.nsut7 = nsut7;
    Result.rhowcum = rhowcum;
    Result.rhow = rhow;          
    Result.err_shift_Ex = err_shift_Ex; % store key results
    if or(datatype == 'i', datatype == 'I');
        Result.datazero = datazero;
        Result.dyzero = dyzero;
        Result.zero_percent = zero_percent;
        Result.nmatch = nmatch;
        Result.pmatch = pmatch;
    end
end

