function [U] = hyperPpi(M, q, numSkewers)
% HYPERPPI Performs the pixel purity index (PPI) algorithm
%   Performs the pixel purity index algorithm for endmember finding.
%
% Usage
%   [U] = hyperPpi(M, q, numSkewers)
% Inputs
%   M - 2d matrix of HSI data (p x N)
%   q - Number of endmembers to find
%   numSkewers - Number of "skewer" vectors to project data onto.
% Outputs
%   U - Recovered endmembers (p x N)

[p, N] = size(M);

% Remove data mean
u = mean(M.').';
M = M - repmat(u, 1, N);

% Generate skewers
skewers = randn(p, numSkewers);

votes = zeros(N, 1);
for kk=1:numSkewers
    % Project all the data onto a skewer
    tmp = abs(skewers(:,kk).'*M);
    [val, idx] = max(tmp);
    votes(idx) = votes(idx) + 1;
end

[val, idx] = sort(votes, 'descend');
U = M(:, idx(1:q));


