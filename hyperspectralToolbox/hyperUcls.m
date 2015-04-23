function [ W ] = hyperUcls( M, U )
%HYPERUCLS Unconstrained least squares
%   hyperUcls performs unconstrained least squares abundance estimation
%
% Usage
%   [ W ] = hyperUcls( M, U )
% Inputs
% 	M - 2D data matrix (p x N)
%   U - 2D matrix of endmembers (p x q)
% Outputs
%   W - Abundance maps (q x N)

if (ndims(M) ~= 2)
    error('M must be a p x N matrix.');
end
if (ndims(U) ~= 2)
    error('M must be a p x q matrix.');
end

[p1, N] = size(M);
[p2, q] = size(U);
if (p1 ~= p2)
    error('M and U must have the same number of spectral bands.');
end

Minv = pinv(U);
W = zeros(q, N);
for n1 = 1:N
    W(:, n1) = Minv*M(:, n1);
end

return;
  