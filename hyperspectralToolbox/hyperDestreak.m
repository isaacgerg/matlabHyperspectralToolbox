function [M, alpha, beta] = hyperDestreak(M)
% HYPERDESTREAK Destreaks a hyperspectral data cube.
% hyperDestreak removes vertical streaking artifacts from an HSI image.
% 
% Usage
%   [M, alpha, beta] = hyperDestreak(M)
% Inputs
%   M - 3D cube of HSI data.
% Outputs
%   M - Destreaked data
%   alpha - mean value of column and band
%   beta - offset value of column and band
%
% References
%   Data, et al.  "Processing E)-1 Hyperion Hypespectral Data to Support
% the Application of Agricultural Index." IEEE TGRS. Vol 41. No 6. June
% 2003.

[h, w, p] = size(M);
m = zeros(p,1);
for k=1:p
    tmp = M(:,:,k);
    tmp = tmp(:);
    m(k) = mean(tmp);
    s(k) = std(tmp);
    for kk=1:w
        tmp = squeeze(M(:,kk,k));
        ml = mean(tmp);
        sl = std(tmp);
        alpha(k,kk) = s(k) / sl;
        beta(k,kk) = m(k) - alpha(k,kk)*ml;
        tmp = alpha(k,kk)*tmp + beta(k,kk);
        M(:,kk,k) = tmp;
    end
end
