function hyperDemo
% HYPERDEMO Demonstrates the hyperspectral toolbox
clear; clc; dbstop if error; close all;
%--------------------------------------------------------------------------
% Parameters
resultsDir = 'results\\';
dataDir = 'data\\AVIRIS\\';
fastIcaDir = 'FastICA_25\\';
%--------------------------------------------------------------------------

fprintf('Storing results in %s directory.\n', resultsDir);
mkdir(resultsDir);
addpath(fastIcaDir);

% Read in an HSI image and display one band
slice = hyperReadAvirisRfl(sprintf('%s\\f970620t01p02_r03_sc02.a.rfl', dataDir), [1 100], [1 614], [132 132]);
figure; imagesc(slice); axis image; colormap(gray);
    title('Band 132');

% Read part of AVIRIS data file that we will further process
M = hyperReadAvirisRfl(sprintf('%s\\f970620t01p02_r03_sc02.a.rfl', dataDir), [1 100], [1 614], [1 224]);

% Read AVIRIS .spc file
lambdasNm = hyperReadAvirisSpc(sprintf('%s\\f970620t01p02_r03.a.spc', dataDir));
figure; plot(lambdasNm, 1:length(lambdasNm)); title('Band Number Vs Wavelengths'); grid on;
    xlabel('Wavelength [nm]'); ylabel('Band Number');

% NDVI - I believe this should ideally be done with radiance data and no
% reflectance as we are doing here.
ir = M(:,:,59);
r = M(:,:,27);
ndvi = (ir - r) ./ (ir + r);
figure; imagesc(ndvi); title('NDVI of Image'); axis image; colorbar;

% Isomorph
[h, w, p] = size(M);
M = hyperConvert2d(M);

% Resample AVIRIS image.
desiredLambdasNm = 400:(2400-400)/(224-1):2400;
M = hyperResample(M, lambdasNm, desiredLambdasNm);

% Remove low SNR bands.
goodBands = [10:100 116:150 180:216];
M = M(goodBands, :);
p = length(goodBands);

% Demonstrate difference spectral similarity measurements
M = hyperConvert3d(M, h, w, p);
target = squeeze(M(32, 257, :));
figure; plot(desiredLambdasNm(goodBands), target); grid on;
    title('Target Signature; Pixel (32, 257)');
    
% Spectral Angle Mapper
r = zeros(h, w);
for i=1:h
    for j=1:w
        r(i, j) = abs(hyperSam(squeeze(M(i,j,:)), target));
    end
end
figure; imagesc(r); title('Spectral Angle Mapper Result [radians]'); axis image;
    colorbar;

% Spectral Information Divergence
r = zeros(h, w);
for i=1:h
    for j=1:w
        r(i, j) = abs(hyperSid(squeeze(M(i,j,:)), target));
    end
end
figure; imagesc(r); title('Spectral Information Divergence Result'); axis image;
    colorbar;
    
% Normalized Cross Correlation
r = zeros(h, w);
for i=1:h
    for j=1:w
        r(i, j) = abs((hyperNormXCorr(squeeze(M(i,j,:)), target)));
    end
end
figure; imagesc(r); title('Normalized Cross Correlation [0, 1]'); axis image;
    colorbar;        
    
% PPI
U = hyperPpi(hyperConvert2d(M), 50, 1000);
figure; plot(U); title('PPI Recovered Endmembers'); grid on;
    

%--------------------------------------------------------------------------
% Perform a fully unsupervised exploitation chain using HFC, ATGP, and NNLS
fprintf('Performing fully unsupervised exploitation using HFC, ATGP, and NNLS...');
M = hyperConvert2d(M);

% Estimate number of endmembers in image.
q = hyperHfcVd(M, [10^-3]);
%q = 50;

% PCA the data to remove noise
%hyperWhiten(M)
M = hyperPct(M, q);
%p = q;

% Unmix AVIRIS image.
%U = hyperVca(M, q);
U = hyperAtgp(M, q);
figure; plot(U); title('ATGP Recovered Endmembers'); grid on;

% Create abundance maps from unmixed endmembers.
%abundanceMaps = hyperUcls(M, U);
abundanceMaps = hyperNnls(M, U);
%abundanceMaps = hyperFcls(M, U);
% abundanceMaps = hyperNormXCorr(M, U);
abundanceMaps = hyperConvert3d(abundanceMaps, h, w, q);

for i=1:q
    tmp = hyperOrthorectify(abundanceMaps(:,:,i), 21399.6, 0.53418);
    figure; imagesc(tmp); colorbar; axis image; 
        title(sprintf('Abundance Map %d', i));
        hyperSaveFigure(gcf, sprintf('%s\\chain1 - mam - %d.png', resultsDir, i));
        close(gcf);
end
fprintf('Done.\n');
%--------------------------------------------------------------------------
% Perform another fully unsupervised exploitation chain using ICA
fprintf('Performing fully unsupervised exploitation using ICA...');
[U, abundanceMaps] = hyperIcaEea(M, q);
abundanceMaps = hyperConvert3d(abundanceMaps, h, w, q);
for i=1:q
    tmp = hyperOrthorectify(abundanceMaps(:,:,i), 21399.6, 0.53418);
    figure; imagesc(tmp); colorbar; axis image; 
        title(sprintf('Abundance Map %d', i));
        hyperSaveFigure(gcf, sprintf('%s\\chain2 - mam - %d.png', resultsDir, i));
        close(gcf);
end
fprintf('Done.\n');


