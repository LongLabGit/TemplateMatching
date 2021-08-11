function replayLength(seqOut,color)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
figure; 
hold on
eLength = [];
eSlope = [];
for n = 1:length(seqOut)
    slope = seqOut(n).slope;
    eventLength = (seqOut(n).ind(2)-seqOut(n).ind(1))*2;
    eSlope = [eSlope,slope];
    eLength = [eLength,eventLength];
end
plot(eSlope, eLength,'.','Color',color);
xlabel('slope');
ylabel('event length');
end

