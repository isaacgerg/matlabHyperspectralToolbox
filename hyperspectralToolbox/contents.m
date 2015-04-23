% Matlab Hyperspectral Toolbox
% Copyright 2008-2012 Isaac Gerg
%
% -------------------------------------------------------------------------
% A Note on Notation
%   Hyperspectral data is often expressed many ways to better describe the 
% mathematical handling of the data; mainly as a vector of pixels when 
% referring to the data in a space or a matrix of pixels when referring to 
% data as an image. 
%   For consistency, a common notation is defined to 
% differentiate these concepts clearly. Hyperspectral data examined like an 
% image will be defined as a matrix Mm×n×p of dimension m × n × p where m 
% is defined as the number of rows in the image, n is defined as the 
% number of columns in the image, and p is defined as the number of bands 
% in the image. Therefore, a single element of such an image will be 
% accessed using Mi,j,k and a single pixel of an image will be accessed 
% using Mi,j,: Hyperspectral data formed as a vector of vectors 
% (i.e. 2D matrix) is defined as M(m·n)×p of dimension (m· n)×p. 
% A single element is accessed using Mi,j and a single pixel is 
% accessed using M:,j . Notice the multi-element notation is consistent 
% with MatlabTM this is intentional.
%   The list below provides a summary of the notation convention used 
% throughout this code.
%
% M Data matrix. Defined as an image of spectral signatures or vectors:
%   Mm×n×p. Or, defined as a long vector of spectral signatures:
%   M(m·n)×p.
% N The total number of pixels. For example N = m · n.
% m Number of rows in the image.
% n Number of columns in the image.
% p Number of bands.
% q Number of classes / endmembers.
% U Matrix of endmembers. Each column of the matrix represents an
%   endmember vector.
% b Observation vector; a single pixel.
% x Weight vector. A matrix of weight vectors forms an abundance
%   map.
%
% -------------------------------------------------------------------------
% Dependencies
% FastICA - http://www.cis.hut.fi/projects/ica/fastica/code/dlcode.shtml
%
% -------------------------------------------------------------------------
% Functions
%
% Reading/Writing Data Files
%   hyperReadAvirisRfl - Reads AVIRIS .rfl files
%   hyperReadAvirisSpc - Read AVIRIS .spc files
%   hyperReadAsd - Reads ASD Fieldspec files. (.asd, .000, etc)
%
% Data Formatting
%   hyperConvert2D - Converts data from a 3D HSI data cube to a 2D matrix
%   hyperConvert3D - Converts data from a 2D matrix to a 3D HSI data cube
%   hyperNormalize - Normalizes data to be in range of [0,1]
%   hyperConvert2Jet - Converts a 2D matrix to jet colormap values
%   hyperResample - Resamples hyperspectral data to new wavelength set
%
% Unmixing
%   hyperAtgp - ATGP algorithm
%   hyperIcaEea - ICA-Endmember Extraction Algorithm
%   hyperIcaComponentScores - Computes ICA component scores for relevance
%   hyperVca - Vertex Component Analysis
%   hyperPPI - Pixel Purity Index
%
% Target Detection
%   hyperACE - Adaptive cosine/coherent estimator
%   hyperGLRT - Generalized liklihood ratio test
%   hyperHUD - Hybrid instructured detector
%   hyperAMSD - Adaptive matched subspace detector
%   hyperMatchedFilter - Matched filter
%   hyperOsp - Orthogonal subspace projection
%   hyperCem - Constrained energy minimization
%   hyperPlmf - PCA local matched filter
%   hyperRmf - Regularized match filter
%
% Material Count Estimation
%   hyperHfcVd - Computes virtual dimensionality (VD) using HFC method
%
% Data Conditioning
%   hyperPct - Pricipal component transform
%   hyperMnf - Minimum noise fraction
%   hyperDestreak - Destreaking algorithm
%
% Abundance Map Generation
%   hyperUcls - Unconstrained least squares
%   hyperNnls - Non-negative least squares
%   hyperFcls - Fully constrains least squares
%
% Spectral Measuring
%   hyperSam - Spectral Angle Mapper
%   hyperSid - Spectral Information Divergence
%   hyperNormXCorr - Normalized Cross Correlation
%
% Miscellaneous
%   hyperMax2d - Finds the max value and corresonding position in a matrx
%
% Sensor Specific
%   hyperGetHymapWavelengthsNm - Returns list of Hymap wavelengths
%
% Statistics
%   hyperCov - Sample covariance matrix estimator
%   hyperCorr - Sample autocorrelation matrix estimator
%
% Demos
%   hyperDemo - General toolbox usage
%   hyperDemo_detectors - Target detection algorithms
%   hyperDemo_RIT_data - RIT target detection blind test
%   hyperDemo_ASD_reader - Reads ASD Fieldspec files



