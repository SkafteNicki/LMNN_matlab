function [l,f] = least(y)
%% Description
% Finds the least frequent observation from a vector y (implements the
% oppesit operation of mode(...))
% INPUT
%   - y: N vector with observations
% OUTPUT
%   - l: the least frequent observation
%   - f: the frequency of the least frequent observation
%% Function
u = unique(y);
n = histc(y,u);
[~,i] = min(n);
l = u(i);
f = n(i);
end