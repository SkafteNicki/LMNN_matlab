close all; clear all;
%% Load data
load synth3.mat

%% Find metric
K = 20; mu = 0.5; maxIter = 2; alpha = 1; tol = 1e-6; samples = 2;
M1 = LMNN_naive(X_train, y_train, K, mu, maxIter, alpha, tol);
M2 = LMNN_active(X_train, y_train, K, mu, maxIter, alpha, tol);
M3 = LMNN_stochastic(X_train, y_train, K, mu, maxIter, alpha, tol, samples);
figure;
    for i = 0:3
        plot(X_train(i == y_train,1), X_train(i == y_train,2), '*');
        hold on;
    end
    plot_normal([0;0], matInv(M1), 'b');
    plot_normal([0;0], matInv(M2), 'r');
    plot_normal([0;0], matInv(M3), 'y');

%% Find errors
predict1 = kNN(X_train, y_train, X_test, 10);
predict2 = kNN(X_train, y_train, X_test, 10, M1); 
predict3 = kNN(X_train, y_train, X_test, 10, M2);
predict4 = kNN(X_train, y_train, X_test, 10, M3);

error1 = sum(y_test ~= predict1)/length(y_test);
error2 = sum(y_test ~= predict2)/length(y_test);
error3 = sum(y_test ~= predict3)/length(y_test);
error4 = sum(y_test ~= predict4)/length(y_test);