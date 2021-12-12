function [accelData, Fs] = preprocAccelData(accelData, cutoffs)
%preprocAccelData Remove the first and last x seconds of accelerometer
%   data, mean center it, and convert it from a timetable to a matrix.
    arguments
        accelData (:, 3) timetable;
        cutoffs (1,2) {mustBeNumeric} = [0,0];
    end
    Fs = accelData.Properties.SampleRate;
    
    %% preprocess data
    cutoffs = Fs * cutoffs;    % convert from seconds to number of samples
    accelData([1:cutoffs(1), (size(accelData,1)-cutoffs(2)+1):end],:) = [];   % remove cutoffs
    accelData.Variables = accelData.Variables - mean(accelData.Variables);  % mean center the data
    accelData = [seconds(accelData.Timestamp-accelData.Timestamp(1))+cutoffs(1)/Fs, accelData.Variables]; % convert to matrix
end

