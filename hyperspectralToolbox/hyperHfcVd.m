function [q] = hyperHfcVd(M, far)
%HYPERHFC Computes the virtual dimensionality measure for an HSI image
%  hyperHfc computes the vitual dimensionality (VD) measure for an HSI
% image for specified false alarm rates.  When no false alarm rate(s) is
% specificied, the following vector is used: 1e-1, 1e-2, 1e-3, 1e-4, 1e-5.
% This metric is used to estimate the number of materials in an HSI scene.
%
% Usage
%   [q] = hyperHfc(M, far)
% Inputs
%   M - HSI data as a 2D matrix (p x N)
%   far - (optional) false alarm rate(s)
% Outputs
%   q - VD measure, number of materials estimate.
%
% References
%   C.-I. Chang and Q. Du, “Estimation of number of spectrally distinct 
% signal sources in hyperspectral imagery,” IEEE Transactions on 
% Geoscience and Remote Sensing, vol. 43, no. 3, mar 2004.
%   J. Wang and C.-I. Chang, “Applications of independent component 
% analysis in endmember extraction and abundance quantification for 
% hyperspectral imagery,” IEEE Transactions on Geoscience and Remote 
% Sensing, vol. 44, no. 9, pp. 2601–1616, sep 2006.   


if (3 == length(size(M)))
    fprintf('Only 2D matrix permitted!\n');
    return;
end

numBands = size(M, 1);
N = size(M, 2);

% Estimate the number of endmembers to extract (VD)
lambdaCov = flipud(eig(cov(M')));
lambdaCorr = flipud(eig(corr(M')));

if (nargin == 1)
    far = [10^(-1) 10^(-2) 10^(-3) 10^(-4) 10^(-5)];
end

for y=1:length(far)
    numEndmembers = 0;
    %pf = 10^(-y);
    pf = far(y);
    for x=1:numBands
        sigmaSquared = (2*lambdaCov(x)/N) + (2*lambdaCorr(x)/N) + (2/N)*lambdaCov(x)*lambdaCorr(x);
        sigma = sqrt(sigmaSquared);
        tau = -norminv(pf, 0, sigma);
        if ((lambdaCorr(x)-lambdaCov(x)) > tau)
            numEndmembers = numEndmembers + 1;
        end
    end
    q(y) = numEndmembers;
end
return;