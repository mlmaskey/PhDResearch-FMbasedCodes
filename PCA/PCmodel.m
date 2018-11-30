function [pp] = PCmodel(prgm, Nyears, best, Y, npk, method1, method2)
obj = FM_obj(prgm, Nyears, best);
param = cell2mat(obj.parray);
PC = regressPC(param, Y, npk, method1, method2);
y = PC.yhat;
Vd = zscore(Y);
Vm = zscore(y);
pp = figure(1);
subplot (1,3, [1 2]);
hold on
plot(1:Nyears, Vd, 'r');
plot(1:Nyears, Vm, 'b');
xlabel('Years');
ylabel('Nomalized value');
legend('Real', 'FMPC')
hold off;
title(['Principal component repreentation of ' int2str(npk) 'components']);
axis([1 Nyears min(min(Vd), min(Vm))*1.2 max(max(Vd), max(Vm))*1.2])
subplot(1, 3, 3);
plot(Vd, Vm, '*b');
xlabel('Normalized data');
ylabel('Normalized model');
title('PC- representation');
end

