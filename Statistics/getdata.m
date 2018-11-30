function [ data, baseflow ] = getdata( FileData, Nyears,prgm)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
	Freeport = load(FileData);	
	data = Freeport; % for data every day
	baseflow = getmin(Nyears,prgm);        
	data = data - baseflow; % taking away the base flow
	data = data/sum(data); % normalized		
end

