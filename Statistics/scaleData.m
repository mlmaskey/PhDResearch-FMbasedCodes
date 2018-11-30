function [Y] = scaleData(data, q)
% computes the scale at lower resolution in the order of q
% Mahesh Maskey 06/05/2015
ndata = numel(data);
nq = ceil(ndata/q);
X = zeros(ndata, nq);
h = 1;
for i =1:q:numel(data)
    if h *q > numel(data)
        for k = i:ndata
            X(k,h) = data(k);
        end
    else
         for k = i:i+q-1
            X(k,h) = data(k);
        end
    end
    h=h+1;
end
Y = sum(X,1);
end
