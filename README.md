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

## Planned Features

Future development priorities include:
- Joint Affine Matched Filter
- Enhanced Matched Filter with signature statistics
- RAF-SAM (Improved Spectral Angle Mapper)
- ELM (Empirical Line Method) for radiance-to-reflectance conversion
- Advanced covariance matrix inversion methods
- Quadratic Detector
- Additional unmixing algorithms (SMACC, AMEE, NFINDR)
- Antonia Plaza's FastPPI
- Joshua Broaderwater's hybrid detectors

## Citation

If you use this toolbox in your research, please cite:

```bibtex
@Misc{matlab_hsi_toolbox,
    author    = {Isaac Gerg},
    title     = {Open Source MATLAB Hyperspectral Toolbox},
    howpublished = {\url{https://github.com/isaacgerg/matlabHyperspectralToolbox}},
    year      = {2006--2022}
}
```

## License

[License information to be added]

## Contributing

Derivative works must include the original citation. New contributors should add their names to the author line while maintaining the original author information.

## Contact

[Contact information to be added]
