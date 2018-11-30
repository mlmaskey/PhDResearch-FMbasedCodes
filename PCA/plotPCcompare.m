function pp = plotPCcompare(Nyears, components1, components2, regresscase)
ncomponent = size(components1,2);
pp = figure;
place(200, 0, 600, 600, 11,8.5)
x = 1:Nyears;
for i = 1:ncomponent
    subplot(ncomponent, 1, i);
    hold on
    plot(x, components1(:,i), '-k');
    plot(x, components2(:,i), '-r');
    hold off;
    xlabel ('Years')
    ylabel(regresscase)
    title([int2str(i) '-th PC']) 
    box on
end
end

