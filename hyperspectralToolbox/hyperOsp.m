function [nu] = hyperOsp(M, U, target)
% HYPEROSP Performs the othogonal subspace projection (OSP) algorithm
%   Performs the othogonal subspace projection algorithm for target
% detection.
%
% Usage
%   [results] = hyperOsp(M, U, target)
% Inputs
%   M - 2d matrix of HSI data (p x N)
%   U - 2d matrix of background endmebers (p x q)
%   target - target of interest (p x 1)
% Outputs
%   results - vector of detector output (N x 1)
%
% References
%   Qian Du, Hsuan Ren, and Chein-I Cheng. "A Comparative Study of 
% Orthogonal Subspace Projection and Constrained Energy Minimization."  
% IEEE TGRS. Volume 41. Number 6. June 2003.

[p, N] = size(M);

% Equation 3
P_U = eye(p) - U * pinv(U);

% For abundance estimation 
% Equation 4
%w_osp = inv(target.'*P_U*target) * P_U * target;

tmp = target'*P_U*target;
nu = zeros(N, 1);
for k=1:N
    nu(k) = (target'*P_U*M(:,k))/tmp;
end