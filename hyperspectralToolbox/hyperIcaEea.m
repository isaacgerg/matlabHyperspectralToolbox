function [ U, X, n ] = hyperIcaEea( M, q, U_init )
%HYPERICAEEA Performs the ICA-Endmember Extraction Algorithm
%   HyperIcaEea performs the ICA-EEA algorithm to generate abundance maps
% and find pure pixels.  This function utilizes FastICA.
%
% Usage
%   [ U, X, n ] = hyperIcaEea( M, q, U_init )
% Inputs
%   M - HSI data in 2D (p x N)
%   q - Number of materials to unmix
%   U_init - Initial endmembers (p x #)
% Outputs
%   U - matrix of recovered endmembers (p x q)
%   X - material abundance maps (q x N)
%   n - (optional) Indicies of recovered endmembers (q x 1)
%
% References
%   J. Wang and C.-I. Chang, “Applications of independent component 
% analysis in endmember extraction and abundance quantification for 
% hyperspectral imagery,” IEEE Transactions on Geoscience and Remote 
% Sensing, vol. 44, no. 9, pp. 2601–1616, sep 2006.

if (ndims(M) ~= 2)
    error('M must be 2d.');
end
    
numBands = size(M, 1);

% Run fastICA algorithm
if (nargin == 3)
    [X, U, tmp] = fastica(M, 'numOfIC', q, 'maxNumIterations', 200, ...
        'initGuess', U_init');
elseif (nargin == 2)
    [X, U, tmp] = fastica(M, 'numOfIC', numBands, 'maxNumIterations', 200);
else
    error('Not enough input arguments.');
end

%[idx sorted_scores maxPixels] = hos_icpa(X);
U = U';
scores = hyperIcaComponentScores(U);
[dummy, idx] = sort(scores, 'descend');
q = min(q, size(U,1));
idx = idx(1:q);
X = X(idx, :);
[val, maxPixels] = max(X.');
n = maxPixels;

% Extract pure endmembers from image.
U = M(:, maxPixels);

% Compute abundance maps if applicable.
if (nargout == 2)
    %X = X(idx, :);
    for i=1:q
        % Normalize so values are between 0 and 1.
        X(i,:) = hyperNormalize(abs(X(i,:))); 
        %X(i, :) = abs(X(i, :));
        %m = min(min(X(i, :)));
        %X(i, :) = X(i, :) + m;
        %m = max(max(X(i,:)));
        %X(i, :) = X(i, :) ./ m;
    end
    %X = X(1:q, :);
end

return;
