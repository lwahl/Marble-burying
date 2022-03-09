%All in 1 file
myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.mat'));             %gets all mat files in struct
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', baseFileName);     %prints file being read
  
  data(k) = load([ myDir '\' myFiles(k).name ]);    %adds all Res files to structure called "data"
  res = data(k);                                    %selects Res file for analysis
  Burying_Results{1+k,1} = baseFileName; 
  
  Burying_Results{1,2} = 'total cms travelled';    
  Burying_Results{1+k,2} = res.Res.total_cms_travelled;     %extracts Res.total_cms_travelled from current Res file in loop and adds to 2nd row of structure
  
  Burying_Results{1,3} = 'mean_body_speed';
  Burying_Results{1+k,3} = res.Res.mean_body_speed;
    
end

%%
%saving all data in an excel file
nameOfVariable = 'Burying_Results_v2';
fullPath=fullfile([char(myDir)], [nameOfVariable '.xls']);
xlswrite(fullPath, Burying_Results);

clear

msgbox('Done!');


%%

