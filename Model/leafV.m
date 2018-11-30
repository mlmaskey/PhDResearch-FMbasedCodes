function [x, y, dx, bx, dy_o, by, dy]  = leafV(p,ndata) 
% fm_model_4 is the function to leaf with holes
% taking into account of threshold at layers of dx

nbins = ndata;
ndots = 2^14;


M = 5; % y in [-5,5]
D = 1; % d in [-1,1]

xs = [0 p(1:2) 1];
ys = [0 M*(2*(3:4)-1) 1];
d  =  D*(2*p(5:6)-1);
ps = [0 p(7) 1];

% validation required for more than 2 maps

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
dy_o = hist(y, nbins);
dy_o = dy_o/sum(dy_o);
by = linspace(min(y), max(y), nbins);
dy = dy_o - max(dy_o)*p(8);

dy = max(dy,0);

if sum(dy)>0
	dy = dy/sum(dy);
else
	dy = zeros(1,nbins);
	dy(1,:) = 1./nbins;
end

return