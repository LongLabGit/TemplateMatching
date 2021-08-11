function [seqLines] = findSeq(qBin,tBin,rBin)
% identify and locate sequences from neuroSaber output and build seqLines
% struct to be used later
%   INPUT:
%       output from neuroSaber (could be filtered, thresholded, etc)
%   OUTPUT: seqLine structure, with each entry = one detected replay event
%      .qBin = all query bins contained in that sequence
%      .tBin = all template bins contained in that sequence
%      .rBin = all r-values contained in that sequence
%      .ind = first and last index of sequences

stepSize = 2; % stepSize used in neuroSaber
dUp = diff(tBin*stepSize); 
dOver = diff(qBin);
searchDist = 4; % search distance for sequential assignments (ms)
lengthTolerance = 4;

k = 1;
n = 1;
seqLines = [];
while n < length(qBin)-1
   dx = dOver(n);
   dy = dUp(n);
   if abs(dy) <= dx + searchDist && dx <= searchDist
       j = n + 1;
       dx = dOver(j);
       dy = dUp(j);
       while j < length(qBin)-1 && abs(dy) <= dx + searchDist && dx <= searchDist
            j = j + 1;
            dx = dOver(j);
            dy = dUp(j);
       end
       widthLine = max(qBin(n:j))-min(qBin(n:j));
       heightLine = max(tBin(n:j))-min(tBin(n:j));
       if heightLine > lengthTolerance && widthLine > lengthTolerance % assure that vertical (many 
           seqLines(k).qBin = qBin(n:j);
           seqLines(k).tBin = tBin(n:j);
           seqLines(k).rVal = rBin(n:j);
           seqLines(k).ind = [n,j];
           k = k + 1;
       end
       n = j+1;
   else
       n = n + 1;
   end
end

end



