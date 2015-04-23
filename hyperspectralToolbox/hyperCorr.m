function [R] = hyperCorr(M)
% HYPERCORR Computes the sample autocorrelation matrix
% hyperCorr compute the sample autocorrelation matrix of a 2D matrix.
%
% Usage
%   [R] = hyperCorr(M)
%
% Inputs
%   M - 2D matrix 
% Outputs
%   R - Sample autocorrelation matrix


[p, N] = size(M);

R = (M*M.')/N;
