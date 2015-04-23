function [ X ] = hyperNnls( M, U )
%HYPERNNLS Performs non-negative constrained least squares on pixels of M.
%   hyperFcls performs non-negative constrained least squares of each pixel 
% in M using the endmember signatures of U.  Non-negative constrained least 
% squares with the abundance nonnegative constraint (ANC).
% Utilizes the method of Bro.
%
% Usage
%   [ X ] = hyperNnls( M, U )
% Inputs
%   M - HSI data matrix (p x N)
%   U - Matrix of endmembers (p x q)
% Outputs
%   X - Abundance maps (q x N)
% 
% References
%   Bro R., de Jong S., Journal of Chemometrics, 1997, 11, 393-401 

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
X = zeros(q, N);
MtM = U.'*U;
for n1 = 1:N
    drawnow;
    %X(:, n1) = Minv*M(:, n1);
    %X(:, n1) = lsqlin(U, M(:, n1), [], [], ones(1,q), 1, zeros(q,1),[], []);    
    X(:, n1) = fnnls(MtM, U.' * M(:,n1));
    %X(:, n1) = lsqnonneg(U, M(:, n1));
end

return;