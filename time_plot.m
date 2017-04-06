close all; clear all; clc;
%% load data
load times.mat;
N = 50:50:350;
D = 50:50:350;
T = 1:1:6;

%% Make plots
mean_time_D = squeeze(mean(time_D,3));
mean_time_D_naive = squeeze(mean_time_D(:,1,:));
mean_time_D_active = squeeze(mean_time_D(:,2,:));
mean_time_D_stochastic = squeeze(mean_time_D(:,3,:));

mean_time_T = squeeze(mean(time_T,3));
mean_time_T_naive = squeeze(mean_time_T(:,1,:));
mean_time_T_active = squeeze(mean_time_T(:,2,:));
mean_time_T_stochastic = squeeze(mean_time_T(:,3,:));

mean_time_N = squeeze(mean(time_N,3));
mean_time_N_naive = squeeze(mean_time_N(:,1,:));
mean_time_N_active = squeeze(mean_time_N(:,2,:));
mean_time_N_stochastic = squeeze(mean_time_N(:,3,:));

FS = 30; % front size
LW = 3; % line width
coef = tinv(0.975,10)/sqrt(10); % adjust for the number of observations
% Errorplot: time vs. dimensions
figure;
    errorbar(D, mean(mean_time_D_naive,2), coef*std(mean_time_D_naive,[ ],2), 'linewidth', LW);
	hold on;
    errorbar(D, mean(mean_time_D_active,2), coef*std(mean_time_D_active,[ ],2), 'linewidth', LW);
    errorbar(D, mean(mean_time_D_stochastic,2), coef*std(mean_time_D_stochastic,[ ],2), 'linewidth', LW);
    set(gca, 'Fontsize', FS/2);
    xlabel('Number of features d', 'Fontsize', FS);
    ylabel('Mean training time (sec)', 'Fontsize', FS);
    legend({'Naive', 'Active', 'Stochastic'}, 'Fontsize', FS, 'Location', 'NorthWest');
figureSave([ ], 'time_D', 'Results', {'eps', 'png'});  
    
% Errorplot: time vs. target neighbours
figure;
    errorbar(T, mean(mean_time_T_naive,2), coef*std(mean_time_T_naive,[ ],2), 'linewidth', LW);
	hold on;
    errorbar(T, mean(mean_time_T_active,2), coef*std(mean_time_T_active,[ ],2), 'linewidth', LW);
    errorbar(T, mean(mean_time_T_stochastic,2), coef*std(mean_time_T_stochastic,[ ],2), 'linewidth', LW);
    set(gca, 'Fontsize', FS/2);
    xlabel('Number of target neighbours', 'Fontsize', FS);
    ylabel('Mean training time (sec)', 'Fontsize', FS);
    legend({'Naive', 'Active', 'Stochastic'}, 'Fontsize', FS, 'Location', 'NorthWest');
figureSave([ ], 'time_T', 'Results', {'eps', 'png'});

% Errorplot: time vs. observations
figure;
    errorbar(N, mean(mean_time_N_naive,2), coef*std(mean_time_N_naive,[ ],2), 'linewidth', LW);
	hold on;
    errorbar(N, mean(mean_time_N_active,2), coef*std(mean_time_N_active,[ ],2), 'linewidth', LW);
    errorbar(N, mean(mean_time_N_stochastic,2), coef*std(mean_time_N_stochastic,[ ],2), 'linewidth', LW);
    set(gca, 'Fontsize', FS/2);
    xlabel('Number of observations', 'Fontsize', FS);
    ylabel('Mean training time (sec)', 'Fontsize', FS);
    legend({'Naive', 'Active', 'Stochastic'}, 'Fontsize', FS, 'Location', 'NorthWest');
figureSave([ ], 'time_N', 'Results', {'eps', 'png'});    