# MATLAB Hyperspectral Toolbox

This toolbox was developed in support of "An Evaluation of Three Endmember Extraction Algorithms: ATGP, ICA-EEA, and VCA," https://etda.libraries.psu.edu/catalog/8265.

**Update Feb 15, 2019**

This software is no longer being maintained.  The following are works containing parts of this toolbox:

* http://davidkun.github.io/HyperSpectralToolbox/ 
* PySptools http://pysptools.sourceforge.net/

~Isaac

The open source Matlab Hyperspectral Toolbox is a matlab toolbox containing various hyperspectral exploitation algorithms. The toolbox is meant to be a concise repository of current state-of-the-art (2008) exploitation algorithms for learning and research purposes. The toolbox (will) include(s) functions for:

* Target detection
* Material abundance map (MAM) generation
* Spectral unmixing
* Automated processing
* Change detection
* Visualization
* Reading / writing files (.rfl, .asd, ect)

FastICA can be downloaded here. FastICA is used in a few of the functions in the toolbox. Remember to add the FastICA toolbox to Matlab's path table. You can do this using the addpath function.

These are listed below in order of my priority of implementing them.
* (Joint) Affine Matched filter. Link.
* Generalization of matched filter which includes signature statistics. See equation 1 of this.
* RAF-SAM, an improvement to SAM from: Improving the Classification Precision of Spectral Angle Mapper
ELM for radiance to reflectance conversion (http://www.cis.rit.edu/files/197_SPIE_2005_Grimm.pdf)
* Covariance matrix inversion methods (e.g. Dominant Mode Rejection)
* Quadratic Detector
* SMACC
* AMEE
* NFINDR
* Antonia Plaza's FastPPI
* Joshua Broaderwater's hybrid detectors (HUD, etc)
* Variations on ACE - e.g. adaptive covariance estimated ACE, etc
