function normalizedU = hyperConvexHullRemoval(U,wavelengths)
%HYPERCONVEXHULLREMOVAL Performs spectral normalization via convex hull removal 
%
% Usage
%   [ normalizedU ] = hyperConvexHullRemoval( U, wavelengths )
%
% Inputs
%   U - 2D HSI data (p x q)
%   wavelengths - Wavelength of each band (p x 1)
%
% Outputs
%   normalizedU - Data with convex hull removed (p x q)
%
% Author
%   Luca Innocenti
%
% References
%   Clark, R.N. and T.L. Roush (1984) Reflectance Spectroscopy: Quantitative
% Analysis Techniques for Remote Sensing Applications, J. Geophys. Res., 89,
% 6329-6340. 

% Metadata and formatting
wavelengths = wavelengths(:);
p = length(wavelengths);
q = size(U,2);
U = U.';

U(:,1) = 0;
U(:,420) = 0;

normalizedU = zeros(q,420);

% The algorithm
for s = 1:q,
    rifl = U(s,:);
    k = convhull(wavelengths,rifl');
    c = [rifl(k); wavelengths(k)'];
    d = sortrows(c',2);
    
    xs = d(:,2);
    ys = d(:,1);
    [xsp, idx] = unique(xs);
    ysp = ys(idx);
    rifl_i = interp1(xsp,ysp,wavelengths');
    
    for t = 1:420,
        if rifl_i(t) ~= 0
            normalizedU(s,t) = rifl(t)/rifl_i(t);
        else
            normalizedU(s,t) = 1;
        end
    end
end

normalizedU = normalizedU.';
