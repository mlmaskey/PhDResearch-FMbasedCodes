function dy = fm_model_8(p, ndata)

% This model puts together two wires:
%
% p is input parameter vector defined between 0 and 1

dy1 = zeros(ndata, 1);
dy2 = zeros(ndata, 1);

% calls both left and right wires first

x_L = p(1)*p(2);
x_R = p(2)+p(8)*(1-p(2));
y_L = p(3)*p(4);
y_R = p(3)+p(9)*(1-p(3));
p_left =  [x_L  p(2) y_L  p(4)  p(5)  p(6)   p(7)]; % as in a left wire
p_right = [p(2) x_R  p(4) y_R   p(10) p(11)  p(12)]; % as in a right wire
w_weight = p(13);

% compute the two wires

y_left = wire_core_L(p_left);
y_right = wire_core_R(p_right);

% now weigh the two projections

y_min = min(min(y_left),min(y_right));
y_max = max(max(y_left),max(y_right));

bin_size = (y_max - y_min)/ndata;
y_hist_set = y_min:bin_size:y_max;

%------------------------------------------------------

dy_left = histc(y_left,y_hist_set); % histogram left

for i = 1: ndata
	dy1(i) = dy_left(i);
end

if(length(dy_left) > ndata)
	dy1(ndata) = dy1(ndata) + dy_left(ndata + 1);
end

dy1 = dy1/sum(dy1);

%------------------------------------------------------

dy_right = histc(y_right,y_hist_set); % histogram right

for i = 1: ndata
	dy2(i) = dy_right(i);
end

if(length(dy_right) > ndata)
	dy2(ndata) = dy2(ndata) + dy_right(ndata + 1);
end

dy2 = dy2/sum(dy2);

%------------------------------------------------------

dy = w_weight*dy1 + (1-w_weight)*dy2; % combination
dy = dy';

return