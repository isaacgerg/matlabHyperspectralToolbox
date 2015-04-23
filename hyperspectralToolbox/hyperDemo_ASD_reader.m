clear; close all; clc; dbstop if error;

%--------------------------------------------------------------------------
% This file demonstrates how to read data from an ASD Fieldspec 
% spectrometer.
%--------------------------------------------------------------------------
% Parameters
inputFilename1 = 'data\spectra\sample00000.asd';
inputFilename2 = 'data\spectra\gypsum.000';
%--------------------------------------------------------------------------

% Read from a file containing a reflectance signature
[spectraReflectance, lambda] = hyperReadAsd(inputFilename2);    
% Display results
figure; plot(lambda,spectraReflectance); grid on;
    title('Signature'); xlabel('Lambda [nm]'); ylabel('Reflectance [0,1]');
    axis([350,2500,0,1]);
    
% Read from a file containing digital number (DN) signature
[measuredSpectra, lambda, referenceSpectra] = hyperReadAsd(inputFilename1);    
% Display results
figure; plot(lambda,measuredSpectra); grid on;
    title('Measured Signature'); xlabel('Lambda [nm]'); 
    ylabel('Digital Number');    
figure; plot(lambda,referenceSpectra); grid on;
    title('Reference Signature'); xlabel('Lambda [nm]'); 
    ylabel('Digital Number');      
reflectance = measuredSpectra./referenceSpectra;
figure; plot(lambda,reflectance); grid on;
    title('Dervied Reflectance'); xlabel('Lambda [nm]'); 
    ylabel('Reflectance [0,1]');    
    axis([350,2500,0,1]);