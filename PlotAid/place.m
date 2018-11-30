function pp = place(x0, y0, bw, hw, l,w)
res = 8; % resolution (2^res)
set(gcf,'OuterPosition',[x0 y0 bw hw]);
set(gcf,'PaperUnits','inches');
set(gcf,'PaperPosition',[0 0 l,w]);
end