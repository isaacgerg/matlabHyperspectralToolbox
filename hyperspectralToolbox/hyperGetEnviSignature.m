function [refl, lambdaNm] = hyperGetEnviSignature(filename)
% HYPERGETENVISIGNATURE Reads an ENVI hyperspectral reflectance signature
%   hyperGetEnviSignature reads the RIT Target Detection Blind Test
% signature files.
%
% Usage
%   [refl, lambdaNm] = hyperGetEnviSignature(filename)
%
% Input
%   filename - Filename of signature.
% Output
%   refl - Reflectance values [0, 1].
%   lambdaNm - corresponding wavelengths in nanometers

fid = fopen(filename);

for k=1:3
    dummy = fgetl(fid);
end

num = 1;
while 1
    tmp = fgetl(fid);
    if (tmp == -1), break, end;
    v = sscanf(tmp, '%f');
    refl(num) = v(2);
    lambdaNm(num) = v(1);
    num = num + 1;
end

refl = refl / 100;