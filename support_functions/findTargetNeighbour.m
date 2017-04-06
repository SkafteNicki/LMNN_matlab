function tN = findTargetNeighbour(X, y, K)
%% Description
% findTargetNeighbour is a variation of the kNN algorithm, where the closes
% K neighbour with the same label is found
% INPUT
%   - X: a N x d matrix, where each row is a observation of dimension d
%   - labels: a N x 1 vector, with corresponding labels
%   - K: number of neighbours to find
% OUTPUT
%   - tN: a N x K matrix, where tN(i,j) is the j'de nearest-same-labeled
%   neighbour to the i'de observation in X. A 0 entry indicates that not
%   enough neighbours where found
%
%% Function
% Calculate pairwise distance and sort. Then find the corresponding labels
[N, d] = size(X);
D = pairwiseMahalanobis(X, X, eye(d)); %pdist2(X,X);
[~, I] = sort(D,2);
neighbourIndex = y(I);
% Find K nearest neighbours, with same label as observation
tN = zeros(N,K);
for i = 1:N
    count = 1;
    for j = 2:N
        if(neighbourIndex(i,1) == neighbourIndex(i,j) && count<=K)
            tN(i,count) = I(i,j);
            count = count + 1;
        end
    end
end
end
