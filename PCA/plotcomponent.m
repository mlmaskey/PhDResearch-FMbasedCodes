function pp = plotcomponent(Nyears, Y, components, regresscase)
ncomponent = size(components,2);
pp = figure;
place(200, 0, 600, 600, 11,8.5)
x = 1:Nyears;
for i = 1:ncomponent
    subplot(ncomponent, 1, i)
    [hAx] = plotyy(x, Y, x,components(:,i));
    set(hAx(1), 'xlim', [1 Nyears]);
    set(hAx(2), 'xlim', [1 Nyears]);
    set(hAx(1),'FontSize', 10);
    set(hAx(2),'FontSize', 10);
    xlabel ('Years')
    ylabel(hAx(1),regresscase) % left y-axis
    ylabel(hAx(2),[int2str(i) '-th PC']) % right y-axis
end
end

