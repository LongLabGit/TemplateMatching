function plotLines(seqIn,color)
% plot lines from seqIn input
%   INPUT: 
%      seqIn structure, with each entry = one sequence
%      color = line color ('green')
%   OUTPUT: plot
    hold on;
    numLines = length(seqIn);

    for k = 1:numLines
%        xPos = [seqIn(k).qBin(1) seqIn(k).qBin(end)]/500;
%        yPos = [seqIn(k).tBin(1) seqIn(k).tBin(end)]*2;
        xPos = [seqIn(k).xLine(1) seqIn(k).xLine(end)]/1000;
        yPos = [seqIn(k).yLine(1) seqIn(k).yLine(end)];
        plot(xPos,yPos,'LineWidth',2,'Color',color);
    end 

end
