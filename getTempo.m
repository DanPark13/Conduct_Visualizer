function tempo = getTempo(accelData, Fs)
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
%     innerPulse = ?????;
end
