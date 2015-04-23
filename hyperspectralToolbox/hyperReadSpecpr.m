function [ records, spectra, rawSpectra ] = hyperReadSpecpr( filename )
%HYPERREADSPECPR Reads USGS Specpr files.
%   hyperReadSpecpr reads USGS Specpr files. 
% 
% Usage
%   [ records, spectra, rawSpectra ] = hyperReadSpecpr( filename )
% Inputs
%   filename - Input filename
% Outputs
%   records - Individual records
%   spectra - The spectra post-processed
%   rawSpectra - The raw spectra
%
% References
%   http://speclab.cr.usgs.gov/specpr-format.html.
dbstop if error;
f = fopen(filename, 'r');
if (f == -1)
    error(sprintf('Failed to open file: %s'), filename);
end

% Ignore the first record.
r = uint32(fread(f, 1536, 'uint8'));

firstTime = 1;
records = {};
spectra = [];
rawSpectra = {};
numRawSpectra = 0;
numRecords = 0;

done = 0;
while (not(done))
    r = uint32(fread(f, 1536/4, 'uint32', 'ieee-be'));
    if (length(r) == 0)
        break;
    end
    numRecords
    r = swapbytes(r);
    r = typecast(r, 'uint8');
    % First two bits of file.  I am making this verbose here so it is clear what I
    % am doing.
    firstTwoBits = dec2bin(bitand(r(4), 3));
    
    %  Parse first two bits.
    if (firstTwoBits == '10')
        % This is a text record. Skip.
        numRecords = numRecords + 1;
    elseif (firstTwoBits == '0')
        % This is an actual (initial) data record.
        if (not(firstTime))
            numRecords = numRecords+1;
            records{record.irecno} = record;
        end
        record = [];
        data = [];
        firstTime = 0;
        iband = int32(zeros(2, 1));
        record.ititl = char(r(5:44)).';
        record.usernm = char(r(45:52)).';
        iscta = typecast(r(53:56), 'int32');
        isctb = typecast(r(57:60), 'int32');
        jdatea = typecast(r(61:64), 'int32');
        jdateb = typecast(r(65:68), 'int32');
        istb = typecast(r(69:72), 'int32');
        isra = typecast(r(73:76), 'int32');
        isdec = typecast(r(77:80), 'int32');
        record.itchan = swapbytes(typecast(r(81:84), 'int32'));
        irmas = typecast(r(85:88), 'int32');
        revs = typecast(r(89:92), 'int32');
        iband(1) = typecast(r(93:96), 'int32');
        iband(2) = typecast(r(97:100), 'int32');
        record.irwav = swapbytes(typecast(r(101:104), 'int32'));
        record.irespt = swapbytes(typecast(r(105:108), 'int32'));
        record.irecno = swapbytes(typecast(r(109:112), 'int32'));
        itpntr = typecast(r(113:116), 'int32');
        ihist = char(r(117:176)).';
        mhist = char(r(177:472)).';
        nruns = typecast(r(473:476), 'int32');
        siangl = typecast(r(477:480), 'int32');
        seangl = typecast(r(481:484), 'int32');
        sphase = typecast(r(485:488), 'int32');
        iwtrns = typecast(r(489:492), 'int32');
        itimch = typecast(r(493:496), 'int32');
        xnrm = typecast(r(497:500), 'int32');
        scatim = typecast(r(501:504), 'int32');
        timint = typecast(r(505:508), 'int32');
        tempd = typecast(r(509:512), 'int32');
        data = swapbytes(typecast(r(513:1536), 'single'));
        % Remove null data samples. Set to zero instead of -1.23e34.
        data(find(data < -1e34)) = 0;
        record.data = data;
    elseif (firstTwoBits == '1')
        % Continuation of data values.
        cData = swapbytes(typecast(r(5:1536), 'single')); 
        cData(find(cData < -1e34)) = 0;
        data = [data; cData];
        record.data = data;
    else
        numRecords = numRecords + 1;
    end
end

% Convert to an array of signatures.
% Resample to model AVIRIS sensor
high = 2.40;
low = 0.4;
numBands = 224;
%d.data = sortrows(d.data, 1);
%[q, w, r ]= unique(d.data(:,1));
%d.data = d.data(w, :);
%lambda = d.data(:, 1);
%reflectance = d.data(:, 2);
s = length(records);
numSpectra = 0;
for q=1:s
    if (isempty(records{q}))
        continue;
    end
    if (records{q}.irwav == 0)
        continue;
    end

    if (not(isempty(strfind(records{q}.ititl, 'error'))))
        continue;
    end
    if (not(isempty(strfind(records{q}.ititl, 'Error'))))
        continue;
    end
    if (not(isempty(strfind(records{q}.ititl, 'Bandpass'))))
        continue;
    end
    if (not(isempty(strfind(records{q}.ititl, 'Wavelengths'))))
        continue;
    end    
    % Find wavelengths
    if (isempty(records{records{q}.irwav}))
        continue;
    end
    lambdas = records{records{q}.irwav}.data;
    spectrum = records{q}.data;
    if (length(lambdas) ~= length(spectrum))
        fprintf('Error %d !!!\n', q);
        continue;
    end
    numRawSpectra = numRawSpectra + 1;
    rawSpectra{numRawSpectra}.name = records{q}.ititl;
    rawSpectra{numRawSpectra}.wavelengths = lambdas;
    rawSpectra{numRawSpectra}.reflectance = spectrum;
    goodIdx = find(lambdas > 0);
    lambdas = lambdas(goodIdx);
    spectrum = spectrum(goodIdx);
    % Ensure we have proper lower and upper bounds.
    if (lambdas(1) > low)
        %fprintf('Bad file: Lower wavelength value missing.');        
        lambdas = [low; lambdas];
        spectrum = [spectrum(1); spectrum];
    end
    if (lambdas(end) < high)
        %fprintf('Bad file: Upper wavelength value missing.\n');        
        %d.data = [];
        %fclose(fid);
        %return;
        lambdas = [lambdas; high];
        spectrum = [spectrum; spectrum(end)];
    end
    % Resample
    records{q}.ititl
    ts = timeseries(spectrum, lambdas);
    inc = (high-low) / (numBands-1);
    c = resample(ts, [low:inc:high], 'zoh');
    numSpectra = numSpectra + 1;
    spectra(numSpectra).data = [c.time c.data [1:numBands].'];
    spectra(numSpectra).name = records{q}.ititl; 
end

return;