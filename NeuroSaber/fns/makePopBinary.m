function [popBinary] = makePopBinary(clusters,thresh)
% takes struct clusters and binarizes the whole dataset for bursts (1) and
% non bursts (0), according to the bursting threshold set by thresh; ms
% resolution
% INPUT:
%   clusters = structure containing field "spikeTimes" with all times in
%       seconds
%   thresh = burst threshold in seconds (i.e. 0.01 for 100 Hz)


%% extract ISIs
ISI_clusters = [];
for i = 1:length(clusters)
    spikeTimes = clusters(i).spikeTimes;
    isi = spikeTimes(2:end) - spikeTimes(1:end-1);
    clusters(i).isi(:) = isi(:);
    ISI_clusters = [ISI_clusters; isi];
end

%% Determine spikes in a burst
for i = 1:length(clusters)
    isi = clusters(i).isi;
    sT = clusters(i).spikeTimes;
    k = 1;
    n = 1;
    burstSpikes = [];
    while n < length(isi) + 1
        if isi(n) < thresh 
           clusters(i).burstOn(k) = sT(n);          
           j = n + 1;
           while j <= length(isi) && isi(j) < thresh
               j = j + 1;
           end
           clusters(i).burstOff(k) = sT(j);
           burstSpikes = [burstSpikes; sT(n:j)];
           k = k +1;
           n = j;
        else
            n = n + 1;
        end
    end
    clusters(i).burstSpikes = burstSpikes;
end

%% Binarize total length of spike times
totalTime = max(vertcat(clusters(:).spikeTimes));
burstBinary = zeros(round(totalTime*1e3),1);
popBinary = zeros(length(clusters),length(burstBinary));

for k = 1:length(clusters)
    burstBinary = zeros(round(totalTime*1e3),1);
    burstOn = round(clusters(k).burstOn*1e3 + 1);
    burstOff = round(clusters(k).burstOff*1e3 + 1);
   
    n = 1;
    while n <= length(burstOn)
       burstBinary(burstOn(n):burstOff(n)) = 1; 
       n = n +1;
    end
    clusters(k).burstBinary = burstBinary;
    popBinary(k,:) = burstBinary(1:size(popBinary,2));
end

end

