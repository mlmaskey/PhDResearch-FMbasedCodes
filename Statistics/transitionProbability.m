function transP = transitionProbability(data, X, Y)
data1 = data(1:end-1);
data2 = data(2:end);
state = size(numel(data)-1,1);
for i = 1:numel(data)-1
if data1(i)== X && data2(i) == Y
    state(i) = 1;
else 
    state(i) = 0;
end
end
transP = sum(state);
end

    
