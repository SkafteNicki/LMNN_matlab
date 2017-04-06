close all; clear all; clc;
addpath('algoritms');
addpath('support_functions');
addpath('other');
%% Loss vs. iteration
load orl_data.mat;
%maxIter = 30;
%[~,loss{1},~,~,time{1}] = LMNN_active_loss(Xtest(:,1:100), Ytest, 5, 0.5, maxIter);
%[~,loss{2},~,~,time{2}] = LMNN_naive_loss(Xtest(:,1:100), Ytest, 5, 0.5, maxIter);
%[~,loss{3},~,~,time{3}] = LMNN_stochastic_loss(Xtest(:,1:100), Ytest, 5, 0.5, maxIter,40);
%figure;
%    plot(1:maxIter, [loss(3:end)]);
count = 1;
for maxIter = 1:100
    maxIter
    tic;
        M = LMNN_naive(Xtrain, Ytrain, 5, 0.5, maxIter);
    time(1,count) = toc;
    
    tic;
        M = LMNN_active(Xtrain, Ytrain, 5, 0.5, maxIter);
    time(2,count) = toc;
    
    tic;
        M = LMNN_stochastic(Xtrain, Ytrain, 5, 0.5, maxIter,40);
    time(3,count) = toc;
    
    count = count + 1;
end