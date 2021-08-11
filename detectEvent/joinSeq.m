function [seqOutLoop] = joinSeq(seqIn,gapSize)
% join identified sequences from "findSeq" with function loopJoinSeq (small gaps) 
%   INPUT: seqLine structure, with each entry = one sequence
%      .qBin = all query bins contained in that sequence
%      .tBin = all template bins contained in that sequence
%      .ind = first and last index of sequences
%   OUTPUT: same structure with joined sequences     

%% regular gap filling
stepSize = 2; % parameter used in neuroSaber
firstX = [];
lastX = [];
firstY = [];
lastY = [];

for p = 1:length(seqIn)
   X1 = seqIn(p).qBin(1);
   endX = seqIn(p).qBin(end);
   Y1 = seqIn(p).tBin(1)*stepSize;
   endY = seqIn(p).tBin(end)*stepSize;
   firstX = [firstX,X1];
   lastX = [lastX,endX];
   firstY = [firstY,Y1];
   lastY = [lastY,endY];
end

stepX = firstX(2:end) - lastX(1:end-1);
stepY = firstY(2:end) - lastY(1:end-1);
indJoin = abs(stepX) <= gapSize & abs(stepY) <= gapSize & abs(stepY) > 0;

seqOutLoop = [];
if sum(indJoin) == 0
   seqOutLoop = seqIn; 
end

while sum(indJoin) > 0
    [seqOutLoop] = loopJoinSeq(seqIn, indJoin); % recursively join close together replay events 
    seqIn = seqOutLoop;
    
    firstX = [];
    lastX = [];
    firstY = [];
    lastY = [];

    for p = 1:length(seqIn)
       X1 = seqIn(p).qBin(1);
       endX = seqIn(p).qBin(end);
       Y1 = seqIn(p).tBin(1)*stepSize;
       endY = seqIn(p).tBin(end)*stepSize;
       firstX = [firstX,X1];
       lastX = [lastX,endX];
       firstY = [firstY,Y1];
       lastY = [lastY,endY];
    end

    stepX = firstX(2:end) - lastX(1:end-1);
    stepY = firstY(2:end) - lastY(1:end-1);
    indJoin = abs(stepX) <= gapSize & abs(stepY) <= gapSize & abs(stepY) > 0;
end


end
