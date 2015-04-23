function [results] = hyperRmf(M, t, windowSize, algorithm)
% HYPERPLMF Performs the regularlzed matched filter (RMF) target detection algorithm
%   Performs the regularized matched filter (PLMF) target detection algorithm.
%
% Usage
%   [results] = hyperRmf(M, target, windodwSize)
% Inputs
%   M - dd matrix of HSI data (m x n x p)
%   t - target of interest (p x 1)
%   windowSize - window size designating local pixel region (scalar)
%   algorithm - 'sum' designates sum of local and global eigenvalues.
%               'meanLocal' desiginates to use the mean of the local
%               eigenvalues.
%               'meanGlobalLocal' designates to use the mean of the local
%               and global eigenvalues.
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

if (nargin ~= 4)
    error('Not enough input arguments');
end

[h,w,p] = size(M);
N = h*w;

% Remove mean from the target
M = hyperConvert2d(M);
u = mean(M.').';

[Mpca,V,lambdaGlobal] = hyperPct(M,p);
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
        
        switch algorithm
            case 'sum'
                results(k,kk) = sum((t_pct.*y)./(lambdaLocal+lambdaGlobal));
            case 'meanLocal'
                results(k,kk) = sum((t_pct.*y)/mean(lambdaLocal(:)));
            case 'meanGlobalLocal'
                results(k,kk) = sum((t_pct.*y)./((lambdaLocal+lambdaGlobal)/2));                
            otherwise
                error('Algorithm option unknown.');
        end
    end
end



