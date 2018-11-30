function [pp] = leafInt(p, variant, ndata, figname)

expr = ['[x, y, dx, bx, dy, by, dyc] = ' variant '(p, ndata);'];
eval(expr)
nby = numel(dy);
cuty = zeros(nby,1);
cuty(:,1) = max(dy)*p(end);

subplot('Position', [0.05 0.40 0.40 0.55])
plot(x,y, '.k');
set(gca, 'XTick', []);
set(gca, 'YTick', []);
xlabel('x', 'Fontsize',16);
ylabel('y', 'Fontsize',16);    
axis([min(x) max(x) min(y) max(y)]);

by = linspace(0,max(y), ndata);
subplot('Position', [0.55 0.40 0.15 0.55])
hold on
plot(dy, by, '-k');
plot(cuty, by,'-k', 'linewidth', 1.0);
hold off;
set(gca, 'XTick', []);
set(gca, 'YTick', []); 
xlabel('dy', 'Fontsize',16);
ylabel('y', 'Fontsize',16);
axis([min(dy) max(dy) min(by) max(by)]);
box on;

subplot('Position', [0.05 0.10 0.40 0.20])
plot(bx, dx, '-k');
axis([min(bx) max(bx) min(dx) max(dx)]);
set(gca, 'XTick', []);
set(gca, 'YTick', []);  
xlabel('x', 'Fontsize',16);
ylabel('dx', 'Fontsize',16);

subplot('Position', [0.80 0.40 0.15 0.55])
plot(dyc, by, '-k');
set(gca, 'XTick', []);
set(gca, 'YTick', []);  
xlabel('dy1', 'Fontsize',16);
ylabel('y', 'Fontsize',16);    
axis([min(dyc) max(dyc) min(by) max(by)]);

if  isempty(figname)== 0
    imfile1 =[figname '_.png'];
    print(gcf, '-dpng', imfile1);
end

end