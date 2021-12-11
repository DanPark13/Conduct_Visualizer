function [x, y, z] = accelplot(Acceleration, cutoffs)
%accelplot Summary of this function goes here
%   Detailed explanation goes here
Fs = Acceleration.Properties.SampleRate;
cutoffs = cutoffs .* Fs;
cutoffs(2) = length(Acceleration.X)-cutoffs(2);
data = horzcat( Acceleration(cutoffs(1):cutoffs(2), "X"),...
                Acceleration(cutoffs(1):cutoffs(2), "Y"),...
                Acceleration(cutoffs(1):cutoffs(2), "Z"));

Time = Acceleration.Timestamp(cutoffs(1):cutoffs(2));

% mean-center the data
x = data.X-mean(data.X);
y = data.Y-mean(data.Y);
z = data.Z-mean(data.Z);
% apply a low pass filter to the data at 4 Hz (240 BPM)
% x = lowpass(x, 4, Fs);
% y = lowpass(y, 4, Fs);
% z = lowpass(z, 4, Fs);

% control_amp = @(n) max(abs(n));
% control_amp = @(n) mean(abs(n));

% control_sin = (sin((bpm/60)*2*pi*(0:.1:((length(Time)-1)/10))))';
% control_x = control_amp(x) .* control_sin;
% control_y = control_amp(y) .* control_sin;
% control_z = control_amp(z) .* control_sin;

% x = conv(x, ones(1,5), 'same')/5;
% y = conv(y, ones(1,5), 'same')/5;
% z = conv(z, ones(1,5), 'same')/5;
% stackedplot(timetable(Time, x,y,z,control_x,control_y,control_z, 'VariableNames',{'X','Y','Z','control_x','control_y','control_z'}),{...
%     {'X', 'control_x'},...
%     {'Y', 'control_y'},...
%     {'Z', 'control_z'}});
% stackedplot(timetable(Time, x,y,z, 'VariableNames',{'X','Y','Z'}));
end

