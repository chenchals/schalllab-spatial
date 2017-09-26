function [ nhpSessions ] = processJoule()
%PROCESSJOULE Configure Joule sessions here
%     nhpConfig is a structured variable with fields that define how to
%     process matalb datafile for this NHP.
% see also PROCESSSESSIONS for how to define nhpConfig 

    nhpConfig.nhp = 'joule';
<<<<<<< HEAD
    nhpConfig.srcNhpDataFolder = '/Volumes/schalllab/data/Joule';
    nhpConfig.excelFile = '/Users/elseyjg/temp/schalllab-spatial/config/SFN_NHP_Coordinates_All.xlsx';
    nhpConfig.nhpSheetName = 'Jo';
    nhpConfig.outputFolder = '/Users/elseyjg/temp/schalllab-spatial/processed';
=======
    nhpConfig.nhpSourceDir = '/Users/chenchals/Projects/lab-schall/schalllab-clustering/data/joule';
    nhpConfig.excelFile = '/Users/chenchals/Projects/lab-schall/schalllab-spatial/config/SFN_NHP_Coordinates_All.xlsx';
    nhpConfig.sheetName = 'Jo';
    nhpConfig.nhpOutputDir = '/Users/chenchals/Projects/lab-schall/schalllab-spatial/processed/Joule';
    % a function handle for getting sessions
>>>>>>> 61e5b444aa6f562fe9559c468f56e0dc74ee2c1e
    nhpConfig.getSessions = @getSessions;  
    
    nhpSessions = processSessions(nhpConfig);
    
end

function [ sessions ] = getSessions(srcFolder, nhpTable)
% Function to output the location of joule source data files as cellstr
%  Uses column name 'filename' ifrom the execl file used for configuration
  sessions = strcat(srcFolder, filesep, regexprep(nhpTable.filename,'''',''));
end
