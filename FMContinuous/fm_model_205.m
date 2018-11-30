function dy = fm_model_205(p,ndata)

% This model uses a "leaf" via overlaps of two maps
% p is input parameter vector defined between 0 and 1

nbins = ndata;
ndots = 2^14;

M = 5; % y in [-5,5]
D = 1; % d in [-1,1]

xs = [0 p(1) 1-p(1) 1];
ys = [0 M*(2*p(2)-1) M*(1-2*p(2)) 1];
d  = [D*(2*p(3)-1) D*(1-2*p(3))];
ps = [0 p(4) 1];

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
y    = zeros(ndots,1);
xold = xs(2);
yold = ys(2);
y(1) = yold;
for i=1:ndots-1
	k      = max(min(kfun(i),numel(a)),1);
	xnew   = a(k)*xold + e(k);
	ynew   = c(k)*xold + d(k)*yold + f(k);
	xold   = xnew;
	yold   = ynew;
	y(i+1) = ynew;
end

dy = hist(y, nbins);

dy = dy/sum(dy);

return