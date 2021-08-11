function [seqOut] = countSeq(seqIn, epochStart, epochStop, minLength,rThresh)
% use output from "findSeq" and "joinSeq" to extract info about sequences
%   INPUT: 
%      seqLine structure, with each entry = one sequence
%      epochStart, epochStop = times in seconds to limit countSeq
%      minLength = millisec length requirement to count a replay event
%   OUTPUT: same structure with joined sequences  


startBins = [];
stopBins = [];
lengthReplay = [];
m = 1;
divisor = 1000; % convert qBin to seconds
stepSize = 2;

for n = 1:length(seqIn)
    tBin = seqIn(n).tBin;
    qBin = seqIn(n).qBin;
    rVal = seqIn(n).rVal;
     if qBin(1)/divisor > epochStart && qBin(end)/divisor < epochStop && abs(tBin(end)*stepSize - tBin(1)*stepSize) >= minLength && mean(rVal) >= rThresh
        startBinTemp = tBin(1);
        stopBinTemp = tBin(end);
        startBins = [startBins,startBinTemp];
        stopBins = [stopBins,stopBinTemp];
        lengthReplay = [lengthReplay,tBin(end) - tBin(1)];
        
        seqOut(m).qBin = [qBin];
        seqOut(m).tBin = [tBin];
        seqOut(m).rVal = [rVal];
        seqOut(m).ind = [tBin(1),tBin(end)];
        m = m + 1;
    end
end
end