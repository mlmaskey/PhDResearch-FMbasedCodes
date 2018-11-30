function dy = fm_model_3(p, ndata)

% This model uses two whole affine maps
% p is input parameter vector defined between 0 and 1

nbins = ndata;
ndots = 2^14;

M = 5; % y in [-5,5]
D = 1; % d in [-1,1]

xs = [0 p(1) p(2) 1];
ys = [0 M*(2*p(3)-1) M*(2*p(4)-1) 1];
a =  [p(5) p(6)];
d  = [D*(2*p(7)-1) D*(2*p(8)-1)];
ps = [0 p(9) 1];

b = [xs(2) - a(1) 1 - xs(3) - a(2)];
c = [ys(2) - d(1) 1 - ys(3) - d(2)];
e = [0 xs(3)];
f = [0 ys(3)];

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
	xnew   = a(k)*xold + b(k)*yold + e(k);
	ynew   = c(k)*xold + d(k)*yold + f(k);
	xold   = xnew;
	yold   = ynew;
	y(i+1) = ynew;
end

dy = hist(y, nbins);

dy = dy/sum(dy);

return