function [locExu, locExL] = locateExtreme(data, nbins, p)
xx = histc(data, linspace(min(data), max(data), 10));
xx_norm = xx/sum(xx)*100;
xx_accum = cumsum(xx_norm);
idLv = find(xx_accum<p);
idUv = find(xx_accum>p);
if isempty(idLv) == 1     
    idL = 0;
    Lv = 0;
else
    idL = idLv(end);
    idU = idUv(1);
    Lv = xx_accum(idL);
    Uv = xx_accum(idU);
end
locExu = Lv + (Uv-Lv)/(idU-idL)*(p-Lv)/nbins;
locExL = 100 - locExu;

end
