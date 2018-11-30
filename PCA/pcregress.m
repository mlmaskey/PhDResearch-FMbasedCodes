function [pls, pcr, rpc] = pcregress(X, Y, ncomp)
[n,p] = size(X);
[Xloadings,Yloadings,Xscores,Yscores,betaPLS, PLSPctVar] = plsregress(X,Y,ncomp);
yfitPLS = [ones(n,1) X]*betaPLS;
[PCALoadings,PCAScores,PCAVar] = pca(X,'Algorithm','eig');
betaPCR = regress(Y-mean(Y), PCAScores(:,1:ncomp));
betaPCR2 = PCALoadings(:,1:ncomp)*betaPCR;
betaPCR1 = [mean(Y) - mean(X)*betaPCR2; betaPCR2];
yfitPCR = [ones(n,1) X]*betaPCR1;
pls.Xloadings = Xloadings;
pls.Yloadings = Yloadings;
pls.Xscores   = Xscores;
pls.Yscores   = Yscores;
pls.betaPLS   = betaPLS;
pls.PLSPctVar = PLSPctVar;
pls.yfitPLS = yfitPLS;

pcr.PCALoadings = PCALoadings;
pcr.PCAScores = PCAScores;
pcr.PCAVar   = PCAVar;
pcr.betaPCR = betaPCR1;
pcr.yfitPCR = yfitPCR;
pcr.Xscores = PCAScores(:,1:ncomp);

rpc = regressPC(X, Y, ncomp, '');