function [errRadians] = hyperSam(a, b)
% HYPERSAM Computes the spectral angle error (in radians) between two vectors
%
% Usage
%   [errRadians] = hyperSam(a, b)
% Inputs
%   a - Vector 1.
%   b - Vector 2.
% Outputs
%   errRadians - angle between vectors a and b in radians

[p,N] = size(a);
errRadians = zeros(1,N);
for k=1:N
    tmp = a(:,k);
    errRadians(k) = acos(dot(tmp, b)/ (norm(b) * norm(tmp)));
end
return;