function [results] = hyperHud(M, B, S)
% HYPERHUD Performs the hybrid unstructured detector (HUD) algorithm
%   Performs the hybrid unstructured detector algorithm for target
% detection.
%
% Usage
%   [results] = hyperHud(M, B, S)
% Inputs
%   M - 2d matrix of HSI data (p x N)
%   B - 2d matrix of background endmembers (p x q)
%   S - 2d matrix of target endmembers (p x #target_sigs)
% Outputs
%   results - vector of detector output (N x 1)
%
% References
%   J Broadwater & R Chellappa.  "Hybrid Detectors for Subpixel Targets."
% IEEE PAMI. Vol 29. No 11. November 2007.


[p, N] = size(M);
% Remove mean from data
u = mean(M.').';
M = M - repmat(u, 1, N);
S = S - repmat(u, 1, size(S,2));

numTargets = size(S,2);
%sigma = 1e-5;
E = [S B];
%E = [sigma*E; ones(1,size(E,2))];
q = size(E, 2);

R_hat = (M*M.')/N;
G = inv(R_hat);

results = zeros(1, N);

R = ones(q,1);
P = R - 1;
% TODO - put in the whitened version of fcls
a_hat_tmp = hyperNnls(M, E);
%a_hat_tmp = hyperFcls(M, E);
for k=1:N
    x = M(:,k);        
    a_hat = a_hat_tmp(:,k);
    % Take the top r values from a_hat where r is number of targets.  We
    % are only interested in the abundances for the targets.  From J
    % Broadwater email 11/17/09.
    a_hat = a_hat(1:numTargets);
% %    x = [sigma*x; 1];
%     % FCLS optimzation
%     lambda = zeros(q,1);
%     aPrev = lambda;
%     for kk=1:100
%         a_hat = inv(E.'*G*E)*E.'*G*x - inv(E.'*G*E)*lambda;
%         norm(a_hat-aPrev)
%         lambda = E.'*G*(x-E*a_hat);
%         idx = find(a_hat>0);
%         P(idx) = 1;
%         R(idx) = 0;
%         aPrev = a_hat;
%     end  
%     a_hat = a_hat(1:numTargets);
    results(k) = (x.'*G*S*a_hat) / (x.'*G*x);
end