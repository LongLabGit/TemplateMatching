function [seqIn] = replaySlope(seqIn)
% find best fit line to define each detected event
%   INPUT: seqLine structure, with each entry = one sequence
%      .qBin = all query bins contained in that sequence
%      .tBin = all template bins contained in that sequence
%   OUTPUT: same structure with slopes for each event
%       .slope
%       .offset
%       .songInd = start and stop times in song (ms) for replay events

warning('off','all')

for n = 1:length(seqIn)
    x = seqIn(n).qBin;
    y = seqIn(n).tBin'*2;
    r = seqIn(n).rVal;
    
    c = polyfit(x,y,1); % Fit line to data using polyfit
    yLine = polyval(c,x); % Evaluate fit equation using polyval
    xLine = (y - c(2))/c(1);
    indKeep = [];
    for j = 1:length(x) % refit lines removing outliers
       if abs(y(j) - yLine(j)) <= 10
          indKeep = [indKeep,j]; 
       end
    end
    xNew = x(indKeep);
    yNew = y(indKeep);
    
    [c,S] = polyfit(xNew,yNew,1); % Fit line to data using polyfit
    yLine = polyval(c,xNew); % Evaluate fit equation using polyval
    xLine = (yNew - c(2))/c(1);
    
    rsq = 1 - (S.normr/norm(yNew - mean(yNew)))^2;
    
    seqIn(n).slope = c(1);
    seqIn(n).offset = c(2);     
    
    seqIn(n).xLine = xLine;
    seqIn(n).yLine = yLine;
    seqIn(n).rAvg = mean(r);
    seqIn(n).rsq = rsq;
end

warning('on','all')

end
 