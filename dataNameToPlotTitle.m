function [plot_title] = dataNameToPlotTitle(name)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
arr = split(name, '_');
plot_title = sprintf('%s/%s @ %s BPM', arr{3,1}, arr{4,1}, arr{2,1});
end

