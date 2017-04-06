function D = pairwiseMahalanobis(X,Y,M)
D = sqrt(bsxfun(@plus,diag(X*M*X'),bsxfun(@minus,diag(Y*M*Y')',2*X*M*Y')));
end