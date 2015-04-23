function [imgOut] = hyperConvert2Colormap(imgIn, cmap)
%HYPERCONVERT2COLORMap Converts a matrix to a specified colormap
%  Converts a matrix into the specified colormap values.  Useful 
% for writing float data to a color image (e.g. .png) file.
%
% Usage
%   [imgOut] = hyperConvert2Colormap(imgIn, cmap)
% Inputs
%   imgIn - input matrix, must be 2D
%   cmap - (optional) Colormap to use.  If not specified, jet is used.
% Outputs
%   imgOut - 3D matrix containing corresponding jet colormap values 

if (ndims(imgIn) ~= 2)
    fprintf('Need a two dimensional image.');
    return;
end
if (nargin == 1)
    tmpJet = jet;
end
tmpJet = cmap;
s = size(tmpJet, 1);
imgIn = hyperNormalize(imgIn);
[h, w] = size(imgIn);
imgOut = zeros(h, w, 3);
for j=1:h
    for i=1:w
        v = tmpJet(round(imgIn(j, i)*(s-1))+1, :);
        imgOut(j, i, :) = v;
    end
end