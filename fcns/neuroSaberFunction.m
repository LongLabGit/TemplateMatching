function [query,qBin,tBin,rVal] = neuroSaberFunction(template,popBinary,bw,stepSize)
% Template matching technique to udnerstand how the neural activity during the template (song or BOS response) is explored throughout an unknown period (sleep)
%   INPUT:
%		template -  matrix of burst onsets and offsets in milisec (neurons x time); output of makeQueryTemp
%		popBinary - matrix of burst onsets and offsets in milisec (neurons x time); output of makeQueryTemp
%		bw - bin width for both the template and the query for comparison in milisec (standard: 5 ms)
%		stepSize - step size for both the template and the query for the comparsion in milisecs (standard: 2 ms)
%	OUTPUT:
%		query - structure with following fields:
%			queryLoc = bin of query;
%       	locR = winner bin of template;
%       	maxR = value of max correlation score;
%       	zScore 
%       	numOnes = sum(rSnip == 1);
%       	rSnip = full correlation score for each template bin
%       	queryBin = 0's and 1's of query bin;
%       	infoContent = burst content of query bin;
%    	   	tempBin = burst content of assigned template bin; 
%		qBin - query bins that meet the criteria (doubles to account for double assignments due to equal R-scores)
%		assignBin - template bin assignments corresponding to the qBins
%		rVal - r-scores corresponding to correlation between qBin(i) and assignBin(i)

	   
query = [];

tempLength = round(size(template,2));
queryLength = round(size(popBinary,2));
% queryLength = round(size(template,2));
burstRequirement = 1; % number of bursts in bin to be analyzed
startQ = 1;
i = 1;
j = 1;
while startQ < queryLength - bw 
   stopQ = startQ + bw;
   querySnip =  popBinary(:,startQ:stopQ);
   % querySnip =  template(:,startQ:stopQ);
   %figure; imagesc(querySnip);
   queryBin = double(logical(sum(querySnip,2)));
   rSnip = [];
   startT = 1;
   tempBinAll = [];
   queryLoc = [];
   if sum(queryBin) >= burstRequirement
       while startT < tempLength - bw 
           stopT = startT + bw;
           tempSnip =  template(:,startT:stopT);
           tempBin = double(logical(sum(tempSnip,2)));
           r = corr2(queryBin, tempBin);
           rSnip = [rSnip, r];
           [maxR,locR] = nanmax(rSnip);
           startT = startT + stepSize;
           tempBinAll = [tempBinAll,tempBin];
       end 
        if length(rSnip) == 1 
            binConf = 1;
        else
            stdR = std(rSnip,'omitnan');
            binConf = (maxR/stdR) - mean(rSnip,'omitnan');
        end
       query(i).queryLoc = j;
       query(i).locR = locR; % - 1;
       query(i).maxR = maxR;
       query(i).zScore = binConf;
       query(i).numOnes = sum(rSnip == 1);
       query(i).rSnip = rSnip;
       query(i).queryBin = queryBin;
       query(i).infoContent = sum(queryBin);
       i = i + 1;
   end
   j = j + 1;
   startQ = startQ + stepSize;
end
query(1).tempBin = tempBinAll; 

%% extract important query info
for n = 1:length(query)
    rSnip = query(n).rSnip;
    tBin = query(n).locR;
    qBin = query(n).queryLoc;
    indMax = rSnip == max(rSnip);
    query(n).allMaxR = rSnip(indMax);
    query(n).allAssigned = find(indMax == 1);
    query(n).allQbin = ones(length(rSnip(indMax)),1)*qBin;
end
qBin = vertcat(query(:).allQbin);
tBin = horzcat(query(:).allAssigned);
rVal = horzcat(query(:).allMaxR);

end
 
