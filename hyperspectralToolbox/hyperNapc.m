function [M, H, noiseFractions] = hyperNacp(M, h, w)
% HYPERMNF Performs the noise adjusted principal component transform (NACP)
%  hyperMnf performs the noise adjust principal component transform on the 
% data and uses spatial (row) offsets of the data to estimate the 
% covariance matrix of the data.
%
% Usage
%   M = hyperNacp(M, h, w)
% Inputs
%   M - 2D matrix (p x N)
%   h - height of image in pixels
%   w - width of image in pixels
% Outputs
%   M - 2D transformed data
%   H - 2D transformation matrix
%   noiseFractions - Estimates of the noise fraction for each band
%
% References
%   C-I Change and Q Du, "Interference and Noise-Adjusted Principal 
% Components Analysis," IEEE TGRS, Vol 36, No 5, September 1999.

[p, N] = size(M);

% Remove mean from data
u = mean(M.').';
for k=1:N
    M(:,k) = M(:,k) - u;
end

% Compute to rotation of the signal+noise
sigmaZ = hyperCov(M);
M = hyperConvert3d(M, h, w, p);

% Estimate the covariance of the noise.
dX = zeros(h-1, w, p);
for i=1:(h-1)
    dX(i, :, :) = M(i, :, :) - M(i+1, :, :);
end
dX = hyperConvert2d(dX);

% Compute the covariance of the noise signal estimate.
sigmaN = hyperCov(dX);

% Orthonormalize the noise subspace.
[U,deltaN,E] = svd(sigmaN);
F = E*inv(sqrt(deltaN));  % Rotation components of noise orthonormalized
% F now whitens the noise.

% Rotates the signal+noise cov so that the noise is whitened (all noise
% powers are equal)
sigmaAdj = F'*sigmaZ*F;

[U,gammaAdj,G] = svd(sigmaAdj);
H = G*F;

% Compute noise fractions
noiseFractions = diag(gammaAdj);

% Perform transform
M = H*hyperConvert2d(M);

