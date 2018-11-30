function [affine] = leafInt1(p, variant, ndata, figname)

expr = ['[x, y, dx, bx, dy, by, dyh, dyv, fmobj] = ' variant '(p, ndata);'];
eval(expr)
nbx = numel(bx);
cutx = zeros(nbx,1);
cutx(:,1) = max(dx)*p(8)*0.25; 

xs = fmobj.xs;
ys = fmobj.ys;
d = fmobj.d;
ps = fmobj.ps;
h = fmobj.h;
a = fmobj.a;
e = fmobj.e;
c = fmobj.c;
f = fmobj.f;
xp = xs;
yp = ys;
nmatrix = numel(a);
for i = 1:nmatrix
    affine.matrix{i}= [a(i) 0; c(i) d(i)];
    affine.linearTerm{i} = [e(i); f(i)];
    affine.xp = xp;
    affine.yp = yp;
end
affine.ps = ps;

nby = numel(dy);
cuty = zeros(nby,1);
cuty(:,1) = max(dy)*p(9);

subplot('Position', [0.05 0.40 0.25 0.20])
hold on;
plot(x,y, '.k');
plot(xp,yp, 'ok', 'MarkerSize',10);
hold off;
set(gca, 'XTick', []);
set(gca, 'YTick', []);
xlabel('x', 'Fontsize',16);
ylabel('y', 'Fontsize',16);    
axis([min(x) max(x) min(y) max(y)]);
box on

by = linspace(0,max(y), ndata);
subplot('Position', [0.35 0.40 0.15 0.20])
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

subplot('Position', [0.05 0.10 0.25 0.20])
hold on
plot(bx, dx, '-k');
plot(bx, cutx,'-k', 'linewidth', 1.0);
hold off
set(gca, 'XTick', []);
set(gca, 'YTick', []);  
xlabel('x', 'Fontsize',16);
ylabel('dx', 'Fontsize',16);
box on

subplot('Position', [0.55 0.40 0.15 0.20])
plot(dyh, by, '-k');
set(gca, 'XTick', []);
set(gca, 'YTick', []);  
xlabel('dy_h', 'Fontsize',16);
ylabel('y', 'Fontsize',16);
axis([min(dyh) max(dyh) min(by) max(by)]);

subplot('Position', [0.75 0.40 0.15 0.20])
plot(dyv, by, '-k');
set(gca, 'XTick', []);
set(gca, 'YTick', []);  
xlabel('dy_v', 'Fontsize',16);
ylabel('y', 'Fontsize',16);
axis([min(dyv) max(dyv) min(by) max(by)]);

if  isempty(figname)== 0
    imfile1 =[figname '_.png'];
    print(gcf, '-dpng', imfile1);
end

end