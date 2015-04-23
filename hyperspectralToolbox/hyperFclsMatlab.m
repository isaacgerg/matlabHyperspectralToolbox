function [ X ] = hyperFclsMatlab( M, U )
%HYPERFCLSMATLAB Performs fully constrained least squares on pixels of M.
% hyperFclsMatlab performs fully constrained least squares of each pixel 
% in M using the endmember signatures of U.  Fully constrained least s
% quares is least squares with the abundance sum-to-one constraint (ASC) 
% and the abundance nonnegative constraint (ANC).
% This method utilizes Matlab's built-in solver to compute the answer.
%
% Usage
%   [ X ] = hyperFclsMatlab( M, U )
% Inputs
%   M - HSI data matrix (p x N)
%   U - Matrix of endmembers (p x q)
% Outputs
%   X - Abundance maps (q x N)

if (ndims(U) ~= 2)
    error('M must be a p x q matrix.');
end

[p1, N] = size(M);
[p2, q] = size(U);
if (p1 ~= p2)
    error('M and U must have the same number of spectral bands.');
end

Minv = pinv(U);
X = zeros(q, N);
for n1 = 1:N
    %X(:, n1) = Minv*M(:, n1);
    X(:, n1) = lsqlin(U, M(:, n1), [], [], ones(1,q), 1, zeros(q,1),[], []);
end

return;


