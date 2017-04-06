function invM = matInv(M)
%% Description
% matInv use the cholesky decomposition of the positive semi-definite
% matrix M to find its inverse
% INPUT
%   - M: a d x d square positive semi-definite matrix
% OUTPUT
%   - invM: a d x d square metrix which is the inverse of M (also positive
%   semi-definite)
%% Function
invL = inv(chol(M));
invM = invL*invL';
end