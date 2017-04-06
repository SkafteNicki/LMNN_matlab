close all; clear all;
%% load data
load('YaleB_32x32.mat');
X = fea;
Y = gnd;

%% Do PCA reduction
[coeff,score,~,~,explained,mean] = pca(X);
cum_explained = cumsum(explained);
minComp = find(cum_explained >= 95,1);
XPCA = score(:,6:minComp);

%% Do test-training split
[train, test] = crossvalind('Holdout', size(XPCA,1), 1/3);
Xtrain = XPCA(train,:);
Xtest = XPCA(test,:);
Ytrain = Y(train);
Ytest = Y(test);

%% Do some training and prediction
nObs = 1000;
K = 3;

time = zeros(4,1);
tic;
[prediction0, nearest0] = kNN(Xtrain, Ytrain, Xtest, K);
error(1) = sum(Ytest ~= prediction0) / length(Ytest);
time(1) = toc; 
 
tic;
M1 = LMNN_naive(Xtrain(1:nObs,:), Ytrain(1:nObs), K, 0.5, 20, 1, 1e-5);
[prediction1, nearest1] = kNN(Xtrain, Ytrain, Xtest, K, M1);
error(2) = sum(Ytest ~= prediction1) / length(Ytest);
time(3) = toc;
 
tic;
M2 = LMNN_active(Xtrain(1:nObs,:), Ytrain(1:nObs), K, 0.5, 20, 1, 1e-5);
[prediction2, nearest2] = kNN(Xtrain, Ytrain, Xtest, K, M2);
error(3) = sum(Ytest ~= prediction2) / length(Ytest);
time(2) = toc;
 
tic;
M3 = LMNN_stochastic(Xtrain(1:nObs,:), Ytrain(1:nObs), K, 0.5, 20, 1, 1e-5, 0.2*size(Xtrain(1:nObs,:),2));
[prediction3, nearest3] = kNN(Xtrain, Ytrain, Xtest, K, M3);
error(4) = sum(Ytest ~= prediction3) / length(Ytest);
time(4) = toc;
 
tradeoff = 100*(error(1)-error(2:end)) ./ time(2:end)';
