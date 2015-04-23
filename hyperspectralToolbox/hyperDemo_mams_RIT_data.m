clear; close all; clc; dbstop if error;

%--------------------------------------------------------------------------
% This demo process the data from the RIT Target Detection Blind Test
% contest which is located at: http://dirsapps.cis.rit.edu/blindtest/
%--------------------------------------------------------------------------
% Parameters
inputFilename = 'data\self_test\HyMap\self_test_rad.img';
fasticaToolboxPath = '..\matlab_hyperspectral_toolbox\trunk\FastICA_25';
outputDir = 'RIT MAMS\';
%--------------------------------------------------------------------------

addpath(fasticaToolboxPath);
mkdir(outputDir);

% Read in the data
h = 280;
w = 800;
p = 126;
N = w*h;
M = multibandread(inputFilename, [h w p], 'int16', 0, 'bil', 'ieee-le')/1e4;
lData = hyperGetHymapWavelengthsNm();

% Select good bands.  In this case, all bands are okay to use.    
goodBands = 1:p;
    
% Display data
M = hyperConvert2d(M);
M_pct = hyperPct(M, 3);
M_pct = hyperNormalize(hyperConvert3d(M_pct, h, w, 3));
figure; imagesc(M_pct); axis image; title('Scene');

% Data conditioning
M = M(goodBands, :);

% Compute the number of endmembers/materials in the scene.
%q = hyperHfcVd(M);
q = 53;

modelErr = [];
for q = 1:p
    % Find the endmembers/materials in the scene.
    fprintf('Searching for fundemental endmembers...\n');
    [U,idx] = hyperAtgp(M, q);
    idx
    figure; plot(U); title('ATGP Recovered Endmembers'); grid on;

    % Create abundance maps from unmixed endmembers.
    fprintf('Generating material abundance maps (MAMs)...\n');
    %abundanceMaps = hyperUcls(M, U);
    %abundanceMaps = hyperNnls(M, U);
    abundanceMaps = hyperFcls(M, U);
    % abundanceMaps = hyperNormXCorr(M, U);
    abundanceMaps = hyperConvert3d(abundanceMaps, h, w, q);

    % Display results and save figures to disk.
    for i=1:q    
        figure; imagesc(abundanceMaps(:,:,i)); colorbar; axis image; 
            title(sprintf('Abundance Map %d', i));
            hyperSaveFigure(gcf, sprintf('%s\\chain1 - mam - %d.png', outputDir, i), 'wysiwyp');
            close(gcf);
    end

    % Compute abundance fraction sums for each pixel.
    abundanceMaps = hyperConvert2d(abundanceMaps);
    tmpMap = zeros(h*w,1);
    for k=1:N
        tmpMap(k) = sum(abundanceMaps(:,k));
    end
    tmpMap = hyperConvert3d(tmpMap, h, w, 1);
    figure; imagesc(tmpMap); colorbar; axis image;
        title('Sum of Each Pixel Abundance');

    % Compute error between decomposed signature and real signature
    tmpMap = zeros(h*w,1);
    reconstructedM = U*abundanceMaps;
    for k=1:N         
        tmpMap(k) = norm(reconstructedM(:,k)-M(:,k));
    end
    tmpMap = hyperConvert3d(tmpMap, h, w, 1);
    figure; imagesc(tmpMap); colorbar; axis image;
        title('Model Error');  
    close all;
    
    modelErr(q) = sum(tmpMap(:));
end

figure; plot(1:p,modelErr(1:p)); grid on;
    title('Model Error');

    fprintf('Done.\n');


%---------------
t = tmpMap(:);
[~,tMaxIdx]=max(t);
figure;plot(M(:,tMaxIdx));

[a,b]=sort(t,'descend');
b(1:100)
figure; plot(a);
figure; hist(a,100);

figure; plot(M(:,b(1:100)));
title('100 worst model fits')







