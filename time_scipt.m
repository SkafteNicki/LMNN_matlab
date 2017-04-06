close all; clear all;

%% load data
% addpath('MNIST');
% %load orl_data.mat;
% imgTrain = loadMNISTImages('train-images.idx3-ubyte')';
% imgTest = loadMNISTImages('t10k-images.idx3-ubyte')';
% YTrain = loadMNISTLabels('train-labels.idx1-ubyte');
% YTest = loadMNISTLabels('t10k-labels.idx1-ubyte');
% 
% [~, score] = pca(imgTrain, 'NumComponents', 700);
% XTrain = score;
load orl_data;
Y = Y(1:400);
%% For different values
% Default values
N_default = 350;
D_default = 50;
T_default = 3;

% Values to try out while holding the other
N = 50:50:350;
D = 50:50:350;
T = 1:1:6;

% Cross validation
nRep = 10;
Kfold = 10;
time_N = zeros(length(N),3,Kfold,nRep);
time_D = zeros(length(D),3,Kfold,nRep);
time_T = zeros(length(T),3,Kfold,nRep);

for rep = 1:nRep
    idx = crossvalind('Kfold', size(X,1), Kfold);

    for K = 1:10
        xtrain = X(K ~= idx,:);
        ytrain = Y(K ~= idx);
        % For different number of observations
        for n = 1:length(N)
            fprintf('rep: %i, fold: %i, n: %i \n', rep, K, N(n));
            tic;
            M1 = LMNN_naive(xtrain(1:N(n),1:D_default), ytrain(1:N(n)), T_default, 0.5, 20, 1, 1e-5);
            time_N(n,1,K,rep) = toc;
            tic;
            M2 = LMNN_active(xtrain(1:N(n),1:D_default), ytrain(1:N(n)), T_default, 0.5, 20, 1, 1e-5);
            time_N(n,2,K,rep) = toc;
            tic;
            M3 = LMNN_stochastic(xtrain(1:N(n),1:D_default), ytrain(1:N(n)), T_default, 0.5, 20, 1, 1e-5, 40);
            time_N(n,3,K,rep) = toc;
        end
        % For different number of dimensions
        for d = 1:length(D)
            fprintf('rep: %i, fold: %i, d: %i \n', rep, K, D(d));
            tic;
            M1 = LMNN_naive(xtrain(1:N_default,1:D(d)), ytrain(1:N_default), T_default, 0.5, 20, 1, 1e-5);
            time_D(d,1,K,rep) = toc;
            tic;
            M2 = LMNN_active(xtrain(1:N_default,1:D(d)), ytrain(1:N_default), T_default, 0.5, 20, 1, 1e-5);
            time_D(d,2,K,rep) = toc;
            tic;
            M3 = LMNN_stochastic(xtrain(1:N_default,1:D(d)), ytrain(1:N_default), T_default, 0.5, 20, 1, 1e-5, 40);
            time_D(d,3,K,rep) = toc;
        end
        % For different number of target neighbours
        for t = 1:length(T)
            fprintf('rep: %i, fold: %i, t: %i \n', rep, K, T(t));
            tic;
            M1 = LMNN_naive(xtrain(1:N_default,1:D_default), ytrain(1:N_default), T(t), 0.5, 20, 1, 1e-5);
            time_T(t,1,K,rep) = toc;
            tic;
            M2 = LMNN_active(xtrain(1:N_default,1:D_default), ytrain(1:N_default), T(t), 0.5, 20, 1, 1e-5);
            time_T(t,2,K,rep) = toc;
            tic;
            M3 = LMNN_stochastic(xtrain(1:N_default,1:D_default), ytrain(1:N_default), T(t), 0.5, 20, 1, 1e-5, 40);
            time_T(t,3,K,rep) = toc;
        end
    end
end

save times.mat time_N time_D time_T;