function [ err ] = hyperSid( M, b )
% HYPERSID Computes the spectral information divergence between two vectors
%
% Usage
%   [err] = hyperSid(a, b)
% Inputs
%   M - 2d matrix of data (p x N)
%   b - vector 2
% Outputs
%   err - spectral information divergence between M and b
%
% References
%   C.-I Chang, "Spectral information divergence for hyperspectral image 
% analysis," IEEE 1999 International Geoscience and Remote Sensing Symp., 
% Hamburg, Germany, pp. 509-511, 28 June-2 July, 1999. 

[p, N] = size(M);
err = zeros(1, N);
for k=1:N
    err(k) = abs(sum(M(:,k).*log(M(:,k)./b)) + sum(b.*log(b./M(:,k))));
end
err = 1./(err+eps);
