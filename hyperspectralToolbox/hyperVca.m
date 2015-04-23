function [ U, indicies, snrEstimate ] = hyperVca( M, q )
%HYPERVCA Vertex Component Analysis algorithm
%   hyperVca performs the vertex component analysis algorithm to find pure
% pixels in an HSI scene
%
% Usage
%   [ U, indicies, snrEstimate ] = hyperVca( M, q )
% Inputs
%   M - HSI data as 2D matrix (p x N).
%   q - Number of endmembers to find.
% Outputs
%   U - Matrix of endmembers (p x q).
%   indicies - Indicies of pure pixels in U
%   snrEstimate - SNR estimate of data [dB]
%
% References
%   J. M. P. Nascimento and J. M. B. Dias, “Vertex component analysis: A 
% fast algorithm to unmix hyperspectral data,” IEEE Transactions on 
% Geoscience and Remote Sensing, vol. 43, no. 4, apr 2005.

%Initialization.
N = size(M, 2);
L = size(M, 1);

% Compute SNR estimate.  Units are dB.
% Equation 13.
% Prefer using mean(X, dim).  I believe this should be faster than doing
% mean(X.') since matlab doesnt have to worry about the matrix
% transposition.
rMean = mean(M, 2);
RZeroMean = M - repmat(rMean, 1, N);
% This is essentially doing PCA here since we have zero mean data.
%  RZeroMean*RZeroMean.'/N -> covariance matrix estimate.
[Ud, Sd, Vd] = svds(RZeroMean*RZeroMean.'/N, q);
Rd = Ud.'*(RZeroMean);
P_R = sum(M(:).^2)/N;
P_Rp = sum(Rd(:).^2)/N + rMean.'*rMean;
SNR = abs(10*log10( (P_Rp - (q/L)*P_R) / (P_R - P_Rp) ));
snrEstimate = SNR;

fprintf('SNR estimate [dB]: %g\n', SNR);

% Determine which projection to use.
SNRth = 15 + 10*log(q) + 8;
%SNRth = 15 + 10*log(q);
if (SNR > SNRth) 
    d = q;
    [Ud, Sd, Vd] = svds((M*M.')/N, d);
    Xd = Ud.'*M;
    u = mean(Xd, 2);
    Y =  Xd ./ repmat( sum( Xd .* repmat(u,[1 N]) ) ,[d 1]);
    %for j=1:N
    %    Y(:,j) = Xd(:,j) / (Xd(:,j).'*u);
    %end
else
    d = q-1;
    r_bar = mean(M.').';
    Ud = pca(M, d);
    %Ud = Ud(:, 1:d);
    R_zeroMean = M - repmat(r_bar, 1, N);
    Xd = Ud.' * R_zeroMean;
    % Preallocate memory for speed.
    c = zeros(N, 1);
    for j=1:N
        c(j) = norm(Xd(:,j));
    end
    c = repmat(max(c), 1, N);
    Y = [Xd; c];
end
e_u = zeros(q, 1);
e_u(q) = 1;
A = zeros(q, q);
% idg - Doesnt match.
A(:, 1) = e_u;
I = eye(q);
k = zeros(N, 1);
for i=1:q
    w = rand(q, 1);
    % idg - Oppurtunity for speed up here.
    tmpNumerator =  (I-A*pinv(A))*w;
    %f = ((I - A*pinv(A))*w) /(norm( tmpNumerator ));
    f = tmpNumerator / norm(tmpNumerator);

    v = f.'*Y;
    k = abs(v);
    [dummy, k] = max(k);
    A(:,i) = Y(:,k);
    indicies(i) = k;
end
if (SNR > SNRth)
    U = Ud*Xd(:,indicies);
else
    U = Ud*Xd(:,indicies) + repmat(r_bar, 1, q);
end
return;

function [U] = pca(X, d)
    N = size(X, 2);
    xMean = mean(X, 2);
    XZeroMean = X - repmat(xMean, 1, N);     
    [U,S,V] = svds((XZeroMean*XZeroMean.')/N, d);
return;
