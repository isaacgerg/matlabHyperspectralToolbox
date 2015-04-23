function [scores] = hyperIcaComponentScores(M)
%HYPERICACOMPONENTSCORES Computes relevance scores of ICA components
%   Computes relevance scores of ICA components so that components can be
% ranked in a fashion similar as to eigenvalues in PCA.
%
% Usage
%   [scores] = hyperIcaComponentScores( M )
% Inputs
%   M - Input matrix (q x N)
% Outputs
%   scores - Score for each component (q x 1)
%
% References
%   J. Wang and C.-I. Chang, “Applications of independent component 
% analysis in endmember extraction and abundance quantification for 
% hyperspectral imagery,” IEEE Transactions on Geoscience and Remote 
% Sensing, vol. 44, no. 9, pp. 2601–1616, sep 2006.

numComponents = size(M, 1);
for i=1:numComponents
    % Remove the mean.
    M(i, :) = M(i, :) - mean(M(i, :));
    % Compute score.
    K3 = mean(M(i, :) .^ 3);
    K4 = mean(M(i, :) .^ 4);
    scores(i) = (1/12)*(K3*K3) + (1/48)*( (K4-3)*(K4-3) );
end