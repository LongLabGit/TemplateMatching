function [qBin,tBin,rVal] = neuroSaberFunctionPar(template,popBinary,bw,stepSize)
% Template matching technique to decode song content of all recorded neural
% activity; song content defined by binarized neural activity during song (template)
%   INPUT:
%		template -  matrix of bursting in millisec (neurons x time); output
%           of makeNStemplate
%		popBinary - matrix of bursting millisec (neurons x time); output of
%           makePopBinary
%		bw - bin width for both the template and the query for comparison in millisecs (standard: 5 ms)
%		stepSize - step size for both the template and the query for the comparsion in millisecs (standard: 2 ms)
%	OUTPUT:
%		qBin - all query bins that meet criteria (burstRequirement below) in 
%           millisecs; repeats account for instances when a single query bin 
%           as two or more template bin assignments with equal r-values
%		tBin - template bin assignments corresponding to the qBins (repeats
%           correspond to instances when multiple template bins are "winners"
%           with equal r-values
%		rVal - r-scores corresponding to correlation between qBin(n) and tBin(n)
bw = bw - 1;
gpuDevice(1);	   
tempLength = round(size(template,2));
burstRequirement = 1; % criteria for the number of neurons bursting in a given millisec of the recording for bin to be analyzed
burstReqInd = find(sum(popBinary) >= burstRequirement);
steps = [1:stepSize:(length(burstReqInd) - bw)];
%initialize variables as cells
qBin = cell(length(steps),1); 
tBin = cell(length(steps),1);
rVal = cell(length(steps),1);
tic
parfor n = 1:length(steps) 
   startQ = burstReqInd(steps(n)); % redefined bin start with each loop iteration
   stopQ = startQ + bw; % redefined bin stop with each loop iteration
   querySnip =  popBinary(:,startQ:stopQ); % extract queryBin from popBinary variable
   queryBin = double(logical(sum(querySnip,2))); % binarize across bin (1 if neuron bursts at any point during the bin, 0 else)
   rSnip = [];
   startT = 1;
   tempBinAll = [];
   queryLoc = [];
   while startT < tempLength - bw % loop through template and compare each bin of the template with the given query bin
       stopT = startT + bw;
       tempSnip =  template(:,startT:stopT);
       tempBin = double(logical(sum(tempSnip,2)));
       r = corr2(queryBin, tempBin);
       rSnip = [rSnip, r];
       startT = startT + stepSize;
   end 
   indMax = rSnip == nanmax(rSnip);
   maxR = nanmax(rSnip);
   locR = find(rSnip == maxR);
     repeatT = length(locR);
     qBin{n} = ones(1,repeatT)*startQ;
     tBin{n} = locR; % cell so that multiple template bin assignments can be accounted for
     rVal{n} = ones(1,repeatT)*maxR;


end
toc
% linearize variables
   qBin = [qBin{:}];
   tBin = [tBin{:}];
   rVal = [rVal{:}];


end
 
