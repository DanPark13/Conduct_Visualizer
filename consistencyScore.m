function [deviation, tempo, tempos] = consistencyScore(accelData, windowLength)
%consistencyScore calculates the variation in tempo over time within a
%   conducting data collection session.
%
%   The function essentially calculates the overall tempo for the data, and
%   uses that to determine the size of a window to "slide" over the data.
%   The window length is the length of a specified number of beats in the
%   calculated overall tempo. The function then calculates the apparent
%   tempo for the a segment of the data with that length starting at
%   incrementing samples. e.g. with a window length of 10 samples, the
%   tempo is calculated for samples 1-10, 2-11, 3-12, 4-13, and so on. This
%   basically gives us the tempo over time.
%   
    [accelData, Fs] = preprocAccelData(accelData, [1,1]); % trim and mean-center the data
    
    tempo = getTempo(accelData, Fs);    % get the overall 
    segment_length = round(1/(tempo/60)*windowLength*Fs); % each segment is 12 beats of the assumed overall tempo
    tempos = [];
    for segment = 1:length(accelData)-segment_length
        curr_seg = accelData(1+segment:segment_length+segment,:);
        tempos(segment) = getTempo(curr_seg, Fs);
    end
    deviation = std(tempos);
    plot(tempos);
    xlabel('Data Segment');
    ylabel('Apparent Tempo');
    xlim([1 length(tempos)]);
    title('Apparent Tempo Over a Sliding Time Window');
end
