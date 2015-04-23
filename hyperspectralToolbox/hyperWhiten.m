function [X_whitened, Aw, u] = hyperWhiten( X )
%HYPERWHITEN Whitens a data matrix
%   hyperWhiten whitens a data matrix by performing a transform upon it so
% that diagonals of its covariance matrix are all unity.  Whitening is
% simply a coordinate rotation followed by a scaling factor.
%
% Usage
%   [X_whitened] = hyperWhiten( X )
% Inputs
%   X - 2D  matrix (p x N)
% Outputs
%   X_whitened - 2D matrix (p x N), now whitened
%   Aw - 2D whitening matrix.
%   u - Vector of data mean
%
% References
%   http://en.wikipedia.org/wiki/Whitening_transformation

[p, N] = size(X);

% Remove the data mean
u = mean(X.').';
X = X - repmat(u, 1, N);

% Compute covariance matrix
sigma = hyperCov(X);
% Compute SVD of covariance matrix to get eigenvectors/values
% The columns of V are the eigenvectors of sigma.
% Assume S is positive and U encodes the axis reflection information
[U,S,V] = svd(sigma);
Aw = inv(sqrt(S))* V.';
% Whiten the data
X_whitened = Aw * X;

return;