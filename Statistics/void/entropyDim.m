function obj = entropyDim(data)
Nr = 5;
delta = 1./(2.^(1:Nr));
lambda = 1./delta;
d     = log10(delta);
for r=1:Nr;
    W{r}= scaleData(data, lambda(r));
end

Nq = 100;
q  = linspace(-5,8,Nq);
dq = mean(diff(q));
A = zeros(Nq, Nr);
for r=1:Nr
    for j=1:Nq
        A(j,r)=sum(W{r}.^q(j));
    end
end
tau=[];
for j=1:Nq
    y=log10(A(j,:));
    [C,S]=polyfit(d,y,1);
    tau(j)=C(1);
end
alpha = -diff(tau)/dq;
funz = q(1:end-1).*alpha + tau(1:end-1);
[Z,I]=max(funz-alpha);
D1 = alpha(I);
obj.signal = data;
obj.entropy_dimension=D1;
obj.alpha=alpha;
obj.q=q; 
obj.funz=funz; 
end

