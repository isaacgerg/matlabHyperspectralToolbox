# MATLAB Hyperspectral Toolbox

A comprehensive MATLAB toolbox for hyperspectral image processing and analysis, providing state-of-the-art exploitation algorithms for research and educational purposes.

## Overview

This toolbox was originally developed to support research for my Master's thesis "[An Evaluation of Three Endmember Extraction Algorithms: ATGP, ICA-EEA, and VCA](https://etda.libraries.psu.edu/catalog/8265)" under the advisorship of Dr. Tim Kane at Penn State's Remote Sensing and Space Systems Lab. The work has since evolved into a broader collection of hyperspectral analysis tools that continues to serve the remote sensing research community.

## Features

The toolbox includes implementations of various hyperspectral exploitation algorithms:

### Core Capabilities
- Target Detection Algorithms
  - RX Detector
  - Matched Filter
  - ACE (Adaptive Cosine Estimator)
  - Various hybrid detectors
- Material Abundance Mapping
  - FCLS (Fully Constrained Least Squares)
  - UCLS (Unconstrained Least Squares)
  - NNLS (Non-Negative Least Squares)
- Spectral Unmixing
  - VCA (Vertex Component Analysis)
  - ICA-EEA (Independent Component Analysis - Endmember Extraction Algorithm)
  - ATGP (Automated Target Generation Process)
- Data Processing
  - MNF (Minimum Noise Fraction)
  - PCA (Principal Component Analysis)
  - Spectral Angle Mapper (SAM)
  - Spectral Information Divergence (SID)
- Visualization Tools
  - 2D/3D data conversion
  - Colormap generation
  - Advanced plotting functions

### File Support
- AVIRIS (.rfl) reading
- ASD FieldSpec file reading
- ENVI signature import
- SPECPR file format support
- Various hyperspectral data format conversions

## Dependencies

- MATLAB (version requirements TBD)
- [FastICA Toolbox](https://research.ics.aalto.fi/ica/fastica/) - Required for certain unmixing functions
  - Add to MATLAB's path using `addpath('path_to_fastica')`

## Installation

1. Clone the repository:
```bash
git clone https://github.com/isaacgerg/matlabHyperspectralToolbox.git
```

2. Add the toolbox to your MATLAB path:
```matlab
addpath('path_to_toolbox')
```

3. Install FastICA if needed for unmixing functionality

## Usage

The toolbox includes several demo scripts to help you get started:
- `hyperDemo.m` - General toolbox functionality
- `hyperDemo_detectors.m` - Target detection algorithms
- `hyperDemo_RIT_data.m` - Working with RIT dataset
- `hyperDemo_ASD_reader.m` - Reading ASD FieldSpec data

## Function Documentation

### Target Detection Algorithms

#### hyperAce.m (Adaptive Cosine/Coherence Estimator)
Implements the ACE detector which normalizes the matched filter by both the background clutter energy and target energy:
```
ACE(x) = (s^T Σ^(-1) x)^2 / ((s^T Σ^(-1) s)(x^T Σ^(-1) x))
```
where s is the target signature, x is the test pixel, and Σ is the background covariance matrix.

#### hyperAmsd.m (Adaptive Matched Subspace Detector)
Implements a GLRT detector for signals in subspace interference:
```
AMSD = (x^T P_B⊥ x - x^T P_(B,S)⊥ x) / (x^T P_(B,S)⊥ x)
```
where P_B⊥ is the projection onto the orthogonal complement of the background subspace.

#### hyperAtgp.m (Automated Target Generation Process)
Implements an orthogonal projection-based endmember extraction:
1. Finds pixel with largest magnitude
2. Projects data onto space orthogonal to found pixel
3. Repeats until desired number of endmembers found

#### hyperGlrt.m (Generalized Likelihood Ratio Test)
Implements the GLRT detector:
```
GLRT(x) = (s^T Σ^(-1) x)^2 / (s^T Σ^(-1) s)
```
Similar to ACE but without normalization by the pixel energy.

### Dimensionality Reduction & Whitening

#### hyperMnf.m (Minimum Noise Fraction)
Implements noise-adjusted principal components:
1. Estimates noise covariance Σn
2. Whitens data using noise covariance
3. Performs PCA on whitened data
```
MNF = eig(Σn^(-1/2) Σ Σn^(-1/2))
```

#### hyperNapc.m (Noise-Adjusted Principal Components)
Similar to MNF but uses a different noise estimation approach.

#### hyperWhiten.m 
Implements data whitening:
```
x_white = Σ^(-1/2) x
```
where Σ^(-1/2) is computed via eigendecomposition.

### Spectral Unmixing

#### hyperFcls.m (Fully Constrained Least Squares)
Solves the constrained optimization problem:
```
min ||Ax - b||^2 subject to sum(x) = 1 and x ≥ 0
```
where A contains endmember signatures and x contains abundances.

#### hyperNnls.m (Non-Negative Least Squares)
Solves:
```
min ||Ax - b||^2 subject to x ≥ 0
```

#### hyperUcls.m (Unconstrained Least Squares)
Solves the basic least squares problem:
```
min ||Ax - b||^2
```

#### hyperVca.m (Vertex Component Analysis)
Imple
