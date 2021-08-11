function [qBin, tBin,rVal] = removeSeqOutliers(qBin,tBin,rVal)
% Remove data points that have no neighbors within given distance (defined by dist) steps in y
%   INPUT:
%       output from neuroSaber (qBin, tBin, rVal)
%   OUTPUT:
%       same as input but without outliers
%% filter out data points that have no neighbors
% determine distance between points and nearest neighbors
dUp = diff(tBin*2);
yNeigh = [];
dist = 20; % maximal distance (ms) between two data points for inclusion in further analysis
filtKeep = zeros(1,length(qBin));

for n = 1:length(qBin)-1
    if n > 1
        yNeigh = [dUp(n-1),dUp(n)];
    else
        yNeigh = dUp(n);
    end
    neighbors = abs(yNeigh) < dist;
    if sum(neighbors) >= 1
        filtKeep(n) = 1;
    end
end
indKeep = find(filtKeep == 1);
qBin = qBin(indKeep);
tBin = tBin(indKeep);
rVal = rVal(indKeep);
end

