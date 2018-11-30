function [ obj, stats ] = getstats( prgm, Nyears, best, xm )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
obj = FM_obj(prgm, Nyears, best);
percentiledata = cell2mat(obj.percentiledata);
percentiledy = cell2mat(obj.percentiledy);
for i = 1:Nyears
    [~, ~, Filein, ~, ~] = drawer(i, prgm);
    dataR = load(Filein);
    sumdata = sum(dataR);
    mindata = min(dataR);
    meandata = mean(dataR);
    maxdata = max(dataR);
    stddata = std(dataR);
    CVR = stddata/meandata;
    
    dy = obj.dy{i,1};
    dyP = invnormalize(dataR, dy, xm);
    sumdyP = sum(dyP);
    mindyP = min(dyP);
    meandyP = mean(dyP);
    maxdyP = max(dyP);
    stddyP = std(dyP);
    CVP = stddyP/meandyP;

    obj.dataR{i,1} = dataR;
    obj.dyP{i,1} = dyP;
    obj.stats.sumdata{i,1} = sumdata;    
    obj.stats.mindata{i,1} = mindata;    
    obj.stats.meandata{i,1} = meandata;    
    obj.stats.maxdata{i,1} = maxdata;    
    obj.stats.stddata{i,1} = stddata;    
    obj.stats.CVR{i,1} = CVR;    
    obj.stats.sumdyP{i,1} = sumdyP;    
    obj.stats.mindyP{i,1} = mindyP;   
    obj.stats.meandyP{i,1} = meandyP;   
    obj.stats.maxdyP{i,1} = maxdyP;   
    obj.stats.stddyP{i,1} = stddyP;    
    obj.stats.CVP{i,1} = CVP;   
    
end
stats = obj.stats;
stats.quarterdata = percentiledata(:,25);
stats.quarter2data = percentiledata(:,50);
stats.quarter3data = percentiledata(:,75);
stats.quarterdy = percentiledy(:,25);
stats.quarter2dy = percentiledy(:,50);
stats.quarter3dy = percentiledy(:,75);

end

