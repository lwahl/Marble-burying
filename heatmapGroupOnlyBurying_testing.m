%Loading Optimouse position data
myDir = uigetdir(' ','Select folder with position files'); %gets directory with position files
myFiles = dir(fullfile(myDir,'*.mat'));             %gets all mat files in struct

%choose JAABA burying score folder
JAABADir = uigetdir(' ','Select folder with JAABA result files'); %gets directory with JAABA result files

A = zeros(768,512);

for k = 1:length(myFiles)     %Loading Optimouse y,x data
  baseFileName = myFiles(k).name;
  fprintf(1, 'Now reading %s\n', baseFileName);     %prints file being read
  data(k) = load([ myDir '\' myFiles(k).name ]);    %adds all  files to structure called "data"
  pos = data(k);                                    %selects Res file for analysis
  
  rounded_positions = round(pos.position_results.mouseCOM); %creates variable with y,x data as integers
  
 if length(rounded_positions) > 45000
     
rounded_positions2(1:45000,1) = rounded_positions(1:45000,1); %fix in case video was longer than 45000 frames
rounded_positions2(1:45000,2) = rounded_positions(1:45000,2);
 else
     
 end
  
  
%inserting jaaba score data into 3rd column  
[file] = uigetfile(JAABADir,...
                        'Select File that matches file read in command window'); %now choose file in JAABADir that matches the name printed and open
load([ JAABADir '\' file ]);        
transposed_scores = transpose(allScores.postprocessed{1, 1});
%Here add code to insert transposed_scores into 3rd column of rounded_positions






if length(rounded_positions) >= 45000
    transposed_scores2(1:45000,1) = transposed_scores(1:45000,1); %NEW
else
    transposed_scores_shorter(1:length(rounded_positions),1) = transposed_scores(1:length(rounded_positions),1); %NEW

end


 if length(rounded_positions) >= 45000
     finalPositions = cat(2,rounded_positions,transposed_scores2); % DOESNT WORK WHEN TRACKING AND JAABA HAVE DIFFERENT LENGTHS

 else
     finalPositions = cat(2,rounded_positions,transposed_scores_shorter); % DOESNT WORK WHEN TRACKING AND JAABA HAVE DIFFERENT LENGTHS

 end
 




%{
%ALL FRAME (INCLUDING NON-BURYING FRAMES)

for i=1:45000 %for i=1:length(pos.position_results.mouseCOM)
    if isnan(finalPositions(i,1))
    else
             
        A(finalPositions(i,2),finalPositions(i,1)) = (A(finalPositions(i,2),finalPositions(i,1))) + 1;
    end
        
end
%}



%ONLY FRAMES WHERE MICE BURY

for i=1:length(pos.position_results.mouseCOM)
    if isnan(finalPositions(i,1))
    elseif  finalPositions(i,3) == 1 %ONLY IF 3RD COLUMN IS A 1
        
        A(finalPositions(i,2),finalPositions(i,1)) = (A(finalPositions(i,2),finalPositions(i,1))) + 1;
    end
        
end









end

%%
%Divide all numbers in the matrix by the amount of files (k)

 AA=(A./k);

%% 
%Gaussian filter on final matrix wherein all sub-matrixes have been averaged
figure('Name','movement (no burying frames) topography','NumberTitle','off')
      

B = Gaussian_filter(500, 20);

Csame = conv2(AA,B,'same');
Csame2 = Csame(1:550,1:315);

set(gca,'YDir','normal')
set(gcf,'Position',[100 140 550 760])
colormap('jet')
 imagesc(Csame2);

 


Gaussian_filter(50, 5);



clear;


%plot 3D
% g1=Gaussian_filter(500,2);
% g2=Gaussian_filter(500,7);
% g3=Gaussian_filter(500,11);
% figure(1);
% subplot(1,3,1);surf(g1);title('filter size = 50, sigma = 2');
% subplot(1,3,2);surf(g2);title('filter size = 50, sigma = 7');
% subplot(1,3,3);surf(g3);title('filter size = 50, sigma = 11');



%Gaussian filter
function g=Gaussian_filter(Filter_size, sigma)
% size=50; %filter size, odd number
size=Filter_size;
g=zeros(size,size); %2D filter matrix
% sigma=2; %standard deviation
%gaussian filter
for i=-(size-1)/2:(size-1)/2
    for j=-(size-1)/2:(size-1)/2
        x0=(size+1)/2; %center
        y0=(size+1)/2; %center
        x=i+x0; %row
        y=j+y0; %col
        g(y,x)=exp(-((x-x0)^2+(y-y0)^2)/2/sigma/sigma);
    end
end
%normalize gaussian filter
sum1=sum(g);
sum2=sum(sum1);
g=g/sum2;
end






