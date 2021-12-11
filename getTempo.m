function tempo = getTempo(accelData, cutoffs)
    arguments
        accelData (:, 3) timetable;
        cutoffs (1,2) {mustBeNumeric} = [0,0];
    end
    Fs = accelData.Properties.SampleRate;
    
    %% preprocess data
    cutoffs = Fs * cutoffs;    % convert from seconds to number of samples
    accelData([1:cutoffs(1), (size(accelData,1)-cutoffs(2)+1):end],:) = [];   % remove cutoffs
    accelData.Variables = accelData.Variables - mean(accelData.Variables);  % mean center the data
    accelData = [seconds(accelData.Timestamp-accelData.Timestamp(1)), accelData.Variables]; % convert to matrix
    
    % fft all axes
    N = length(accelData);
    f = linspace(-Fs/2, Fs/2 - Fs/N, N) + Fs/(2*N)*mod(N, 2);
    f_bpm = 60*f;
    fft_data = abs(fftshift(fft(accelData(:,2:4)),1));
    
%     data_table = table(f', f'.*60, fft_data(:,1),fft_data(:,2),fft_data(:,3),'VariableNames',{'Frequency (Hz)', 'BPM', 'X', 'Y', 'Z'});
%     figure;
%     stackedplot(data_table, {'X', 'Y', 'Z'}, 'XVariable','BPM');

    % get max magnitude for all axes - use axis w highest mag
    [max_mag, axis_idx] = max(max(fft_data));
    major_axis = fft_data(:,axis_idx);
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
