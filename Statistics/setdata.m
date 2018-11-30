function [ data ] = setdata( FileData)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
	runoff = load(FileData);	
	data = runoff; % for data every day
	data = data/sum(data); % normalized		
end

