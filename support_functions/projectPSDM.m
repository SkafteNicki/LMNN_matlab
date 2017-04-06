function P = projectPSDM(M, tol)
%% Description
% projectPSDM projects the matrix M onto the cone of positive semi-definite
% matrices i.e matrices with no negative eigenvalues.
% INPUT
%   - M: a d x d square matrix
% OUTPUT
%   - P: a d x d square matrix, which is positive semi-definite
%
%% Function
% Find eigenvectors and eigenvalues
[V, D] = eig(M);
if(0 <= min(D(:))) % Check if not already positive semi-definite
    P = M;
else
    % Set negative eigenvalues to 0 or a small number
    D = diag(D);
    D(D<=0) = tol;
    % Do the projection
    P = real(V)*real(diag(D))*real(V)';
end
end
