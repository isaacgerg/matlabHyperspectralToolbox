function [results] = hyperAmsd(M, B, target)
% HYPERAMSD Adaptive matched subspace detector (AMSD) algorithm
%   Performs the adaptive matched subspace detector (AMSD) algorithm for
% target detection
%
% Usage
%   [results] = hyperAmsd(M, U, target)
% Inputs
%   M - 2d matrix of HSI data (p x N)
%   B - 2d matrix of background endmebers (p x q)
%   target - target of interest (p x 1)
% Outputs
%   results - vector of detector output (N x 1)
%
% References
%   Joshua Broadwater, Reuven Meth, Rama Chellappa.  "A Hybrid Algorithms
% for Subpixel Detection in Hyperspectral Imagery."  IGARSS 004. Vol 3.
% September 2004.

[p, N] = size(M);
I = eye(p);

E = [B target];
P_B = I - (B * pinv(B));
P_Z = I - (E * pinv(E));

results = zeros(N, 1);
tmp = P_B - P_Z;
for k=1:N
    x = M(:,k);
    % Equation 16
    results(k) = (x.'*tmp*x) / (x.'*P_Z*x);
end