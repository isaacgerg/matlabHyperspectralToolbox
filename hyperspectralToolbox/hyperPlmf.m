function [results] = hyperPlmf(M, t, windowSize)
% HYPERPLMF Performs the PCA local matched filter (PLMF) target detection algorithm
%   Performs the PCA local matched filter (PLMF) target detection algorithm.
%
% Usage
%   [results] = hyperPlmf(M, target, windodwSize)
% Inputs
%   M - dd matrix of HSI data (m x n x p)
%   t - target of interest (p x 1)
% Outputs
%   results - vector of detector output (m x n)
%
% References
%   Sofa, Geva, Rotman. "Improved covariance matrices for point target detection in hyperspectral 
% data."  IEEE International Conference on Microwaves, Communications, Antennas and Electronics 
% Systems, 2009. COMCAS 2009.

% windowSize must be odd number
if ~mod(windowSize,2) 
    error('windowSize must be an odd number.')
end

if (length(size(M)) ~= 3)
    error('M must be 3-dimensional matrix.')
end

[h,w,p] = size(M);
N = h*w;

% Remove mean from the target
M = hyperConvert2d(M);
u = mean(M.').';

[Mpca,V,lambda] = hyperPct(M,p);
t_pct = V.'*(t-u);

% Create map to get neighbors
map = 1:N;
map = reshape(map,h,w);

R_hat = hyperCov(Mpca);
G = inv(R_hat);

results = zeros(h,w);
s = floor(windowSize/2)+1;
for k=s:(h-s)
    for kk=s:(w-s)
        midIdx = map(k,kk);
        neighborhoodIdx = map((k-s+1):(k+s-1),(kk-s+1):(kk+s-1));

        Mlocal = M(:,neighborhoodIdx(:));
        [~,~,lambdaLocal] = hyperPct(Mlocal,p);
        
        y = Mpca(:,midIdx);
        results(k,kk) = sum((t_pct.*y)./max(lambdaLocal,lambda));
    end
end



