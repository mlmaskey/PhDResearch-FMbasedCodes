function [fracObj] = coeffsFMInt(prgm, p)
M = 5; % y in [-5,5]
D = 1; % d in [-1,1]
switch prgm
    case {1, 301}
        xs = [0 p(1) 1];
        ys = [0 M*(2*p(2)-1) 1];
        d  = D*(2*p(3:4)-1);
        h = xs(end)-xs(1);
        a =(xs(2:end)-xs(1:end-1))/h;
        e = xs(1:end-1)-xs(1)*a;
        c =(ys(2:end)-ys(1:end-1)-d*(ys(end) - ys(1)))/h;
        f = ys(1:end-1)-d*ys(1)-c*xs(1);
    case {2, 401}
        xs = [0 p(1:2) 1];
        ys = [0 M*(2*p(3:4)-1) 1];
        d  = D*(2*p(5:6)-1);
        h = xs(end)-xs(1);
        a =(xs(2:2:end)-xs(1:2:end-1))/h;
        e = xs(1:2:end-1)-xs(1)*a;
        c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
        f = ys(1:2:end-1)-d*ys(1)-c*xs(1);
    case 23
        xs = [0 p(1:4) 1];
        ys = [0 M*(2*p(5:8)-1) 1];
        d  =  D*(2*p(9:11)-1);
        h = xs(end)-xs(1);
        a =(xs(2:2:end)-xs(1:2:end-1))/h;
        e = xs(1:2:end-1)-xs(1)*a;
        c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
        f = ys(1:2:end-1)-d*ys(1)-c*xs(1);
    case 4
        xs = [0 p(1:2) 1];
        ys = [0 M*(2*p(3:5)-1)];
        d  =  D*(2*p(6:7)-1);
        h = xs(end)-xs(1);
        a =(xs(2:2:end)-xs(1:2:end-1))/h;
        e = xs(1:2:end-1)-xs(1)*a;
        c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
        f = ys(1:2:end-1)-d*ys(1)-c*xs(1);
    case 31
        xs = [0 p(1) p(2) 1];
        ys = [0 M*(2*p(3:4)-1) 1];
        d  = D*(2*p(5:7)-1);
        h = xs(end)-xs(1);
        a =(xs(2:end)-xs(1:end-1))/h;
        e = xs(1:end-1)-xs(1)*a;
        c =(ys(2:end)-ys(1:end-1)-d*(ys(end) - ys(1)))/h;
        f = ys(1:end-1)-d*ys(1)-c*xs(1);        
    case 33
        xs = [0 p(1:2) 1];
        ys = [0 M*(2*p(3:5)-1)];
        d  =  2*D*p(6:8)-1;
        h = xs(end)-xs(1);
        a =(xs(2:end)-xs(1:end-1))/h;
        e = xs(1:end-1)-xs(1)*a;
        c =(ys(2:end)-ys(1:end-1)-d*(ys(end) - ys(1)))/h;
        f = ys(1:end-1)-d*ys(1)-c*xs(1);        
    case 41
        xs = [0 p(1:4) 1];
        ys = [0 M*(2*p(5:8)-1) 1];
        d  =  D*(2*p(9:11)-1);
        h = xs(end)-xs(1);
        a =(xs(2:2:end)-xs(1:2:end-1))/h;
        e = xs(1:2:end-1)-xs(1)*a;
        c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
        f = ys(1:2:end-1)-d*ys(1)-c*xs(1);     
    case 43
        xs = [0 p(1:4) 1];
        ys = [0 M*(2*p(5:9)-1)];
        d  =  D*(2*p(10:12)-1);
        h = xs(end)-xs(1);
        a =(xs(2:2:end)-xs(1:2:end-1))/h;
        e = xs(1:2:end-1)-xs(1)*a;
        c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
        f = ys(1:2:end-1)-d*ys(1)-c*xs(1);        
    case 63
        xs = [0 p(1:4) 1];
        ys = [0 M*(2*p(5:8)-1) 0];
        d  =  D*(2*p(9:11)-1);
        h = xs(end)-xs(1);        
        a =(xs(2:2:end)-xs(1:2:end-1))/h;
        e = xs(1:2:end-1)-xs(1)*a;
        c =(ys(2:2:end)-ys(1:2:end-1)-d*(ys(end)-ys(1)))/h;
        f = ys(1:2:end-1)-d*ys(1)-c*xs(1);
    case 83
        xs = [0 p(1:4) 1];
        ys = [0 M*(2*p(5:8)-1) M];
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