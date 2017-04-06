function [ytest, nearest] = kNN(Xtrain, ytrain, Xtest, K, M)
%% Description
% kNN takes in a training set Xtrain with corresponding labels
% ytrain and a test set Xtest. Then it predicts the labels of Xtest using
% the K-nearest-neighbour algorithm.
% INPUT
%   - Xtrain: a n1 x d matrix, where each row is a obeservation of
%   dimension d in the training set
%   - ytrain: a n1 x 1 vector, with labels for the training set
%   - Xtest: a n2 x d matrix, where each row is a observation of dimension
%   d in the test set
%   - K: number of nearest neighbours (optional: default 1)
%   - M: a d x d matrix which weights the distance measure between
%   obeservations (optional: default is identity matrix of dimension d x d)
% OUTPUT
%   - ytest: a n2 x 1 vector, with predicted labels for the test set
%   - dist: a n2 x n1 matrix, where element (i,j) is the distance from
%   Xtest(i,:) to Xtrain(j,:)
%   - nearest: a n2 x K matrix, where row i is the index-vector of the 
%   nearest K observations in Xtrain
%% Function
[n1, d1] = size(Xtrain);
[~ , d2] = size(Xtest);
assert(d1 == d2, 'Miss match in dimensions between training and test set');
assert(n1 == length(ytrain), 'To little/to many labels for training set');
if(nargin < 5)
    M = eye(d1);
end
if(nargin < 4)
    K = 1;
end

% Calculate distance between training set and test set
% D(i,j) = norm(Xtest(i,:)-Xtrain(j,:)) 
%invM = matInv(M);
%D = pdist2(Xtest, Xtrain, 'mahalanobis', invM); % (n2 x n1 matrix)
D = pairwiseMahalanobis(Xtest, Xtrain, M);

[~, idx] = sort(D, 2, 'ascend');
nearest = idx(:,1:K);
ytest = mode(ytrain(nearest),2);

end