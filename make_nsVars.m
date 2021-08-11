function make_nsVars(birdID)

dirAll = 'J:\RA_Data\';
run([dirAll,birdID,'\',birdID,'_params.m']);
load([fileSleep,'clusters.mat']);
load([fileSleep,'MotifTimes.mat']);
audioTemp = audioread([fileSleep,'template.wav']);

thresh = 0.01;
eventNum = length(Motif.start);

clusters = usableClusters(clusters,recType);
popBinary = makePopBinary(clusters,thresh);
[times,template] = makeNStemplate(popBinary,Motif,eventNum);

params.birdID = birdID;
%params.dateRec = dateRec;
params.thresh = 0.01;
params.trimTimes = times;
params.eventNum = eventNum;
params.binWidth = 5;
params.stepSize = 2;
params.audioTemp = audioTemp;

save([fileSleep,'nsVars_',birdID,'.mat'],'-v7.3','params', 'popBinary','template');

end