function [indBins,tempBins] = epochSeq(seqOut,times)
% Isolate the replay events that occur within a specific time defined by
% epochStart and epochStart
%   OUTPUT:
%       indBins = seqOut ind corresponding to the epoch
%       tempBins = tBin start and stop times

tempBins = [];
indBins = [];


for n = 1:length(seqOut)
    qBinSeq = seqOut(n).qBin;
    songInd = seqOut(n).ind';
    qStart = qBinSeq(1)/1000;
    qStop = qBinSeq(end)/1000;
    if qStart >= times(1) && qStop < times(2)
        tempBins = [tempBins,songInd];
        indBins = [indBins,n];
    end
end
end

