fileName = 'Sample_4.mat' ; %choose which sample
Loaded = load(fileName);
VariableNames = fieldnames(Loaded);
x = eval(['Loaded.',VariableNames{1}]); %original signal is made into x variable

Sec = 10 ;
rate = 360;

figure(1) 
subplot(2,1,1) %makes the graph look nicer and not so squished
plot(x,'b-') %plots original data
title('Time domain');
xlabel('Time');
ylabel('Voltage');
%can smooth in order to get rid of multiple peaks in similar location

[peaks, locs] = findpeaks(x,'MinPeakHeight',1000,'MinPeakProminence',150); %finds peaks for x, which is the signal 
%with a minimum height of 1000 and a minimum prominenced of 150, thus only
%the top peaks are measured as they meet this criteria
numpeaks = length(locs);
avedist = (max(locs) - min(locs))/(numpeaks-1); %calculates the average distance between each peak
bpm = (60/avedist)*360; %calculated bpm by diving 60 seconds (1minute) and dividing it by the average distance and 
%multiplying by the rate
fprintf('%.f Beats Per Minute.\n', bpm); %prints out BPM to user
%can increase minpeakheight to get more accurate for sample 8 
%however this is an outlier and destroys accuracy of the other 7 samples