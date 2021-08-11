function [times,template] = makeNStemplate(popBinary,motifTime)
% Creates template to use for template matching by trimming the popBinary matrix
% to the trim times defined by the motifTime; motifTime = [start stop] in
% seconds determined from audio trace
vocalOffset = 0.015; % used to account for delay between RA activity and vocal production (Fee at al., 2004)
times = [(motifTime(1)-vocalOffset)*1e3 (motifTime(2)-vocalOffset)*1e3]; 
template = popBinary(:,round(times(1)):round(times(2))); 

end

