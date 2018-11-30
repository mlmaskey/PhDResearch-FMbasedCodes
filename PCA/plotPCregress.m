function [ pp ] = plotPCregress(obj )
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here
Y = obj.Y;
Yhat = obj.yfit;
regresscase = obj.regresscase;
rsquaredPLS = obj.rsquaredPLS;
rsquaredPCR = obj.rsquaredPCR;
ncomp = obj.ncomp;
pp = figure;
place(800, 0, 1200, 600, 8,4)
subplot (1, 3, [1, 2]);
hold on
plot(Y, 'k');
plot(Yhat(:,1), 'b');
plot(Yhat(:,2), 'r');
hold off
xlabel('Years');
ylabel(regresscase);
legend({'Observed' ['PLSR R^2 = ' num2str(rsquaredPLS*100,2) '%'] ...
    ['PCR R^2 = ' num2str(rsquaredPCR*100,2) '%']},'location','NE');
set(gca,'FontSize', 10);
box on

ylabel('Dependent Variable');
subplot (1,3, 3);
plot(Y,Yhat(:,1),'bo',Y,Yhat(:,2),'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
legend({'PLSR' 'PCR '}, 'location','NW');
hold on
set(gca,'FontSize', 10);

end

