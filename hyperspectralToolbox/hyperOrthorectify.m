function [ imgOut ] = hyperOrthorectify( imgIn, altitude, hpbw )
%HYPERORTHORECTIFY Orthorectifies areal observed data.
%   Orthorectifies areal observed data using nearest neighbor interpolation.
%   
% Inputs
%   imgIn       Input image (m x n) or (m x n x p)
%   altitude    Sensor altitude (meters)
%   hpbw        Half power beam width (radians).
% Outputs
%   imgOut      Orthorectified image.

% Input parameters
if (ndims(imgIn) == 2)
    [h, w] = size(imgIn);
    p = 1;
elseif (ndims(imgIn) == 3)
    [h, w, p] = size(imgIn);
end

radPerPix = hpbw/w;
x = tan(hpbw/2)*altitude;  % m
gsd = altitude*radPerPix;  % m
n = x/gsd;

outImg = zeros(h, floor(n)*2, p);
for k=1:p
    for j=1:h
        for i=-floor(n):1:floor(n)-1
            boresiteDistance = gsd*i;
            theta = atan(boresiteDistance/altitude);
            imagePix = round(theta / radPerPix);
            imgOut(j, floor(n)+i+1, k) = imgIn(j, (w/2)+imagePix+1, k);
        end
    end
end
