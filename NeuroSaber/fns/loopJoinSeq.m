function [seqLinesJoin] = loopJoinSeq(seqIn, indJoin)
% join identified sequences from "findSeq"
%   INPUT: seqLine structure, with each entry = one sequence
%      .qBin = all query bins contained in that sequence
%      .tBin = all template bins contained in that sequence
%      .ind = first and last index of sequences
%   OUTPUT: same structure with joined sequences     

k = 1;
h = 1;
while h < length(indJoin)
    if indJoin(h) > 0
        m = h + 1;
        if indJoin(m) > 0 
            m = m + 1;
        end
        seqLinesJoin(k).qBin = [seqIn(h).qBin;seqIn(m).qBin];
        seqLinesJoin(k).tBin = [seqIn(h).tBin,seqIn(m).tBin];
        seqLinesJoin(k).rVal = [seqIn(h).rVal,seqIn(m).rVal];
        seqLinesJoin(k).ind = [seqIn(h).tBin(1),seqIn(m).tBin(end)];
        h = m;
    else
        seqLinesJoin(k).qBin = [seqIn(h).qBin];
        seqLinesJoin(k).tBin = [seqIn(h).tBin];
        seqLinesJoin(k).rVal = [seqIn(h).rVal];
        seqLinesJoin(k).ind = [seqIn(h).tBin(1),seqIn(h).tBin(end)];
    end
    k = k + 1;
    h = h + 1;
end
end