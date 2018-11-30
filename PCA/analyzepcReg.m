function [X, Y, Yfit, PLS, PCR, RPC] = analyzepcReg(X, Y, ncomp)
[PLS, PCR, RPC] = pcregress(X, Y, ncomp);
PLSPctVar = PLS.PLSPctVar;
% XPLSscores =  PLS.Xscores;
yfitPLS = PLS.yfitPLS;

% PCAScores = PCR.PCAScores;
PCAVar   = PCR.PCAVar;
yfitPCR = PCR.yfitPCR;
% XPCRscores =  PCR.XScores;

% XRPCscores =  RPC.XScores;
yfitRPC = RPC.yhat;

Yfit = [yfitPLS yfitPCR yfitRPC ];

% figure(1);
% plot3(XPLSscores(:,1),XPLSscores(:,2),Y-mean(Y),'bo');
% plot3(XPCRscores(:,1),XPCRscores(:,2),Y-mean(Y),'r^');
% hold off
% legend('PLSR', 'PCR');
% grid on; view(-30,30);

TSS = sum((Y-mean(Y)).^2);
RSS_PLS = sum((Y-yfitPLS).^2);
rsquaredPLS = 1 - RSS_PLS/TSS;
PLS.rsquaredPLS = rsquaredPLS;

RSS_PCR = sum((Y-yfitPCR).^2);
rsquaredPCR = 1 - RSS_PCR/TSS;
PCR.rsquaredPCR = rsquaredPCR;

RSS_RPC = sum((Y-yfitRPC).^2);
rsquaredRPC = 1 - RSS_RPC/TSS;
RPC.rsquaredRPC = rsquaredRPC;

% figure (2)
% plot(1:ncomp,100*cumsum(PLSPctVar(1,:)),'b-o',1:ncomp,  ...
% 	100*cumsum(PCAVar(1:ncomp))/sum(PCAVar(1:ncomp)),'r-^');
% xlabel('Number of Principal Components');
% ylabel('Percent Variance Explained in X');
% legend({'PLSR' 'PCR'},'location','SE');

figure(1)
subplot (1,3, [1,2]);
hold on
plot(Y,'-k');
plot(yfitPLS, '-b');
plot(yfitPCR,'-r');
plot(yfitRPC,'-g');
hold off
legend({'Observed' ['PLSR w/R^2 = ' num2str(rsquaredPLS*100,2) '%'] ...
    ['PCR w/R^2 = ' num2str(rsquaredPCR*100,2) '%']...
    ['RPC w/R^2 = ...' num2str(rsquaredRPC*100,2) '%']},'location','NE');
xlabel('Years');
ylabel('Dependent Variable');
subplot (1,3, 3);
plot(Y,yfitPLS,'bo',Y,yfitPCR,'r^');
xlabel('Observed Response');
ylabel('Fitted Response');
legend({['PLSR with' int2str(ncomp) ' Components']...
    ['PCR with' int2str(ncomp) ' Components']}, 'location','NW');
hold on

end