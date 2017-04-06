function T = findTriples_stochastic(X, y, tN, M, samples)
%% Description
% findTriplets finds triplets of index (i,j,k) where it holds that
% ||L*(x_i - x_l)||^2 <= ||L*(x_i-x_j)||^2 + 1, where y_l ~= y_i
% This means that x_l is a imposter to the point x_i and its target
% neighbour x_j
% INPUT  
%   - X: a N x d matrix, where each row is a observation for dimension d
%   - y: a N x 1 vector, with corresponding labels for each row of X
%   - tN: a N x K matrix, where tN(i,j) is the index of the j'th target
%   neighbour to observation i.
%   - M: a d x d matrix, with mahalanobis distance metric
% OUTPUT 
%   - T: a nbTrip x 3 matrix, where each row is a triplet (i,j,l) that
%   forfills the above equation under the current metric. nbTrip is here
%   the number of found triplets
%
%% Function
N = length(y);
K = size(tN,2);
% Calculate pairwise distance
%invM = matInv(M);
%D = pdist2(X, X, 'mahalanobis', inv(M));
D = pairwiseMahalanobis(X, X, M);

% Sort distances
[S, I] = sort(D, 2);
% Start out with capacity that correspond to each observation and
% target neighbour pair on average have 1 imposter
capacity = N*K;
T = zeros(capacity,3);
count = 1;

% Chose ramdomly sample observations to find triplets for
p = randperm(N);
iChoose = p(1:samples);

for i = iChoose
    for j = 1:K
        if(tN(i,j) ~= 0)
            % Current target neighbour
            targetNeighbour = tN(i,j);
            for l = 2:size(S,2)
                % Current proposed imposter
                imposter = I(i,l);
                % If the capacity of the array is to small, double up
                if(count > capacity)
                    capacity = 2*capacity;
                    T_new = zeros(capacity,3);
                    T_new(1:count-1,:) = T;
                    T = T_new;
                end
                % Check if observation with index I(i,l) is a imposter 
                % to target neighbour tN(i,j)
                if(D(i,imposter) <= 1+D(i,targetNeighbour) && y(imposter) ~= y(i))
                    T(count,:) = [i , targetNeighbour , imposter];
                    count = count + 1;
                % Check if the point is a target neighbour, then continue
                elseif(y(imposter) == y(i))
                    continue;
                % Else we are out of margin, and the remaining points 
                % will also be
                else
                    break;
                end
            end
        end
    end
end
T(~any(T,2),:) = [ ]; % delete zero rows
end
