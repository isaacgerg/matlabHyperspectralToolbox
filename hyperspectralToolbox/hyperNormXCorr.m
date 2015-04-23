function [ result ] = hyperNormXCorr( a, b )
% HYPERNORMXCORR Computes the normalized cross correlation 
%   hyperNormXCorr computes the normalized cross correlation between two
% vectors.  The value returned is in [-1. 1]
%
% Usage
%   [ result ] = hyperNormXCorr( a, b )
% Inputs
%   a - Vector 1.
%   b - Vector 2.
% Outputs
%   result - Normalized cross-correlation result.

if (size(a, 2) ~= 1)
    N = size(a, 2);
    q = size(b, 2);
    result = zeros(q, N);
    for x=1:N
        for y=1:q
            result(y, x) = abs(hyperNormXCorr(a(:, x), b(:, y)));
        end
    end
else
    a = a(:); b = b(:);
    s = length(a);
    %err = normxcorr2(a, b);
    err = sum((a-mean(a)).*(b-mean(b))) / (std(a)*std(b));
    err = err * (1/(s-1));
    result = err;
end
return;