clear; close all; clc; dbstop if error;

%--------------------------------------------------------------------------
% This demo process the data from the RIT Target Detection Blind Test
% contest which is located at: http://dirsapps.cis.rit.edu/blindtest/
% To use this file, you select a target detection algorithm and a target to
% find and then the script runs the algorithm and outputs the data into the
% outputDir.  Two files are outputted, a .img and a .hdr. You upload these
% files to the RIT website and they are automatically scored.
%--------------------------------------------------------------------------
% Parameters
inputFilename = 'data\blind_test\HyMap\blind_test_refl.img';
fasticaToolboxPath = '..\matlab_hyperspectral_toolbox\trunk\FastICA_25';
targetFilenames = {'data\blind_test\SPL\F5\F5_f.txt'};
outputDir = 'RIT Data Results';
% See switch statement for algorithm choices
algorithm = 'ace'
%algorithm = 'rmf-sum';
%algorithm = 'plmf'
%algorithm = 'matchedFilter';
%algorithm = 'sam'
%--------------------------------------------------------------------------

addpath('gmm');

addpath(fasticaToolboxPath);
mkdir(outputDir);

% Read in the data
w = 280;
h = 800;
p = 126;
M = multibandread(inputFilename, [w h p], 'int16', 0, 'bil', 'ieee-le')/1e4;
lData = hyperGetHymapWavelengthsNm();

% Read in target signatures
[sig1, lSig] = hyperGetEnviSignature(targetFilenames{1});

% Get signature from data for comparison
fsig1 = squeeze(M(122,495,:));
%sig1 = fsig1;

% Resample data to commone wavelength set
desiredLambdas = lData;
sig1 = squeeze(hyperResample(sig1, lSig, desiredLambdas));
figure; plot(sig1); grid on; title('Signature 1');
    xlabel('Wavelength [nm]'); ylabel('Reflectance [%]');
    hold on; plot(fsig1, '--');
    legend('Recorded', 'From Image');
    
goodBands = 1:p; %[3:63 69:93 98:123];

% Image sharpening
if 0
    ff = fspecial('unsharp',0.2);
    for k=1:p
        M(:,:,k) = imfilter(M(:,:,k),ff,'same');
        M(:,:,k) = imfilter(M(:,:,k),ff,'same');
        %M(:,:,k) = imfilter(M(:,:,k),ff,'same');
    end
end
   
figure; imagesc(M(:,:,40)); axis image; colormap(gray);

% Try to discover in-situ to lab kernel.
% TODO
% sub(:,1) = M(144,515,:);
% sub(:,2) = M(144,516,:);
% sub(:,3) = M(144,517,:);
% sub(:,4) = M(145,515,:);
% sub(:,5) = M(145,516,:);
% sub(:,6) = M(145,517,:);
% sub(:,7) = M(146,515,:);
% sub(:,8) = M(146,516,:);
% sub(:,9) = M(146,517,:);
% 
% alpha = pinv(sub)*sig1; %alpha = alpha ./ sum(alpha(:));
% err = sub*alpha - sig1; err = err - mean(err); badBands = find(abs(err)>0.02); 
% goodBands = setxor(1:p,badBands);
% figure; plot(err); hold on; plot(sig1,'.'); plot(fsig1,'.-'); hold off; grid on;
%     legend({'err','lab sig','in situ sig'})
% alpha = reshape(alpha,3,3);
% figure; imagesc(alpha);
% 
% for k=1:p
%     %M(:,:,p) = conv2(M(:,:,p),alpha,'same');
% end

% Emperical dervied
goodBands = [3     4     5     6     7     8     9    10    11    12    14    15    16    17    18 ...
    19    20    22    23    24    26    28    29    31    32    33    34    35    36    37 ...
    38    39    40    41    42    43    44    45    46    49    51    52    53    54    55 ...
    56    57    58    59    60    61    62    66    69    70    71    72    86    87    88 ...
    89    90    91    92    93    96    97    98    99   100   101   102   103   104   105 ...
   106   107   108   109   110   111   112   113   115   116   117   119   120   121   122];
%sig1 = squeeze(hyperResample(sig1, lSig, desiredLambdas));
figure; plot(sig1(goodBands)); grid on; title('Signature 1 - good bands only');
    xlabel('Wavelength [nm]'); ylabel('Reflectance [%]');
    hold on; plot(fsig1(goodBands), '--');
    legend('Recorded', 'From Image');


% Display data
M = hyperConvert2d(M);
%[M, H, snr] = hyperMnf(M, w, h);
M_pct = hyperPct(M, 3);
M_pct = hyperNormalize(hyperConvert3d(M_pct,w,h,3));
figure; imagesc(M_pct); axis image; title('Scene');

% Data conditioning
M = M(goodBands, :);
sig1 = sig1(goodBands);
%fsig1 = fsig1(goodBands);
%sig1 = fsig1;

%q = hyperHfcVd(M);

% Do PCT
if 0
    M = [M sig1];
    %[M,V] = hyperPct(M,size(M,1));
    [M,V] = hyperPct(M,55);
    sig1 = M(:,end);
    M = M(:,1:end-1);
    p = size(M,1);
    goodBands = 1:p;
end

%q = hyperHfcVd(M);
q = 39;

algorithm = lower(algorithm);
tic
switch algorithm
    case 'ica-eea'
        [U, X] = hyperIcaEea(M, 50, sig1);
        r = X(1,:);
        r = hyperConvert3d(r, w, h, 1);
    case 'rx'
        r = hyperConvert3d(hyperRxDetector(M), w, h, 1);
    case 'matchedfilter'
        r = hyperConvert3d(hyperMatchedFilter(M, sig1), w, h, 1);
    case 'ace'
        r = hyperConvert3d(hyperAce(M, sig1), w, h, 1);
    case 'mace'
        r = hyperConvert3d(hyperMace(M, sig1), w, h, 1);        
    case 'sid'
        r = hyperConvert3d(hyperSid(M, sig1), w, h, 1);
    case 'cem'
        r = hyperConvert3d(hyperCem(M, sig1), w, h, 1);
    case 'plmf'
        r = hyperPlmf(hyperConvert3d(M,w,h,p),sig1,9);
    case 'rmf-sum'
        r = hyperRmf(hyperConvert3d(M,w,h,p),sig1,11,'sum');        
    case 'rmf-meanlocal'
        r = hyperRmf(hyperConvert3d(M,w,h,p),sig1,11,'meanLocal');     
    case 'rmf-meangloballocal'
        r = hyperRmf(hyperConvert3d(M,w,h,p),sig1,11,'meanGlobalLocal');            
    case 'glrt'        
        r = hyperConvert3d(hyperGlrt(M, sig1), w, h, 1);
    case 'osp'
        U = hyperAtgp(M, q, sig1);
        r = hyperConvert3d(hyperOsp(M, U, sig1), w, h, 1);
    case 'amsd'
        r = hyperConvert3d(hyperAmsd(M, U, sig1), w, h, 1);
    case 'hud'
        U = hyperAtgp(M, q, sig1);
        r = hyperConvert3d(hyperHud(M, U, sig1), w, h, 1);
    case 'nnls'
        U = hyperAtgp(M, q, sig1);
        r = hyperConvert3d(hyperNnls(M,U),w,h,q);
        r = r(:,:,1);
    case 'fcls'
        U = hyperAtgp(M, q, sig1);
        r = hyperConvert3d(hyperFcls(M,U),w,h,q);
        r = r(:,:,1);        
    case 'ucls'
        U = hyperAtgp(M, q, sig1);
        r = hyperConvert3d(hyperUcls(M,U),w,h,q);
        r = r(:,:,1);     
    case 'sam'
        r = (1./(eps+hyperConvert3d(hyperSam(M, sig1), w, h, 1)));
    otherwise
        error('Incorrect algorithm name specified!\n');
end  
toc

% Display results and write to file
figure; imagesc(r); axis image; colorbar; 
    title(algorithm);
    
[a,b]=sort(r(:),'descend');
tmp = a(1:20);
figure; plot(tmp./tmp(1)); grid on;
[x, y, val] = hyperMax2d(r);

% d1 = r(122,494)
% d2 = r(127,490)
% N = prod(size(r));
% [v] = sort(r(:),'ascend');
% idx = find(v==d2);
% N-idx
% figure; hist(r(:),100);

tmp = (hyperNormalize(r)*2^10);
multibandwrite(tmp, sprintf('%s\\results.img', outputDir), 'bil', 'PRECISION', 'int16', 'MACHFMT', 'ieee-le');    

[pd,fa] = hyperRoc(r);
figure; plot(fa,pd,'.'); grid on; title(sprintf('%s\n%s',algorithm, targetFilenames{1}));


    
    