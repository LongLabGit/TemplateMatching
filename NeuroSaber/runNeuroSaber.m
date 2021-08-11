%% run template matching

thresh = 0.01; % burst threshold in seconds (i.e. 0.01 for 100 Hz)
motifTime = [start stop]; % in seconds determined from audio trace (beginning and end of core motif)
popBinary = makePopBinary(clusters,thresh); % binarized bursting matrix neurons x time (millisec)
[times,template] = makeNStemplate(popBinary,motifTime); % trims popBinary to make template corresponding to time of interest in audio trace



%% threshold and filter neuroSaber results

rThresh = 0; % threshold for mean r-value for event to be detected
gapLength = 10; % tolerated gap length (ms) to be bridged
minLength = 40; % minimum length for an event to be detected
epochStart = 0; % time in recording (secs) to begin event detection (i.e. lights off)
epochStop = max(qBin)/1000; % time in recording (sec) to end event detection (i.e. lights on)

[qBin, tBin,rVal] = removeSeqOutliers(qBin,tBin,rVal); % OPTIONAL: Remove data points that have no neighbors in song space
[seqLines] = findSeq(qBin',tBin,rVal); % identify and locate sequences from neuroSaber output
[seqLinesJoin] = joinSeq(seqLines,gapLength); % join identified sequences from seqLines across gaps (length defined by gapLength)
[seqOut] = countSeq(seqLinesJoin, epochStart, epochStop, minLength,rThresh); % extract all replay events that meet criteria 
[seqOut] = replaySlope(seqOut); % find best fit line to define each detected event (calculate slopes)

%% plotting: 
audioTemp = audioread([dirAudio,'template.wav']); % audio trace defined by motifTime
cmap = [colormap(lines); colormap(lines)];
figure; 
subplot(1,11,1);
    vigiSpec(audioTemp,3e4);
    view([-90 90]);
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    set(gca,'yticklabel',[])
    set(gca,'xticklabel',[])
    colormap(hot)
    freezeColors
subplot(1,11,2);
    plot(audioTemp,'k');
    view([-90 90]);
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    set(gca,'yticklabel',[])
    set(gca,'xticklabel',[])
    axis tight
subplot(1,11,3:11);
    scatter(qBin/1000,tBin*2,10,rVal)%,'filled');
    axis tight
    xlabel('Time in recording (sec)');
    ylabel('Assigned time in template (Sec)');
    set(gca,'TickDir','out');
    title('motif');
    colormap(flipud(bone))
    colorbar
plotLines(seqOut,cmap(1,:)); % add to plot from above







