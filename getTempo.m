function tempo = getTempo(accelData, Fs)
%getTempo Calculates the apparent tempo from a accelerometer data.
%   This function works by performing the following steps:
%   - apply an FFT to all axes of the data
%   - separate the axis containing the largest magnitude - the large
%   magnitude indicates the axis with the most significant motion, which is
%   what we want to analyze.
%   - remove negative bpm values from the results
%   - find the peaks in the fft for the axis with the largest magnitude.
%   the peaks must have a prominence of at least half of the maximum
%   magnitude (this was determined experimentally to work well.)
%   - if there is only one peak, that is the one indicating the tempo
%   - if there are multiple peaks, the one with the highest BPM out of the
%   two with the largest magnitude is the one indicating the tempo
%
    arguments
        accelData (:, 4) {mustBeNumeric}
        Fs {mustBeNumeric} = 10;
    end
    
    % fft all axes
    N = length(accelData);
    f = linspace(-Fs/2, Fs/2 - Fs/N, N) + Fs/(2*N)*mod(N, 2);
    f_bpm = 60*f;
    fft_data = abs(fftshift(fft(accelData(:,2:4)),1));
    
    % get max magnitude for all axes - use axis w highest mag
    [max_mag, axis_idx] = max(max(fft_data));
    major_axis = fft_data(:,axis_idx);
    % remove negative bpm values
    major_axis = major_axis(f_bpm>=0);
    f_bpm = f_bpm(f_bpm>=0);
    
    [pks, locs] = findpeaks(major_axis, f_bpm, 'MinPeakProminence',max_mag/2, 'SortStr', 'ascend');
    if length(locs) == 1
        tempo = locs(1);
    else
        tempo = max(locs(end-1:end));
    end
end
