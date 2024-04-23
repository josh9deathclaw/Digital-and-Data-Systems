fileName = 'Sample_4.mat' ; %signal loaded
Loaded = load(fileName);
VariableNames = fieldnames(Loaded);
x = eval(['Loaded.',VariableNames{1}]); %x variable made to be loaded file (signal)
Sec = 10 ;
rate = 360;

[b, a] = butter(11,0.1,'low'); %filters data, Wn and n, 

filted = filtfilt(b,a,x); 
subplot(2,1,1) %creates subplot for data for both graphs
plot(x,'b-') %plots original unfiltered data on figure
hold on; 
subplot(2,1,2)
plot(filted,'k-') %plots filtered data on figure in black
hold off
title('Time domain');
xlabel('Time');
ylabel('Voltage');

[peaks, locs_R] = findpeaks(filted,'MinPeakProminence',180);  %looks for the R peaks using MinPeakProminence, top peaks stand out 
[peaks, locs_T] = findpeaks(filted,'MinPeakHeight',890); %looks for all peaks with a height of at least 890


hold on;
plot(locs_R,filted(locs_R),'gp','MarkerSize',10) %the R peaks of the graph are plotted as green star markers

%current and next are bystanders, usually they would be changed to match
%the peaks and locations however I didn't want to break my code, this did
%cause the interval values to be more difficult to calculate however
%this also only really works well for Sample 1, it struggles with the rest
%one the labs I watched did similar code to this, however I was not able to
%fully understand in time so couldn't make the correct adjustments 

%loop for finding S and T points 

for (i = 1:length(locs_R)) %length gets total number of R peaks
    current = locs_R(i);
    next = current + 1; %looks for the next point to the right of the R peak
    while filted(current) >= filted(next) %creates loop to get the nearest point to all R peaks
        current = next;
        next = next + 1;
    end
    hold on 
    plot(current,filted(current),'mx','MarkerSize',10) %plots S points
    locs_S=filted(current);    
    %everything below was explained in lab 12, however confused how it works, need to learn
    
    j = i+1; 
    if(j<length(locs_R))
        while current < locs_R(j)
            if (filted(current)>880 && filted(current)>=filted(next))
                break;
            end
            current = next;
            next = next + 1;
        end
        hold on 
        plot(current,filted(current),'ro','MarkerSize',10) %plots T points
        hold off
    end
end

%loop for finding Q and P points

for (i = 1:length(locs_R))
    current = locs_R(i); 
    next = current - 1; 
    while filted(current) >= filted(next)
        current = next;
        next = next - 1;
    end
    hold on 
    plot(current,filted(current),'bs','MarkerSize',10) %plots Q points
    locs_Q = filted(current); %because using current and next instead or proper variables need to specify locs_Q 
    %for this set of specific filtered peaks

    %find P point
        j = i+1;
    if(j<length(locs_R))
        while current < locs_R(j)
            if (filted(current)>880 && filted(current)>=filted(next))
                break;
            end
            current = next;
            next = next - 1;
        end
        hold on 
        plot(current,filted(current),'cd','MarkerSize',10) %plots P points
        hold off
    locs_P = filted(current); 
    end
end

%T and P waves are off quite a bit, they need to be in the small section
%past/over the peak, so interval calculations will be off

%not enough time to implement proper calculation to find the intervals
%so they are very far off in nearly all cases however structure is their

%PR Interval
PR = (mean(locs_T)-mean(locs_Q))/360;  
if (0.12 >= PR) && (PR <= 0.2) 
    fprintf('P-R Interval : %.3f seconds\n', PR)
else 
    fprintf('The P-R Interval is out of the normal range : %.3f seconds\n', PR)
end

%QT Interval
QT = (mean(locs_Q)-mean(locs_P))/360; 
if (QT <= 0.38) 
    fprintf('Q-T Interval : %.3f seconds\n', QT)
else 
    fprintf('The Q-T Interval is out of the normal range %.3f seconds\n', QT)
end

%QRS Interval
QRS = (mean(locs_S)-mean(locs_Q))/360; 
if (QRS <= 0.1) 
    fprintf('QRS Interval : %.3f seconds\n', QRS)
else 
    fprintf('The QRS Interval is out of the normal range %.3f seconds\n', QRS)
end

% takes the mean values for the points, subtracts them in appropriate order then divides by the rate
% the way you are supposed to do this involves creating a matrix to place values in and new variables for
% the peaks and locs, than doing similar but a bit more involved math using
% the means of the points, didn't have time nor coding skill