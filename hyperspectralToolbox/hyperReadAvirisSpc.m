function [lambda] = hyperReadAvirisSpc(filename)
%HYPERREADAVIRISSPC Reads AVIRIS .spc files.
%   hyperReadAvirisSpc reads AVIRIS files containing information about the 
% wavelengths sampled during a collect with the AVIRIS sensor.
%
% Usage
%   [lambda] = hyperReadAvirisSpc(filename)
% Input
%   filename - input filename of .spc file.
% Output
%   lambda - wavelengths contained in .spc file.


fid = fopen(filename, 'r');

i = 1;
done = false;
while not(done)
    txt = fgetl(fid);
    if (txt == -1)
        break;
    end
    a = sscanf(txt, '%g %g %g %g %g');
    lambda(i) = a(1);
    i = i+1;
end
return;
