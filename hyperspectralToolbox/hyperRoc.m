function [pd,fa] = hyperRoc(x)

x = x(:);

numTs = 100;
pd = linspace(0,1,numTs);
for k=1:numTs
    fa(k) = sum(x>=pd(k));
end

N = length(x);
fa = fa./N;
pd = 1-pd;