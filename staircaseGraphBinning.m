myFolder = uigetdir(); % Specify the folder with  all of the separate result output files
videoLength = 45000; %maximum video length in frames

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.mat'); % Change to whatever pattern your files have in your classifier output.
theFiles = dir(filePattern);
for k = 1 : length(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  
  load(fullFileName);

dataArray = zeros(1,videoLength);

if length(allScores.postprocessed{1, 1})<videoLength
    dataArray = allScores.postprocessed{1, 1}(1:length(allScores.postprocessed{1, 1}));
else
    dataArray = allScores.postprocessed{1, 1}(1:videoLength);
    
end
%dataArray = 1:100; %to run with bogus data


summedArray = zeros(1,length(dataArray)); 

numberOfBins = 30;
binsize = length(dataArray)/numberOfBins;


for i = 2 : length(dataArray)
    summedArray(1,1) = dataArray(1,1);
    summedArray(1,i) = summedArray(1,i-1)+dataArray(1,i);
end


m = int64(binsize);

binnedArray{k,1} = fullFileName;
binnedArray{k,2} = 0;
for j = 3 : numberOfBins+2
    binnedArray{k,j} = summedArray(1,m);
    m = m+binsize;
    if m>i
    m=i;
end
end


end


%saving all data in an excel file
nameOfVariable = 'binsForStaircaseGraph';
outputFolder = myFolder;
fullPath=fullfile([char(outputFolder)], [nameOfVariable '.xls']);
xlswrite(fullPath, binnedArray);

clear

msgbox('Done!');