function [qBinThresh,tBinThresh,rValThresh] = thresholdCorrScore(qBin,assignBin,rVal,thresh)
%threshold data points based on correlation score value (remove all those
%points with r-value below threshold
%   INPUT: 
%       all inputs from "query" struct output of neuroSaber
%       thresh = cutoff for r-value
%   OUTPUT:
%       same as input but without outliers

%thresh = 0.6;
indThresh = find(rVal>thresh);
qBinThresh = qBin(indThresh);
tBinThresh = assignBin(indThresh);
rValThresh = rVal(indThresh);

end

