function [ M_resampled ] = hyperResample( M, currentWaveLengths, desiredWaveLengths )
%HYPERRESAMPLE Resamples hyperspectral data to specified wavelenghts
%   hyperResample resamples hyperspectral data with specified wavelengths 
% to a new set of wavelengths.
%
% Usage
%   [ output ] = hyperResample( M, currentWaveLengths, desiredWaveLengths )
% Inputs
%   M - HSI data (p x N)
%   currentWavelengths - Wavelengths of M.  (p x 1)
%   desiredWavelengths - Desired wavelengths of M.
% Output
%   M_resampled - Resampled version of M


numDim = ndims(M);

if (numDim == 3)
    h = size(M, 1);
    w = size(M, 2);
    numBands = size(M, 3); 
    %M = reshape(M, w*h, numBands).';
    M = hyperConvert2d(M);
elseif (numDim == 2)
    w = size(M, 2);
    numBands = size(M, 1);    
end

% Determine if desiredWaveLengths is a subrage of currentWaveLengths
if (min(desiredWaveLengths) < min(currentWaveLengths))
    sprintf('Desired wavelenths outside of lower range.\n');
    return;
end
if (max(desiredWaveLengths) > max(currentWaveLengths))
    sprintf('Desired wavelenths outside of upper range.\n');
    return;
end

% Resample to desired bands.
ts = timeseries(M, currentWaveLengths);
ts = resample(ts, desiredWaveLengths, 'linear');
M_resampled = ts.data;
clear tmp;
clear M;

if (numDim == 3)
    %output = reshape(output, h, w, length(desiredWaveLengths));
    M_resampled = hyperConvert3d(M, w, h, length(desiredWaveLengths));
end
