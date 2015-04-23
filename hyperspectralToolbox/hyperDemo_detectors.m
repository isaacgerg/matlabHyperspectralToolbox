function hyperDemo_detectors
% HYPERDEMO_DETECTORS Demonstrates target detector algorithms
clear; clc; dbstop if error; close all;
%--------------------------------------------------------------------------
% Parameters
resultsDir = 'results\\';
dataDir = 'data\\AVIRIS\\';
%--------------------------------------------------------------------------

mkdir(resultsDir);

% Read part of AVIRIS data file that we will further process
M = hyperReadAvirisRfl(sprintf('%s\\f970620t01p02_r03_sc02.a.rfl', dataDir), [1 100], [1 614], [1 224]);
M = hyperNormalize(M);

% Read AVIRIS .spc file
lambdasNm = hyperReadAvirisSpc(sprintf('%s\\f970620t01p02_r03.a.spc', dataDir));

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
target = squeeze(M(11, 77, :));
figure; plot(desiredLambdasNm(goodBands), target); grid on;
    title('Target Signature; Pixel (32, 257)');

M = hyperConvert2d(M);
  
% RX Anomly Detector
r = hyperRxDetector(M);
r = hyperConvert3d(r.', h, w, 1);
figure; imagesc(r); title('RX Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, sprintf('%s\\rx detector.png', resultsDir));

% Constrained Energy Minimization (CEM)
r = hyperCem(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(abs(r)); title('CEM Detector Results'); axis image;
    colorbar;    
hyperSaveFigure(gcf, sprintf('%s\\cem detector.png', resultsDir));

% Adaptive Cosine Estimator (ACE)
r = hyperAce(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(r); title('ACE Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, sprintf('%s\\ace detector.png', resultsDir));    

% Signed Adaptive Cosine Estimator (S-ACE)
r = hyperSignedAce(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(r); title('Signed ACE Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, sprintf('%s\\signed ace detector.png', resultsDir));  

% Matched Filter
r = hyperMatchedFilter(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(r); title('MF Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, sprintf('%s\\mf detector.png', resultsDir)); 

% Generalized Likehood Ratio Test (GLRT) detector
r = hyperGlrt(M, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(r); title('GLRT Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, sprintf('%s\\cem detector.png', resultsDir));


% Estimate background endmembers
U = hyperAtgp(M, 5);

% Hybrid Unstructured Detector (HUD)
r = hyperHud(M, U, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(abs(r)); title('HUD Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, sprintf('%s\\hud detector.png', resultsDir));
   
% Adaptive Matched Subspace Detector (AMSD)
r = hyperAmsd(M, U, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(abs(r)); title('AMSD Detector Results'); axis image;
    colorbar;
hyperSaveFigure(gcf, sprintf('%s\\amsd detector.png', resultsDir));    
figure; mesh(r); title('AMSD Detector Results');

% Orthogonal Subspace Projection (OSP)
r = hyperOsp(M, U, target);
r = hyperConvert3d(r, h, w, 1);
figure; imagesc(abs(r)); title('OSP Detector Results'); axis image;
    colorbar;   
hyperSaveFigure(gcf, sprintf('%s\\osp detector.png', resultsDir));    

