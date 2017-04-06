function M = LMNN_naive(X, y, K, mu, maxIter, alpha, tol)
%% Description
% LMNN implement the large margin nearest neighbour algorithm, that 
% learns a mahalanobis metric from a training set X,y
% INPUT
%   - X: a N x d matrix with training data. Each row correspond to a
%   observation of dimension d
%   - y: a N long vector with labels for the training set
%   - K: parameter, determine how many target neighbours each observation
%   should have (default: 5)
%   - mu: parameter, determine weight between push and pull terms. Should
%   be a number between 0 and 1 (default: 0.5)
%   - maxIter: maximum number of iteratioins to run (default: 100)
%   - alpha: parameter, determine size of gradient step (default: 1)
% OUTPUT
%   - M: a d x d matrix, with the learned mahalanobis distance

%% Function
% Check input to function
if(nargin < 2),     error('Not enough input');  end
if(nargin < 3),     K = 3;                      end
if(nargin < 4),     mu = 0.5;                   end
if(nargin < 5),     maxIter = 20;               end
if(nargin < 6),     alpha = 1;                  end
if(nargin < 7),     tol = 1e-6;                 end

% Get dimensions
[N, d] = size(X);

% Assert that input are right
assert(N >= d,               'More observations than data needed');
assert(N == length(y),      'Not enough labels');
assert(0 < K,               'K should be a integer greater than 0');
assert(0 <= mu && mu <= 1,  'mu should be between 0 and 1');
assert(1 <= maxIter,        'maxIter should be atleast 1');
assert(alpha ~= 0,          'alpha should be different from 0');

% Find target neighbours
tN = findTargetNeighbour(X, y, K);

% Initilize metric
M = eye(d);

% Initilize gradient
G0 = zeros(d);
for i = 1:N
    for j = 1:K
        if(tN(i,j) ~= 0)
            diff = X(i,:) - X(tN(i,j),:);
            G0 = G0 + (1-mu)*(diff'*diff);
        end
    end
end

% Main iteration loop
for iter = 1:maxIter
    % Calculate triplets under the current metric
    T = findTriples(X, y, tN, M);
    nbTriplets = size(T,1);
    
    % Gradient contribution from imposters
    G = G0;
    for n = 1:nbTriplets
        diff1 = X(T(n,1),:) - X(T(n,2),:);
        diff2 = X(T(n,1),:) - X(T(n,3),:);
        G = G + mu*((diff1'*diff1) - (diff2'*diff2));
    end
    
    % Take gradient descend step
    M = M - alpha*G;
    
    % Project onto the cone of positive definite matrices
    M = projectPSDM(M, tol);
end

end

