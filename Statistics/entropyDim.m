function obj = entropyDim(data)
Nr = 5;
delta = 1./(2.^(1:Nr));
d     = log10(delta);
for r=1:Nr;
    newData = adjustData(data,2^r);
    W{r}=sum(reshape(newData,size(newData,1)/2^r,2^r),2);
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

obj.D1=D1;
obj.q=q(1:end-1);
obj.tau=tau(1:end-1);
obj.alpha=alpha;
obj.funz=funz; 
end%Main routine

function [ newData ] = adjustData( data, r)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
ndata = numel(data);
a = ndata/r;
b = floor(a);
if a == b
    newData = data;
elseif a < b+0.5
    nx = b*r;
    nxe = ndata - nx;   
    if nxe == 1
        newData = data(1:end-1);
    else
        nL = floor(nxe/2);
        nr = nxe - nL;
        newData = data(nL:end-nr-1);
    end
else
    b = ceil(a);
    nx = b*r;
    nxe = nx - ndata;
    newData = [data; zeros(nxe,1)];   

end
end