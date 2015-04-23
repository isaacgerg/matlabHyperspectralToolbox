function [measuredSpectrum, lambda, referenceSpectrum] = hyperReadAsd(filename)
% HYPERREADASD Reads spectra from an ASD Fieldspec spectrometer (e.g. .asd)
%   Reads in the measured and reference spectra from an ASD Fieldspec
% spectrometer. If two output arguments are specified, hyperReadAsd assumes
% the file contains reflectance.  If three output arguments are specified,
% hyperReadAsd assumes the file contains measured and reference spectra
% in units of digital number (DN).
%  
% Usage
%   [measuredSpectrum, lambda] = hyperReadAsd(filename)
%   [measuredSpectrum, lambda, referenceSpectrum] = hyperReadAsd(filename)
% Inputs
%   filename - input filename (.asd)
% Outputs  
%   measuredSpectrum - measured spectrum of material (2151 x 1)    
%   lambda - wavelenghts of spectra (2151 x 1) 
%   referenceSpectrum (optional) - reference spectrum ("white" spectrum)
%
% Notes
%   Reflectance can be obtained by: 
%   reflectance = measuredSpectrum./referenceSpectrum;
%  
% Author
%   Luca Innocenti
%
% References
%   None

% Open the file
fid = fopen(filename, 'r');

if (2 == nargout)
    fseek(fid,484,'bof');
    measuredSpectrum = zeros(2151,1);
    lambda = zeros(2151,1);
    for i=1:2151,
        lambda(i) = 349 + i;
        measuredSpectrum(i) = fread(fid,1,'single');
    end    
    fclose(fid);
    return;
end

lungh_nota = 0;
fseek(fid, 0, 'bof');
% Get factory name
nome_ditta = char(fread(fid, 3, 'uint8')); %Factory Name
% Get note
note = char(fread(fid,157,'uint8'));

% count the note length string
tt = isstrprop(note,'alphanum');
for f=1:157,
    if tt(f) == 1
        lungh_nota = f;
        f = 157;
    end
end

%Extract Metadata from header file
%Not needed for spectrum

%Time of acquisition
fseek(fid, 160, 'bof');
sec_acq = fread(fid,1,'uint8'); %seconds
fseek(fid, 162, 'bof');
minsec_acq = fread(fid,1,'uint8'); %minutes
fseek(fid, 164, 'bof');
ora_acq = fread(fid,1,'uint8'); %hours
fseek(fid, 166, 'bof');
giorno_acq = fread(fid,1,'uint8'); %day
fseek(fid, 168, 'bof');
mese_acq = fread(fid,1,'uint8'); %month
fseek(fid, 170, 'bof');
anno_acq = fread(fid,1,'uint8'); %years from 1900
fseek(fid, 172, 'bof');
wday_acq = fread(fid,1,'uint8');
fseek(fid, 174, 'bof');
wdayy_acq = fread(fid,1,'uint16');
fseek(fid, 178, 'bof');
ver_programma = fread(fid,1,'uint8'); %software version
fseek(fid, 179, 'bof');
ver_file = fread(fid,1,'uint8'); %file version

%Data acquisition metadata
fseek(fid, 180, 'bof');
itime = fread(fid,1,'uint8');
fseek(fid, 181, 'bof');
dc_corr = fread(fid,1,'uint8');
fseek(fid, 182, 'bof');
dc_time = fread(fid,1,'uint32');
data_type = fread(fid,1,'uint8');
ref_time = fread(fid,1,'uint32');
ch1_wavel = fread(fid,1,'uint8');
wavel_step = fread(fid,1,'uint8');
data_format = fread(fid,1,'uint8');
old_dc_count = fread(fid,1,'uint8');
old_ref_count = fread(fid,1,'uint8');
old_sample_count = fread(fid,1,'uint8');
application = fread(fid,1,'uint8');
channels = fread(fid,1,'uint8');
fseek(fid, 425, 'bof');
dc_count = fread(fid,1,'uint16');
white_count = fread(fid,1,'uint16');
fseek(fid, 431, 'bof');
instrument_type = fread(fid,1,'uint8');
fseek(fid, 390, 'bof');
integration_time = fread(fid,1,'uint16');
fo = fread(fid,1,'uint16');
dc_correction_value = fread(fid,1,'uint16');
fseek(fid, 398, 'bof');
calibration = fread(fid,1,'uint16');

%Spectrum
referenceSpectrum = zeros(2151,1);
measuredSpectrum = zeros(2151,1);
lambda = zeros(2151,1);

for x=1:2151,
    lambda(x) = 349 + x;
end

fseek(fid, 484, 'bof');
for i = 1:2151,
    measuredSpectrum(i) = fread(fid,1,'double');

end

fseek(fid, 17712+lungh_nota, 'bof');
for i = 1:2151,
    referenceSpectrum(i) = fread(fid,1,'double');
end

% Test Fixture
% plot(lambda,referenceSpectrum)
% title ('Digital Number White Reference');
% xlabel('Lambda (nm)');
% ylabel('Digital Number');
% axis([350,2500,0,max(referenceSpectrum)])
% 
% 
% figure
% plot(lambda,measuredSpectrum)
% title ('Digital Number Sample');
% xlabel('Lambda (nm)');
% ylabel('Digital Number');
% 
% axis([350,2500,0,max(measuredSpectrum)])
% 
% reflectance = measuredSpectrum./referenceSpectrum;
% 
% figure
% plot(lambda, reflectance)
% title ('Reflectance');
% xlabel('Lambda (nm)');
% ylabel('Reflectance');
% 
% axis([350,2500,0,1]);

fclose(fid);
