function [x, y, dx, bx, dy, by, dyh, dyv, fmobj]  = FMCantor2uy(p,ndata) 
% fm_model_4 is the function to leaf with holes
% taking into account of threshold at layers of dx

nbins = ndata;
ndots = 2^14;

M = 5; % y in [-5,5]
D = 1; % d in [-1,1]

xs = [0 p(1:2) 1];
ys = [0 M*(2*p(3:5)-1)];
d  =  D*(2*p(6:7)-1);
ps = [0 p(8) 1];

h = xs(end)-xs(1);
a =(xs(2:2:end)-xs(1:2:end-1))/h;
e = xs(1:2:end-1)-xs(1)*a;
c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
f = ys(1:2:end-1)-d*ys(1)-c*xs(1);

W = zeros(ndots,1);

shad_prob_static14 % stored 2^14 random values

for k=1:(length(ps)-1)
    W = W + and(prob<ps(k+1),prob>ps(k))*k;
end
kfun = sum(W,2);
x	 = zeros(ndots,1);
y    = zeros(ndots,1);
xold = xs(2);
yold = ys(2);
x(1) = xold;
y(1) = yold;
for i=1:ndots-1
	k      = max(min(kfun(i),numel(a)),1);
	xnew   = a(k)*xold + e(k);
	ynew   = c(k)*xold + d(k)*yold + f(k);
	xold   = xnew;
	yold   = ynew;
	x(i+1) = xnew;
	y(i+1) = ynew;
end

[dx, bx] = hist(x, nbins);
delta_dx = mean(diff(bx));
dy = hist(y, nbins);
dy = dy/sum(dy);
by = linspace(min(y), max(y), nbins);
% The following is a trick in order to deal with data sets with holes

% It takes only values of y whose x's are above a threshold on dx

% It requires an extra parameter p(end)

threshold = p(9)*max(dx)*0.25;

level_set = find(dx > threshold);

Y = [];
for j=1:length(level_set)
	i = level_set(j);
    ind = (x > (bx(i)-delta_dx/2) & x < (bx(i)+delta_dx/2));
    Y = [Y ; y(ind)];
end
ymin = min(y);
ymax = max(y);
step = (ymax - ymin)/(nbins - 1);
scale_hist = ymin:step:ymax;
nhist = length(scale_hist);

if nhist ~= nbins
    scale_hist = linspace(ymin, ymax, nbins);
end 

dyh = zeros(nbins,1);
dyh = histc(Y,scale_hist);

dy1 = zeros(nbins,1);
dy1 = histc(Y,scale_hist);
if sum(dy1)>0
	dy1 = dy1/sum(dy1);
    dy1 = dy1(:);
else
	dy1 = ones(nbins,1)/nbins;
    dy1 = dy1(:);
end
dyh=dy1(:);

dyv = dy - max(dy)*p(10);

dyv = max(dyv,0);

if sum(dyv)>0
	dyv = dyv/sum(dyv);
else
	dyv = zeros(1,nbins);
	dyv(1,:) = 1./nbins;
end
fmobj.xs = xs;
fmobj.ys = ys;
fmobj.d = d;
fmobj.ps = ps;
fmobj.h = h;
fmobj.a = a;
fmobj.e = e;
fmobj.c = c;
fmobj.f = f;
return