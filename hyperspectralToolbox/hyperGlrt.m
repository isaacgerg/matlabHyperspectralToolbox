function [results] = hyperGlrt(M, t)
% HYPERGLRT Performs the generalized liklihood test ratio algorithm
%   Performs the generalized liklihood test ratio algorithm for target
% detection.
%
% Usage
%   [results] = hyperGlrt(M, U, target)
% Inputs
%   M - 2d matrix of HSI data (p x N)
%   t - target of interest (p x 1)
% Outputs
%   results - vector of detector output (N x 1)
%
% References
%   T F AyouB, "Modified GLRT Signal Detection Algorithm," IEEE
% Transactions on Aerospace and Electronic Systems, Vol 36, No 3, July
% 2000.

[p, N] = size(M);

% Remove mean from data
u = mean(M.').';
M = M - repmat(u, 1, N);
t = t - u;

R = inv(hyperCov(M));

results = zeros(1, N);
for k=1:N
    x = M(:,k);    
    results(k) = ((t'*R*x)^2) / ((t'*R*t)*(1 + x'*R*x));
end