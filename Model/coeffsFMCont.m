function [fracObj] = coeffsFMCont(prgm, p)
M = 5; % y in [-5,5]
D = 1; % d in [-1,1]
switch prgm
    case 1
        xs = [0 p(1) 1];
        ys = [0 M*(2*p(2)-1) 1];
        d  = D*(2*p(3:4)-1);
        h = xs(end)-xs(1);
        a =(xs(2:end)-xs(1:end-1))/h;
        e = xs(1:end-1)-xs(1)*a;
        c =(ys(2:end)-ys(1:end-1)-d*(ys(end) - ys(1)))/h;
        f = ys(1:end-1)-d*ys(1)-c*xs(1);
    case 13
        xs = [0 p(1:2) 1];
        ys = [0 M*(2*p(3:4)-1) 1];
        d  = D*(2*p(5:7)-1);
        h = xs(end)-xs(1);
        a =(xs(2:end)-xs(1:end-1))/h;
        e = xs(1:end-1)-xs(1)*a;
        c =(ys(2:end)-ys(1:end-1)-d*(ys(end) - ys(1)))/h;
        f = ys(1:end-1)-d*ys(1)-c*xs(1);        
    case 2
        xs = [0 p(1:2) 1];
        ys = [0 M*(2*p(3:4)-1) 1];
        d  = D*(2*p(5:6)-1);
        h = xs(end)-xs(1);
        a =(xs(2:2:end)-xs(1:2:end-1))/h;
        e = xs(1:2:end-1)-xs(1)*a;
        c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
        f = ys(1:2:end-1)-d*ys(1)-c*xs(1);
    case 4
        p_north = [p(1) p(2) p(3) p(4) p(5)]; % as in a generic wire
        p_south = [p(1) p(6) p(7) p(8) p(5)]; % p(1) and p(5) are fixed
        fracobj1 = coeffsFMCont(1, p_north);
        fracobj2 = coeffsFMCont(1, p_south);     
        xs = [fracobj1.xs fracobj2.xs];
        ys = [fracobj1.ys fracobj2.ys];
        h = [fracobj1.h fracobj2.h];
        fracObj.d1 = [fracobj1.d fracobj2.d];
        fracObj.a1 = [fracobj1.a fracobj2.a];
        d = (fracobj1.d + fracobj2.d)/2;
        a = (fracobj1.a + fracobj2.a)/2;
        e = [fracobj1.e fracobj2.e];
        c = [fracobj1.c fracobj2.c];
        f = [fracobj1.f fracobj2.f]; 
    case 5
        p_north = [p(1) p(2) p(3) p(4) p(5)  p(6)   p(7)]; % as in a generic leaf
        p_south = [p(1) p(2) p(8) p(9) p(10) p(11)  p(7)]; % p(1), p(2) and p(7) are fixed
        fracobj1 = coeffsFMCont(2, p_north);
        fracobj2 = coeffsFMCont(2, p_south);     
        xs = [fracobj1.xs fracobj2.xs];
        ys = [fracobj1.ys fracobj2.ys];
        h = [fracobj1.h fracobj2.h];
        fracObj.d1 = [fracobj1.d fracobj2.d];
        fracObj.a1 = [fracobj1.a fracobj2.a];
        d = (fracobj1.d + fracobj2.d)/2;
        a = (fracobj1.a + fracobj2.a)/2;
        e = [fracobj1.e fracobj2.e];
        c = [fracobj1.c fracobj2.c];
        f = [fracobj1.f fracobj2.f];      
    case 23
        xs = [0 p(1:4) 1];
        ys = [0 M*(2*p(5:8)-1) 1];
        d  =  D*(2*p(9:11)-1);
        h = xs(end)-xs(1);
        a =(xs(2:2:end)-xs(1:2:end-1))/h;
        e = xs(1:2:end-1)-xs(1)*a;
        c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
        f = ys(1:2:end-1)-d*ys(1)-c*xs(1);
    case 131
        xs = [0 p(1:2) 1];
        ys = [0 M*(2*p(3:4)-1) 1];
        d  =  D*(2*p(5:7)-1);
        h = xs(end)-xs(1);
        a =(xs(2:end)-xs(1:end-1))/h;
        e = xs(1:end-1)-xs(1)*a;
        c =(ys(2:end)-ys(1:end-1)-d*(ys(end) - ys(1)))/h;
        f = ys(1:end-1)-d*ys(1)-c*xs(1);  
    case 231
        xs = [0 p(1:4) 1];
        ys = [0 M*(2*p(5:8)-1) 1];
        d  =  D*(2*p(9:11)-1);
        h = xs(end)-xs(1);
        a =(xs(2:2:end)-xs(1:2:end-1))/h;
        e = xs(1:2:end-1)-xs(1)*a;
        c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
        f = ys(1:2:end-1)-d*ys(1)-c*xs(1);      
end
    fracObj.d = d;
    fracObj.h = h;
    fracObj.xs = xs;
    fracObj.ys = ys;
    fracObj.a = a;
    fracObj.e = e;
    fracObj.c = c;
    fracObj.f = f;   
end