function writeNeuroscopeSaber(qBin,tBin,stepSize,sampRate,fileBaseName)
% takes cluster IDs and spike times from loadKS (or variant) and writes two file types:
% fileBaseName.clu.n = list of cluster IDs in chronological order
%                       corresponding to spike times; first entry = total
%                       number of clusters on shank (n = shank number)
% fileBaseName.res.n = list of spike times in chronological order;
%                       (n = shank number)

qTime = qBin.*stepSize*sampRate/1e3;  
numBins = length(unique(tBin));
assignTime = [numBins,tBin]';
    
dlmwrite([fileBaseName,'.clu.3'],assignTime,'precision',11,'newline','pc');
dlmwrite([fileBaseName,'.res.3'],qTime,'precision',11,'newline','pc');

end

