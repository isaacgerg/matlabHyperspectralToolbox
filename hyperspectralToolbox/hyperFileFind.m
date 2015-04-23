function listOfMatchingFiles = hyperFileFind(startingDirectory, nameTemplate)
% HYPERFILEFIND Searches through directories for files with specified name
%   Searches through the specified directory and sub-directories looking
% for files matching the specified template. Returns the full, partial
% path for each file matching the template
%
% Usage
%   [listOfMatchingFiles] = hyperFileFind(startingDirectory, nameTemplate)
% Inputs
%   startingDirectory - Directory to begin search
%   nameTemplate - Template for file nameTemplate matching
% Outputs
%   listOfMatchingFiles - Cell array with each element containing a string of a 
%          file matching the name template.


% Find all directories
tmp = dir(startingDirectory);
dTmp = [];
for i=3:length(tmp)
    if (tmp(i).isdir == 1)
        dTmp = [dTmp; tmp(i)];
    end
end

dTmp = [dTmp; dir(fullfile(startingDirectory, nameTemplate))];
listOfMatchingFiles = {};
for i=1:length(dTmp)
    if (dTmp(i).isdir == 1)
        listOfMatchingFiles = [listOfMatchingFiles; hyperFileFind(fullfile(startingDirectory, dTmp(i).name), nameTemplate)];
    else
        listOfMatchingFiles = [listOfMatchingFiles; fullfile(startingDirectory, dTmp(i).name)];
    end
end
