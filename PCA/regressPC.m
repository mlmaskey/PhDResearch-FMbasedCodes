function [ final] = regressPC(X, Y, ncomp, method)
% Regress the model based on PCA
% 
[n, p] = size(X);
switch method 
    case 'z'
        Ystand = zscore(Y);
    case 'Z'
         Ystand = zscore(Y);
    case ''
        Ystand = Y;
end
[ PCAtake, PCAvar, PCparam, idPC,PCAScores, EigVP] = pcscores(X, ncomp);
muX = mean(X);
muY = mean(Ystand);
PCAScores1 = PCAScores(:, idPC);
V1 = EigVP(:, idPC);
beta = regress(Y-muY, PCAScores1);
beta2 = V1*beta;
beta1 = [muY - muX*beta2; beta2];
yhat = [ones(n,1) X]*beta1;

final.PCAScores = PCAScores;
final.eigV = EigVP;
final.state = PCAtake;
final.yhat = yhat;
final.PCparam = PCparam;
final.PCAvar = PCAvar;
final.XScores =  PCAScores(:, idPC);



end

