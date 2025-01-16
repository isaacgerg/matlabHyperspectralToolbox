# MATLAB Hyperspectral Toolbox - Function Documentation

## Target Detection Algorithms

### hyperAce.m (Adaptive Cosine/Coherence Estimator)
Implements the ACE detector which normalizes the matched filter by both the background clutter energy and target energy:
```
ACE(x) = (s^T Σ^(-1) x)^2 / ((s^T Σ^(-1) s)(x^T Σ^(-1) x))
```
where s is the target signature, x is the test pixel, and Σ is the background covariance matrix.

### hyperAmsd.m (Adaptive Matched Subspace Detector)
Implements a GLRT detector for signals in subspace interference:
```
AMSD = (x^T P_B⊥ x - x^T P_(B,S)⊥ x) / (x^T P_(B,S)⊥ x)
```
where P_B⊥ is the projection onto the orthogonal complement of the background subspace.

### hyperAtgp.m (Automated Target Generation Process)
Implements an orthogonal projection-based endmember extraction:
1. Finds pixel with largest magnitude
2. Projects data onto space orthogonal to found pixel
3. Repeats until desired number of endmembers found

### hyperGlrt.m (Generalized Likelihood Ratio Test)
Implements the GLRT detector:
```
GLRT(x) = (s^T Σ^(-1) x)^2 / (s^T Σ^(-1) s)
```
Similar to ACE but without normalization by the pixel energy.

## Dimensionality Reduction & Whitening

### hyperMnf.m (Minimum Noise Fraction)
Implements noise-adjusted principal components:
1. Estimates noise covariance Σn
2. Whitens data using noise covariance
3. Performs PCA on whitened data
```
MNF = eig(Σn^(-1/2) Σ Σn^(-1/2))
```

### hyperNapc.m (Noise-Adjusted Principal Components)
Similar to MNF but uses a different noise estimation approach.

### hyperWhiten.m 
Implements data whitening:
```
x_white = Σ^(-1/2) x
```
where Σ^(-1/2) is computed via eigendecomposition.

## Spectral Unmixing

### hyperFcls.m (Fully Constrained Least Squares)
Solves the constrained optimization problem:
```
min ||Ax - b||^2 subject to sum(x) = 1 and x ≥ 0
```
where A contains endmember signatures and x contains abundances.

### hyperNnls.m (Non-Negative Least Squares)
Solves:
```
min ||Ax - b||^2 subject to x ≥ 0
```

### hyperUcls.m (Unconstrained Least Squares)
Solves the basic least squares problem:
```
min ||Ax - b||^2
```

### hyperVca.m (Vertex Component Analysis)
Implements VCA endmember extraction by:
1. Projecting data onto random vector
2. Finding extreme projections
3. Iterating with orthogonal projections

## Similarity Measures

### hyperCorr.m
Computes Pearson correlation coefficient:
```
ρ = cov(x,y) / (σx σy)
```

### hyperNormXCorr.m (Normalized Cross Correlation)
Computes normalized cross correlation:
```
NCC = (x^T y) / (||x|| ||y||)
```

### hyperSam.m (Spectral Angle Mapper)
Computes spectral angle:
```
θ = arccos((x^T y) / (||x|| ||y||))
```

### hyperSid.m (Spectral Information Divergence)
Computes information theoretic measure of spectral similarity using relative entropy.

## Statistical Detection

### hyperHud.m (Hybrid Unstructured Detector)
Combines structured (matched filter) and unstructured (RX) detectors:
```
HUD = αRX + (1-α)MF
```

### hyperRxDetector.m (Reed-Xiaoli Detector)
Implements anomaly detection:
```
RX(x) = (x-μ)^T Σ^(-1) (x-μ)
```
where μ is the mean and Σ is the covariance.

## Preprocessing

### hyperConvexHullRemoval.m
Removes pixels inside the convex hull of selected vertices.

### hyperDestreak.m
Removes vertical striping artifacts in push-broom sensors.

### hyperNormalize.m
Normalizes spectra to unit length:
```
x_norm = x / ||x||
```

### hyperResample.m
Resamples spectra to new wavelength positions using interpolation.

## Independent Component Analysis

### hyperIcaEea.m (ICA Endmember Extraction)
Uses FastICA to find statistically independent endmembers:
1. Reduces dimensionality via PCA
2. Applies ICA to find independent components
3. Projects back to original space

### hyperIcaComponentScores.m
Computes abundance maps from ICA components.

## File I/O

### hyperReadAsd.m
Reads ASD FieldSpec spectrometer files.

### hyperReadAvirisRfl.m
Reads AVIRIS reflectance data.

### hyperReadSpecpr.m
Reads SPECPR format spectral library files.

### hyperGetEnviSignature.m
Reads spectral signatures from ENVI spectral libraries.

## Visualization

### hyperConvert2Colormap.m
Converts hyperspectral image to RGB using dimensionality reduction.

### hyperConvert2d.m / hyperConvert3d.m
Converts between 2D (samples × bands) and 3D (rows × cols × bands) formats.

### hyperImagesc.m / hyperImshow.m
Enhanced visualization of hyperspectral data cubes.

### hyperMax2d.m
Finds local maxima in 2D arrays.

## Performance Evaluation

### hyperPpi.m (Pixel Purity Index)
Computes measure of pixel spectral purity through repeated projections.

### hyperRoc.m (Receiver Operating Characteristic)
Computes ROC curves for detector performance evaluation.
