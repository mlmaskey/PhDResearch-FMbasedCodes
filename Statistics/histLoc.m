function [locEx] = histLoc(data, mindata, maxdata, nbins, p)
% function [locEx] = histLoc(data, nbins, p)
% function [locExu, locExL] = histLoc(data, nbins, p)
% xx = histc(data, linspace(min(data), max(data), nbins));
xx = myhist(data, mindata, maxdata, nbins);
xx_norm = xx/sum(xx)*100;
xx_accum = cumsum(xx_norm);
idLv = find(xx_accum<p);
idUv = find(xx_accum>p);
if isempty(idLv) == 1     
    idL = 0;
    idU = idL+1;
    Lv = 0;
    Uv = xx_accum(idU);
else
    idL = idLv(end);
    idU = idUv(1);
    Lv = xx_accum(idL);
    Uv = xx_accum(idU);
end
% locExu = Lv + (Uv-Lv)/(idU-idL)*(p-Lv)/nbins;
% locExL = 100 - locExu;
% locEx = idL + (idU-idL)/(Uv-Lv)*(p-Lv)/nbins;
locEx = idL + (idU-idL)/(Uv-Lv)*(p-Lv);

end
