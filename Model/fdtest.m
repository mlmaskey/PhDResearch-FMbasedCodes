a = [ 0.56 0.44];
d = [0.24 0.55];
% dsum = sum(d);
syms x positive;
LH = a(1)*abs(d(1))^(fd-1)+
x= double(vpasolve((sum(abs(d).*a.^(x-1))== 1),x));
if x<1
    x = 1;
end
if x>2
    x = 2;
end
fd = x;
Lsum = sum(abs(d).*a.^(fd-1));
if fd == NaN
    fd = 1;
end 
fd1 = max(1, fd);
xrest = [a d fd dsum Lsum fd1];    