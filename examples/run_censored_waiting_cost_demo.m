clear; clc; close all;
addpath("../src");

reward = 5.8;
true_mu = 0.15;
true_sigma = 0.05;
data = simulate_censored_waiting_costs(20000, reward, true_mu, true_sigma, 42);
fit = fit_censored_waiting_cost(data.observed_time, reward, data.served, 15, 42);

fprintf("Abandonment rate: %.1f%%\n", 100 * mean(data.abandoned));
fprintf("True mu: %.4f; estimated mu: %.4f\n", true_mu, fit.log_cost_mean);
fprintf("True sigma: %.4f; estimated sigma: %.4f\n", true_sigma, fit.log_cost_sd);

figure("Color", "white");
bar(categorical(["\mu", "\sigma"]), ...
    [true_mu, fit.log_cost_mean; true_sigma, fit.log_cost_sd]);
ylabel("Parameter value");
legend("True", "Estimated", "Location", "best");
title("Censored waiting-cost parameter recovery");
grid on;
exportgraphics(gcf, "../figures/censored_parameter_recovery.png", "Resolution", 180);
