function T_new = updateTriplets(X, T_old, M)


D = pairwiseMahalanobis(X, X, M);
d1 = sub2ind(size(D),T_old(:,1),T_old(:,3));
d2 = sub2ind(size(D),T_old(:,1),T_old(:,2));
idx = (D(d1) <= 1 + D(d2));

T_old(idx == 0,:) = [ ];
T_new = T_old;

end