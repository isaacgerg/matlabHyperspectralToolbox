function [M, A, noiseFractions] = hyperNacp(M, h, w)
% HYPERMNF Performs the maximum noise fraction (MNF) transform.
%  hyperMnf performs the maximum noise fraction (MNF) transform on the 
% data and uses spatial (row) offsets of the data to estimate the 
% covariance matrix of the data.
%
% Usage
%   M = hyperMnf(M, h, w)
% Inputs
%   M - 2D matrix (p x N)
%   h - height of image in pixels
%   w - width of image in pixels
% Outputs
%   M - 2D transformed data
%   A - 2D transformation matrix
%   noiseFractions - Estimates of the noise fraction for each band
%
% References
%    A. A. Green, M. Berman, P. Switzer, M. D. Craig, “A Transformation 
% for Ordering Multispectral Data in Terms of Image Quality with 
% Implications for Noise Removal,” IEEE Transactions on Geoscience and 
% Remote Sensing, vol. 26, pp. 65-74, 1988. 

[p, N] = size(M);

% Remove mean from data
u = mean(M.').';
for k=1:N
    M(:,k) = M(:,k) - u;
end

% Compute to rotation of the signal+noise
sigma = hyperCov(M);
M = hyperConvert3d(M, h, w, p);

% Estimate the covariance of the noise.
dX = zeros(h-1, w, p);
for i=1:(h-1)
    dX(i, :, :) = M(i, :, :) - M(i+1, :, :);
end
dX = hyperConvert2d(dX);

% Compute the covariance of the noise signal estimate.
sigmaN = hyperCov(dX);

% Greenes method
tmp = sigmaN*inv(sigma);
[A, mu] = eigs(tmp, p);
noiseFractions = diag(mu);

M = A.'*hyperConvert2d(M);


