a = "ffmpeg -i ";
% b = file;
c = ".avi";
d = " -filter:v ""crop=512:768:1:1"" ";
% e = file
f = "_left.mp4";
g = " & ";

h = "ffmpeg -i ";
% i = file;
j = ".avi";
k = " -filter:v ""crop=512:768:512:1"" ";
% l = file;
m = "_right.mp4 & ";


myFolder = uigetdir(' ','Select folder with videos'); %gets directory with JAABA result files
           
filePattern = fullfile(myFolder, '*.avi'); % Only select files with this extension
theFiles = dir(filePattern); %make list of files

for z=1:length(theFiles)
[folder, baseFileNameNoExt, extension] = fileparts(theFiles(z).name);
nameList{z,1} = baseFileNameNoExt;
b = nameList{z,1};
e = nameList{z,1};
i = nameList{z,1};
l = nameList{z,1};
o = nameList{z,1};
r = nameList{z,1};

part1 = a + b + c + d + e + f + g;
part2 = h + i + j + k + l + m;


syntax = part1 + part2
nameList{z,2} = syntax;
end