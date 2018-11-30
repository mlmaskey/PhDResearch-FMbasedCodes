function [fY, fyFM, paramsetYear, fD, fdFM, paramsetDecade, fP, fpFM, paramsetPentade]= cumPlotwClass(prgm, tau1, tau2, dir2Save)
workdir1 = 'Z:\Project\Runoff\Sacramento\ClassificationPredictionV3';
workdir2 = 'Z:\Project\Runoff\Sacramento\Fittings10012014';
workdir3 = 'Z:\Project\Runoff\Sacramento\MovingAverage01252015';
dir2Save = [dir2Save '\Class_' date];
mkdir(dir2Save);
switch prgm
    case 131
        obj.notes = 'Fractal wire with three maps';
    case 2
        obj.notes = 'Fractal leaf with two maps';
end
obj.River_Name = 'Sacramento River';
obj.RiverName = 'SacramentoRiver';
Nyears = 64;
Nyearsb = 60;
ndata = 365;
best = 1;
ndays = 5; 
obj.tau1 = tau1; obj.tau2 = tau2;
udClassY = 10;objYearly.udClass = udClassY;
udClassD = 10;objDecade.udClass = udClassD;
udClassP = 10;objPentade.udClass = udClassP;

cd(workdir2);
disp('Loading yearly set');
[ VolR, ~, params] = getVolume( prgm, Nyears,Nyearsb, best, ndays, 'Denormalize');
objYearly.paramsSet = params;objYearly.VolR = VolR;
objYearly.params = params;
cd(workdir1);
cd(workdir3);
disp('Loading Decadal set');
[ VolRMA10, ~, paramsMA10] = getVolumeMA( prgm, Nyears, Nyearsb,best, ndays, tau1, 'Denormalize');  
objDecade.paramsSet = paramsMA10;objDecade.VolR = VolRMA10;
objDecade.params = paramsMA10;
disp('Loading Pentadal set');
[ VolRMA5, ~, paramsMA5] = getVolumeMA( prgm, Nyears, Nyears,best, ndays, tau2, 'Denormalize');  
objPentade.paramsSet = paramsMA5;objPentade.VolR = VolRMA5;
objPentade.params = paramsMA5;
cd(workdir1);
objYearly  = getClass(objYearly);
idxDefault = objYearly.idx;centDefault = objYearly.cent;
[idx] = classTransform(idxDefault, centDefault);
objDecade  = getClass(objDecade);
idxMA10Default = objDecade.idx;centMA10Default = objDecade.cent;
[idxMA10] = classTransform(idxMA10Default, centMA10Default);
objPentade  = getClass(objPentade);
idxMA5Default = objPentade.idx;centMA5Default = objPentade.cent;
[idxMA5] = classTransform(idxMA5Default, centMA5Default);

cd(workdir2);
[fY, fyFM, paramsetYear] = compareSetscumwClass (prgm, Nyears, Nyearsb, ndays, ndata, best,idx);
cd(workdir3);
[fD, fdFM, paramsetDecade] = compareSetscumwClassMA (prgm, Nyears, tau1, ndays, ndata, best, idxMA10);
[fP, fpFM, paramsetPentade] = compareSetscumwClassMA (prgm, Nyears, tau2, ndays, ndata, best, idxMA5);
cd(workdir1);
fileOutd1 = [dir2Save '\YearlyDataCumulateivewClass_' int2str(prgm) '.png']; saveas(fY, fileOutd1);
fileOutf1 = [dir2Save '\YearlyfitCumulateivewClass_' int2str(prgm) '.png']; saveas(fyFM, fileOutf1);
fileOutd2 = [dir2Save '\DecadalDataCumulateivewClass_' int2str(prgm) '.png']; saveas(fD, fileOutd2);
fileOutf2 = [dir2Save '\DecadalFitCumulateivewClass_' int2str(prgm) '.png']; saveas(fdFM, fileOutf2);
fileOutd3 = [dir2Save '\PentadalDataCumulateivewClass_' int2str(prgm) '.png']; saveas(fP, fileOutd3);
fileOutf3 = [dir2Save '\PentadalFitCumulateivewClass_' int2str(prgm) '.png'];  saveas(fpFM, fileOutf3);
end

function [obj] = getClass(obj1)
params= obj1.params;udClass= obj1.udClass;
[idx,cent,sumdist, meansilh] =kclusterp(params, udClass);
obj1.idx = idx;obj1.cent = cent;
obj1.sumdist = sumdist;obj1.meansilh = meansilh;
nclass = zeros(udClass, 1);
for i = 1:udClass
    nclass(i,1) = numel(find(idx == i));
end
obj = obj1; obj.nclass = nclass;
close all;
end

function [idxnew, centNew] = classTransform(idx, cent)
udClass = size(cent,1);
N = size(idx,1);
minId = zeros(udClass,1);
idxnew = zeros(N,1);
for i = 1:udClass
    vecId = find(idx == i);
    minId(i,1) = min(vecId);
end
oldClass = 1:udClass; oldClass = oldClass(:);
newClass = 1:udClass; newClass = newClass(:);
set = [oldClass minId];
idClassNew = sortrows(set,2);
idClassNew = [idClassNew newClass];
for i = 1:udClass
    vecId = find(idx == idClassNew(i,1));
    idxnew(vecId) = idClassNew(i,3);
end
centNew = cent(idClassNew(:,1),:);
end

function [f1, f2, paramset] = compareSetscumwClass (prgm, Nyears, Nyearsb, ndays, ndata, best,classVec)
udClass = max(classVec);
nparams = numel(parameters(prgm));
paramset = zeros(Nyears, nparams);
dataSets = zeros(ndata, Nyears);
cumRSets = zeros(ndata, Nyears);
dySets = zeros(ndata, Nyears);
cumPSets = zeros(ndata, Nyears);
colors = jet(udClass);
for i = 1:Nyears
    disp(['Loading set:' int2str(i) ]);
    [~, ~, Filein, ~, FileOut] = drawer(i,prgm);
    data = getdata( Filein, Nyearsb,prgm); data=data(1:ndata);
    [p, itn] = getparam(FileOut, 4, best);
    dy = getProjection(prgm, p, ndata, ndays);
    paramset(i, :) = p;
    dataSets(:, i) = data(:);
    dySets(:, i) = dy(:);
    cumRSets(:, i) = cumsum(data(:));
    cumPSets(:, i) = cumsum(dy(:));
end

for i = 1:udClass
    Legend{i} = ['Class' int2str(i)];
end
X = cumRSets;
f1 = figure();place(50, 100, 1600, 1600, 10, 10)
h = zeros(Nyears,1);
hold on
for i = 1:Nyears
    idClass = classVec(i);
    h(i) = plot(X(:,i), 'color', colors(idClass,:));
    x = floor(ndata/2);
    y = 1 - (i-1)/Nyears;
    text(x, y, int2str(i), 'color', colors(idClass,:), 'VerticalAlignment', 'top',...
    'HorizontalAlignment','center','FontSize',8)    
end
hold off
axis([1 ndata 0 1]);
set(gca,'xTick',[1 ndata]);
title('Data', 'FontSize', 24);
set(gca, 'FontSize', 18);
set(gca, 'xlim', [1 ndata]);
set(gca, 'ylim', [0 1]);
set(gca,'TickLength',[0 0]);
set(gca,'LineWidth',1.0);
[~,idx] = unique(classVec);
legend(h(idx), Legend, 'Location', 'Southeast', 'Fontsize',12);
xlabel('day'); ylabh = ylabel('AQ', 'rotation', 0);
set(ylabh, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);
box on
clear h
clear idx

Y = cumPSets;
f2 = figure(); place(50, 100, 1600, 1600, 10, 10)
h = zeros(Nyears,1);
hold on
for i = 1:Nyears
    idClass = classVec(i);
    h(i) = plot(Y(:,i), 'color', colors(idClass,:));
    x = floor(ndata/2);
    y = 1 - (i-1)/Nyears;
    text(x, y, int2str(i), 'color', colors(idClass,:), 'VerticalAlignment', 'top',...
    'HorizontalAlignment','center','FontSize',8)
end
hold off
axis([1 ndata 0 1]); 
set(gca,'xTick',[1 ndata]);
title('FM fit', 'FontSize', 24);
set(gca, 'FontSize', 18);
set(gca,'TickLength',[0 0]);
set(gca,'LineWidth',1.0);
[~,idx] = unique(classVec);
legend(h(idx), Legend, 'Location', 'Southeast', 'Fontsize',12);
xlabel('day'); ylabh = ylabel('AQ', 'rotation', 0);
set(ylabh, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);
box on
end

function [f1, f2, paramset] = compareSetscumwClassMA (prgm, Nyears, tau, ndays, ndata, best, classVec)
udClass = max(classVec);
nparams = numel(parameters(prgm));
N = Nyears-tau+1;
namecell  = getmoveAddress( Nyears, prgm );
paramset = zeros(N, nparams);
dataSets = zeros(ndata, N);
cumRSets = zeros(ndata, N);
dySets = zeros(ndata, N);
cumPSets = zeros(ndata, N);
colors = jet(udClass);
for i = 1:N
    disp(['Loading set:' int2str(i) ]);
    series_name = [char(namecell(i)) '-' char(namecell(i+tau-1))];
    [~, ~, Filein, FileOut] = drawer2(prgm, series_name, tau);
    data = setdata( Filein); data=data(1:ndata);
    [p, itn] = getparam(FileOut, 4, best);
    dy = getProjection(prgm, p, ndata, ndays);
    paramset(i, :) = p;
    dataSets(:, i) = data(:);
    dySets(:, i) = dy(:);
    cumRSets(:, i) = cumsum(data(:));
    cumPSets(:, i) = cumsum(dy(:));
end

for i = 1:udClass
    Legend{i} = ['Class' int2str(i)];
end
X = cumRSets;
f1 = figure();place(50, 100, 1600, 1600, 10, 10)
h = zeros(N,1);
hold on
for i = 1:N
    idClass = classVec(i);
    h(i) = plot(X(:,i), 'color', colors(idClass,:))
    x = floor(ndata/2);
    y = 1- (i-1)/N;
    text(x, y, int2str(i), 'color', colors(idClass,:), 'VerticalAlignment', 'top',...
    'HorizontalAlignment','center','FontSize',8)
end
hold off
axis([1 ndata 0 1]);
set(gca,'xTick',[1 ndata]);
title('Data','FontSize', 24);
set(gca,'TickLength',[0 0]);
set(gca, 'FontSize', 18);
[~,idx] = unique(classVec);
legend(h(idx), Legend, 'Location', 'Southeast', 'Fontsize',12);
xlabel('day'); ylabh = ylabel('AQ', 'Rotation', 0);
set(ylabh, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);
set(gca,'LineWidth',1.0);
box on
clear h
clear idx

Y = cumPSets;
f2 = figure(); place(50, 100, 1600, 1600, 10, 10)
h = zeros(N,1);
hold on
for i = 1:N
    idClass = classVec(i);
    h(i) = plot(Y(:,i), 'color', colors(idClass,:))
    x = floor(ndata/2);
    y = 1 - (i-1)/N;
    text(x, y, int2str(i), 'color', colors(idClass,:), 'VerticalAlignment', 'top',...
    'HorizontalAlignment','center','FontSize',8)
end
hold off
axis([1 ndata 0 1]); 
set(gca,'xTick',[1 ndata]);
title('FM fit','FontSize', 24);
set(gca,'TickLength',[0 0]);
set(gca, 'FontSize', 18);
[~,idx] = unique(classVec);
legend(h(idx), Legend, 'Location', 'Southeast', 'Fontsize',12);
xlabel('day'); ylabh = ylabel('Q', 'Rotation', 0);
set(ylabh, 'Units', 'Normalized', 'Position', [-0.075, 0.5, 0]);
set(gca,'LineWidth',1.0);
box on
end







    



    
