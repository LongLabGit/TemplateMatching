%% threshold and filter neuroSaber results

rThresh = 0; %0.5; % threshold for men r-value to count a replay event
gapLength = 10;
minLength = 40;

[qBinFilt, tBinFilt,rValFilt] = removeSeqOutliers(qBin,tBin,rVal);
[seqLines] = findSeq(qBinFilt',tBinFilt,rValFilt); 
[seqLinesJoin] = joinSeq(seqLines,gapLength); 
[seqOut] = countSeq(seqLinesJoin, 0, max(qBin), minLength,rThresh);
[seqOut] = replaySlope(seqOut);
%% plotting: 
audioTemp = params.audioTemp;
birdID = params.birdID;
figure; 
subplot(1,11,1);
    vigiSpec(audioTemp,3e4);
    view([90 -90]);
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    set(gca,'yticklabel',[])
    set(gca,'xticklabel',[])
    colormap(hot)
    freezeColors
subplot(1,11,2);
    plot(audioTemp,'k');
    view([90 -90]);
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    set(gca,'yticklabel',[])
    set(gca,'xticklabel',[])
    axis tight
subplot(1,11,3:11);
    scatter(qBinFilt/1000,tBinFilt*2,10,rValFilt)%,'filled');
    axis tight
    xlabel('Time in sleep (sec)');
    ylabel('Assigned time in song (Sec)');
    set(gca,'TickDir','out');
    title(['neuroSaber run: ',birdID, ' with sleep with song template']);
    title('motif');
    colormap(flipud(bone))
    colorbar


%% 
plotLines(seqOut(indSearchPost),cmap(3,:)); % add to plot from above







