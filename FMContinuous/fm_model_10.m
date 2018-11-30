function dy = fm_model_10(p, ndata)

% This model builds a semi-loop of two wires:
%
% p is input parameter vector defined between 0 and 1

dy1 = zeros(ndata, 1);
dy2 = zeros(ndata, 1);

x2_R = p(1) + p(6)*(1-p(1));

% calls both north and south wires first
%            x    y       d        p
p_north =  [p(1) p(2)  p(3) p(4)  p(5)]; % as in a generic wire
%               x          y          d      p
p_south =  [p(1) x2_R  p(2) p(7)  p(8) p(9) p(10)]; % as in a right wire
w_weight = p(11);

if p_south(1) == p_south(2) || p_south(2) == 1
	dy = ones(ndata,1);
	dy = dy/sum(dy);
	dy = dy';
	return
end

% compute the two wires

y_north = wire_core(p_north);
y_south = wire_core_R(p_south);

% now weigh the two projections

y_min = min(min(y_north),min(y_south));
y_max = max(max(y_north),max(y_south));

bin_size = (y_max - y_min)/ndata;
y_hist_set = y_min:bin_size:y_max;

%------------------------------------------------------

dy_north = histc(y_north,y_hist_set); % histogram north

for i = 1: ndata
	dy1(i) = dy_north(i);
end

if(length(dy_north) > ndata)
	dy1(ndata) = dy1(ndata) + dy_north(ndata + 1);
end

dy1 = dy1/sum(dy1);

%------------------------------------------------------

dy_south = histc(y_south,y_hist_set); % histogram south

for i = 1: ndata
	dy2(i) = dy_south(i);
end

if(length(dy_south) > ndata)
	dy2(ndata) = dy2(ndata) + dy_south(ndata + 1);
end

dy2 = dy2/sum(dy2);

%------------------------------------------------------

dy = w_weight*dy1 + (1-w_weight)*dy2; % combination
dy = dy';

return