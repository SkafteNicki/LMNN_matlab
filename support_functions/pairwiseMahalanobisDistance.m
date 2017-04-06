function D = pairwiseMahalanobisDistance(X, Y, M)
%% Description
% Compute mahalanobis distances between all pair of vectors
% INPUT
%   - Xtrain: a n1 x d matrix, where each row is a obeservation of
%   dimension d in the training set
%   - Xtest: a n2 x d matrix, where each row is a observation of dimension
%   d in the test set
%   - M: a d x d matrix which weights the distance measure between
%   obeservations
% OUTPUT
%   - D: n1 x n2 matrix, where element (i,j) is the distance between
%   Xtest(i,:) and Xtrain(j,:)
%% Function
L = chol(M,'lower'); % compute M = L'*L;
LX = X*L; % Project X
LY = Y*L; % Project Y
% Compute ||x-y||^2_2 = <x,x> + <y,y> - 2*<x,y> for all pairs
D = real(sqrt(bsxfun(@plus,dot(LX,LX,2),bsxfun(@minus,dot(LY,LY,2)',2*LX*LY'))));
end

% ||x-y||^2_M   = (x-y)'*M*(x-y) 
%               = (x'-y')*M*(x-y)
%               = x'*M*x - x'*M*y - y'*M*x + y'*M*y
                