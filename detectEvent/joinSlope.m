function [seqOut] = joinSlope(seqIn)
% join identified sequences from "findSeq"
%   INPUT: seqLine structure, with each entry = one sequence
%      .qBin = all query bins contained in that sequence
%      .tBin = all template bins contained in that sequence
%      .slope
%      .offset
%   OUTPUT: same structure with joined events for those that lie on the
%   same line


warning('off','all')

for n = 1:length(seqIn)-1
    x1 = seqIn(n).xLine;
    y1 = seqIn(n).yLine;
    slope1 = seqIn(n).slope;
    x2 = seqIn(n+1).xLine;
    y2 = seqIn(n+1).yLine;
    slope2 = seqIn(n+1).slope;
    slopeBridge = (y2(1) - y1(end))/(x2(1) - x1(end));
    slopeAvg = (slope1 + slope2)/2;
    indJoin(n) = (abs(slopeBridge-slopeAvg) <= 0.5) && abs(x2(1)-x1(end)) <= 100;
end

j = 1;
c = 1;
while j <= length(seqIn)-1
    q = seqIn(j).qBin';
    t = seqIn(j).tBin;
    k = j;
    while indJoin(k) == 1
        q = [q,seqIn(k+1).qBin'];
        t = [t,seqIn(k+1).tBin];
        k = k + 1;
    end
    seqOut(c).qBin = q;
    seqOut(c).tBin = t;
    if k == j
        j = k + 1;
    else
        j = k;
    end
    c = c + 1;
end

warning('on','all')

end
 