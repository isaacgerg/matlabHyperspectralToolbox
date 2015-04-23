function [x, y, val] = hyperMax2d(mat)
% HYPERMAX2D Finds the max value and position in a matrix
%
% Usage
%   [x, y, val] = hyperMax2d(mat)
% Inputs
%   mat - Input matrix
% Outputs
%   x - X position of maximum value
%   y - Y position of maximum value
%   val - Maximum value in matrix

[dum, y] = max(mat);
[val, y] = max(dum);
[dum, x] = max(mat(:,y));