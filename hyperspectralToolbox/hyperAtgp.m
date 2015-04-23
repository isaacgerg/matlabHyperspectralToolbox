function [ U, indices ] = hyperAtgp( M, q, Maug )
%HYPERATGP Performs hyerspectral unmixing using the ATGP algorithm
%
% Usage
%   [ U, indices ] = hyperAtgp( M, q, Maug )
% Inputs
%   M - 2D HSI data (p x N)
%   q - Number of materials to unmix
%   Maug - Initial vectors for M.  Used when targets are known a priori. 
%          (p x (# targets))
% Outputs
%   U - Matrix of endemembers (p x q)
%   indices - Indicies in M where the endmembers of U were extracted.
%
% References
%   H. Ren and C.-I. Chang, “Automatic spectral target recognition in 
% hyperspectral imagery,” IEEE Transactions on Aerospace and Electronic 
% Systems, vol. 39, no. 4, pp. 1232–1249, oct 2003.

[p, N] = size(M);
U = [];
indices = [];
% Find largest length pixel.
c = zeros(N, 1);
for x=1:N
    c(x) = (M(:, x).') * M(:, x);
end
[dummy, idx] = max(c);
%[dummy, idx] = min(c);

indices = [idx];
U = [M(:,idx)];
start = 1;
if (nargin == 3)
    U = Maug;
    %start = size(Maug,2)+1;
end

for n=start:q-1
    P = eye(p) - U * inv(U.' * U) * (U.');
    for x=1:N
        tmp = (P*M(:, x));
        c(x) = tmp.' * tmp;
    end
    [dummy, idx] = max(abs(c));    
    indices = [indices idx]; 
    U = [U M(:,idx)];
end