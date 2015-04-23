function [M_pct, V, lambda] = hyperPct(M, q)
%HYPERPCA Performs the principal components transform (PCT)
%   hyperPct performs the principal components transform on a data matrix.
%
% Usage
%   [M_pct, V] = hyperPct(M, q)
% Inputs
%   M - 2D  matrix (p x N)
%   q - number of components to keep
% Outputs
%   M_pct - 2D matrix (q x N) which is result of transform
%   V - Transformation matrix.
%   lambda - eigenvalues
%
% References
%   http://en.wikipedia.org/wiki/Principal_component_analysis

[p, N] = size(M);

% Remove the data mean
u = mean(M.').';
%M = M - repmat(u, 1, N);
M = M - (u*ones(1,N));

% Compute covariance matrix
C = (M*M.')/N;

% Find eigenvalues of covariance matrix
[V, D] = eigs(C, q);

% Transform data
M_pct = V'*M;

lambda = diag(D);

return;