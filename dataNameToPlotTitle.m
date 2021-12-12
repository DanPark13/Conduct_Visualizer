function [plot_title] = dataNameToPlotTitle(name)
%dataNameToPlotTitle Convert the name of a dataset to a plot title
%   Extracts the BPM and time signature from the name of a dataset and
%   formats it into a string to use as a plot title.
arr = split(name, '_');
plot_title = sprintf('%s/%s @ %s BPM', arr{3,1}, arr{4,1}, arr{2,1});
end

