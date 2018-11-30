function obj = entropy_dimension(obj)
data = obj.signal(:);

Nr = 5;
delta = 1./(2.^(1:Nr));
d     = log10(delta);
for r=1:Nr;
    W{r}=sum(reshape(data,size(data,1)/2^r,2^r),2);
end

Nq = 100;
q  = linspace(-5,8,Nq);
dq = mean(diff(q));
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

obj.entropy_dimension.D1=D1;
obj.entropy_dimension.alpha=alpha;
obj.entropy_dimension.funz=funz; 