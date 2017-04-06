function [M,loss,gradient,Mnorm,time] = LMNN_active_loss(X, y, K, mu, maxIter, alpha, tol)
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
%   - tol: parameter, tolerance on the gradient change. If 
%   norm(G_new - G_old, 'fro') <= tol then stop the gradient decend
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
assert(N >= d, 'More observations than data needed');
assert(N == length(y), 'Not enough labels');
assert(0 < K, 'K should be a integer greater than 0');
assert(0 <= mu && mu <= 1, 'mu should be between 0 and 1');
assert(1 <= maxIter, 'maxIter should be atleast 1');
assert(alpha ~= 0, 'alpha should be different from 0');

% Find target neighbours
tN = findTargetNeighbour(X, y, K);

% Initilize metric
M_old = eye(d);

% Initilize gradient
G_old = zeros(d);
for i = 1:N
    for j = 1:K
        if(tN(i,j) ~= 0)
            diff = X(i,:) - X(tN(i,j),:);
            G_old = G_old + (1-mu)*(diff'*diff);
        end
    end
end

% Initilize triplets
T_old = int32.empty(0,3);
T_new = int32.empty(0,3);

loss = zeros(maxIter+1,1);
loss(1) = inf;
gradient = zeros(maxIter,1);
Mnorm = zeros(maxIter,1);
time = zeros(maxIter,1);

% Main iteration loop
for iter = 1:maxIter
    tic;
    iter
    loss(iter+1) = lossFunction(X, y, tN, mu, M_old);
    
    if(mod(iter-1,10) == 0 || isempty(T_new))
        % Calculate triplets under the current metric
        T_new = findTriples(X, y, tN, M_old);
    else
        % Update the last triplets under the current metric (active set)
        T_new = updateTriplets(X, T_old, M_old);
    end
    
    % Calculate difference between new and last triplets (both ways)
    T1 = setdiff(T_old, T_new, 'rows');  
    nbTriplets1 = size(T1,1);
    T2 = setdiff(T_new, T_old, 'rows');
    nbTriplets2 = size(T2,1);
    
    % Gradient contribution from imposters
    G_new = G_old;
    for n = 1:nbTriplets1
        diff1 = X(T1(n,1),:) - X(T1(n,2),:);
        diff2 = X(T1(n,1),:) - X(T1(n,3),:);
        G_new = G_new - mu*((diff1'*diff1) - (diff2'*diff2));
    end
    for n = 1:nbTriplets2
        diff1 = X(T2(n,1),:) - X(T2(n,2),:);
        diff2 = X(T2(n,1),:) - X(T2(n,3),:);
        G_new = G_new + mu*((diff1'*diff1) - (diff2'*diff2));
    end
    gradient(iter) = norm(G_new, 'fro');
    % Adjust alpha
    if(loss(iter+1) < loss(iter))
        alpha = alpha + 1.01;
    else
        alpha = alpha - 0.5;
    end
    
    % Take gradient descend step
    M_new = M_old - alpha*G_new;
    
    % Project onto the cone of positive definite matrices
    M_new = projectPSDM(M_new, tol);
    Mnorm(iter) = norm(M_new, 'fro');
    % Check if M has changed 
    if(norm(M_new - M_old, 'fro') <= tol)
        break;
    end
    
    % Update G_old, M_old, T_old for next iteration
    M_old = M_new;
    G_old = G_new;
    T_old = T_new;
    
    time(iter) = toc;
end

% Output the final metric
M = M_new;
end