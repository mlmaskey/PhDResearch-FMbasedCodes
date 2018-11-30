function dy = fm_model_91(p, ndata)

% This model puts together two leaves:
%
% p is input parameter vector defined between 0 and 1

dy1 = zeros(ndata, 1);
dy2 = zeros(ndata, 1);

x1_L = p(1)*p(3);
x2_L = p(2)*p(3);
x2_R = p(3) + p(8)*(1-p(3));
x3_R = p(3) + p(9)*(1-p(3));


% calls both left and right leaves first
p(9)=0.5;
p(14)=0.5;
p(15)=0.5;
%                x               y                d       p
p_left =  [x1_L x2_L p(3)  p(4) p(5)  p(6)   p(7)  p(8)  p(9)]; % as in a left leaf
p_right = [p(3) x2_R x3_R  p(6) p(10) p(11)  p(12) p(13) p(14)]; % as in a right leaf
w_weight = p(15);

if p_left(1) == 0 || p_left(2) == p_left(3) || p_right(1) == p_right(2) || p_right(3) == 1
	dy = ones(ndata,1);
	dy = dy/sum(dy);
	dy = dy';
	return
end

% compute the two leaves

y_left = leaf_core_L(p_left);
y_right = leaf_core_R(p_right);

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