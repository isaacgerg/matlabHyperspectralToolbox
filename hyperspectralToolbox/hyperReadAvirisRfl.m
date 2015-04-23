function [ M, wavelengths_nm ] = hyperReadAvirisRfl(filename, height, width, bands )
%HYPERREADAVIRISRFL Reads AVIRIS generated reflectance and .spc files.
%   This function reads AVIRIS .rfl, refelctance data, files.  Optionally, it 
% reads in the corresponding .spc file to obtain the the wavelengths observed
% by the sensor.
%
% Usage
%   [M, wavelengths_nm] = hyperReadAvirisRfl(filename, height, width, bands)
% Intput
%   filename - filename image filename
%   height - vector of height range
%   width - vector of width range
%   bands - vector of band range
% Output
%   M - reflectance data
%   wavelengths_nm - Wavelengths of reflectance data in nm.
%
% Format of the .rfl is below.  Taken from the AVIRIS readme file.
%
% *.rfl     AVIRIS INVERTED REFLECTANCE IMAGE DATA                                                    
%                                                                                                     
% Contents:   AVIRIS inverted reflectance data multipled by 10000 and stored as                       
%             16-bit integers.                                                                        
% File type:  BINARY 16-bit signed integer IEEE.                                                      
% Units:      10000 times reflectance factor                                                          
% Format:     Band interleaved by pixel (channel, sample, line) with dimensions                       
%             (224, 614, 512).  The last scene may be less than 512.  To                              
%             calculate the number of lines divide the file size by 275,072                           
%             bytes per line. 
%
% Example:
% [img, lambda]= readAviris('f970620t01p02_r03_sc02.a.rfl',  [1 100], [1 614], [1 224]);
% Reads in all bands and rows of reflectance data from scanlines 1 to 100.
%
% Copyright (C) 2007 Isaac Gerg. All rights reserved.

% Extract root filename.
[shortFilename, pth] = findLast(filename, '\');
if (pth > 1)
    filePath = filename(1:pth);
else
    filePath = '';
end
[tmp, pos] = findLast(shortFilename, '.');
if (pos > 1)
    rootFilename = shortFilename(1:pos-1);
else
    rootFilename = shortFilename;
end
[tmp, pth] =  findLast(rootFilename, '_');
rootFilename = rootFilename(1:pth-1);

% Parse .spc file
if (nargout==2)
    spcFilename = sprintf('%s%s%s', filePath, rootFilename, '.a.spc');
    wavelengths_nm = hyperReadAvirisSpc(spcFilename);
end

% Read in the reflectance data.
fid = fopen(filename, 'r', 'ieee-be');
data_type = 'int16';
interleave = 'bip';
M = multibandread(filename, [512 614 224], data_type, 0, interleave, 'ieee-be',...
            {'Row', 'Range', [height]}, {'Column', 'Range', [width]}, ...
            {'Band', 'Range', [bands]} );

% Normalize to proper reflectance units.
M = M ./ 10e3;
        
return;


%-------------------------------------------------------------------------------
function [answer, pos] = findLast(str, char)
    slashes = find(str == char);
    if (length(slashes) > 0)
        lastSlash = slashes(end);
    else
        lastSlash = 0;
    end
    pos = lastSlash;
    answer = str(lastSlash+1:end);
return;
%-------------------------------------------------------------------------------
