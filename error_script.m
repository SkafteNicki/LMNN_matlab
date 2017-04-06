clc; close all; clear all;
%% Load data
load orl_data.mat;
addpath('algoritms');
addpath('other');
addpath('support_functions');

%% Compute classification error for different methods and values
% Default values
T_default = 3;
I_default = 20;
mu_default = 0.5;
S_default = 10;

% Values to try for
T = 1:1:6;
I = 11:10:101;
mu = 0:0.1:1;
S = round(9/10*size(Xtrain,1)*(1:3:100)./100);

%% Test active for different target neighbour
Kfold = 10;
nRep = 10;
T_error = zeros(Kfold, length(T), nRep);
I_error = zeros(Kfold, length(I), nRep);
mu_error = zeros(Kfold, length(mu), nRep);
S_error = zeros(Kfold, length(S), nRep);

for rep = 1:nRep
    idx = crossvalind('Kfold', size(Xtrain,1), 10);

    for K = 1:10
        % Do cross split
        xtrain = Xtrain(K ~= idx,:);
        ytrain = Ytrain(K ~= idx);
        xtest = Xtrain(K == idx,:);
        ytest = Ytrain(K == idx);
    
        % Test for different T
        for t = 1:length(T)
            fprintf('rep: %i, kfold: %i, t: %i \n', rep, K, T(t));
            M = LMNN_active(xtrain, ytrain, T(t), mu_default, I_default, 1, 1e-6);
            prediction = kNN(xtrain, ytrain, xtest, T(t), M);
            T_error(K,t,rep) = sum(prediction ~= ytest) / length(ytest);
        end
        % Test for different iter
        for i = 1:length(I)
            fprintf('rep: %i, kfold: %i, iter: %i \n', rep, K, I(i));
            M = LMNN_active(xtrain, ytrain, T_default, mu_default, I(i), 1, 1e-6);
            prediction = kNN(xtrain, ytrain, xtest, T_default, M);
            I_error(K,i,rep) = sum(prediction ~= ytest) / length(ytest);
        end
        % Test for different mu
        for mm = 1:length(mu)
            fprintf('rep: %i, kfold: %i, mu: %d \n', rep, K, mu(mm));
            M = LMNN_active(xtrain, ytrain, T_default, mu(mm), I_default, 1, 1e-6);
            prediction = kNN(xtrain, ytrain, xtest, T_default, M);
            mu_error(K,mm,rep) = sum(prediction ~= ytest) / length(ytest);
        end
        % Test for differnt samples
        for s = 1:length(S)
            fprintf('rep: %i, kfold: %i, s: %i \n', rep, K, S(s));
            M = LMNN_stochastic(xtrain, ytrain, T_default, mu_default, I_default, 1, 1e-6, S(s));
            prediction = kNN(xtrain, ytrain, xtest, T_default, M);
            S_error(K,s,rep) = sum(prediction ~= ytest) / length(ytest);
        end
    end
end
%mean_T_error = mean(T_error,1);
%mean_I_error = mean(I_error,1);
%mean_mu_error = mean(mu_error,1);
%mean_S_error = mean(S_error,1);
