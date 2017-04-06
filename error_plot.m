close all; clear all;
%% Load error data
load errors.mat;

%% Calculate the mean over the 10 repetitions
meanI = squeeze(mean(I_error));
meanmu = squeeze(mean(mu_error));
meanS = squeeze(mean(S_error));
meanT = squeeze(mean(T_error));

%% Plot
T = 1:1:6;
I = 11:10:101;
mu = 0:0.1:1;
S = (1:3:100)./100;

FS = 30; % front size
LW = 3; % line width
coef = tinv(0.975,10)/sqrt(10); % adjust for the number of observations
% Errorplot: Sample size
figure;
    errorbar(S, mean(meanS,2), coef*std(meanS,[ ],2), 'linewidth', LW);
    set(gca, 'Fontsize', FS/2);
    xlabel('Sample size (% of observations)', 'Fontsize', FS);
    ylabel('Mean CV train error', 'Fontsize', FS);
figureSave([ ], 'error_S', 'Results', {'eps', 'png'});    
% Errorplot: parameter mu
figure;
    errorbar(mu,mean(meanmu,2), coef*std(meanmu,[ ],2), 'linewidth', LW);
    set(gca, 'Fontsize', FS/2);
    xlabel('Parameter: \mu', 'Fontsize', FS);
    ylabel('Mean CV train error', 'Fontsize', FS);
figureSave([ ], 'error_mu', 'Results', {'eps', 'png'});    
% Errorplot: target neighbours
figure;
    errorbar(T,mean(meanT,2), coef*std(meanT,[ ],2), 'linewidth', LW);
    set(gca, 'Fontsize', FS/2);
    xlabel('Number of target neighbours', 'Fontsize', FS);
    ylabel('Mean CV train error', 'Fontsize', FS);
figureSave([ ], 'error_T', 'Results', {'eps', 'png'});    
