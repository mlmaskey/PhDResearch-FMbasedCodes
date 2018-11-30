function [ nsd ] = nsd_scale( data, dy, scale )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    data = data(:);
    dy = dy(:);
    data_scale = scale_data( data, scale );
    dy_scale = scale_data( dy, scale );
    nsd = stat_nsee(data_scale, dy_scale);
end
 
