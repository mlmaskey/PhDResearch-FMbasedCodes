function [ Y, idpks ] = matchpeak( X, npks )
%This routines computes the location of several peaks
% as user wants how many peaks
X1 = sort(X, 'descend');
Y = zeros(npks,1);
idpks = zeros(npks,1);
for i = 1:npks
    idpk = find(X == X1(i));
    if numel(idpk) == 1
        Y(i,1) = X(idpk);
        idpks(i,1) = idpk;
    else
        idpkm = min(idpk);
        Y(i,1) = X(idpkm);
        idpks(i,1) = idpkm;
    end
end
end

