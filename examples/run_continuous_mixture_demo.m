clear; clc; close all;
addpath("../src");

true_mu = -2.0;
true_sigma = 0.8;
data = simulate_continuous_mixture(20000, true_mu, true_sigma, 42);
fit = fit_continuous_mixture(data.waiting_times, 30, 15, 42);

fprintf("True mu: %.3f; estimated mu: %.3f\n", true_mu, fit.log_rate_mean);
fprintf("True sigma: %.3f; estimated sigma: %.3f\n", true_sigma, fit.log_rate_sd);

[nodes, weights] = gauss_hermite_normal(30);
sigma_grid = linspace(0.25, 1.35, 80);
profile_nll = zeros(size(sigma_grid));
for grid_id = 1:numel(sigma_grid)
    theta = [fit.log_rate_mean, log(sigma_grid(grid_id))];
    profile_nll(grid_id) = continuous_mixture_nll( ...
        theta, data.waiting_times, nodes, weights);
end

figure("Color", "white");
plot(sigma_grid, profile_nll - min(profile_nll), "LineWidth", 1.8);
xline(true_sigma, "--", "True \sigma");
xline(fit.log_rate_sd, ":", "Estimated \sigma");
xlabel("Log-rate standard deviation, \sigma");
ylabel("NLL relative to minimum");
title("Continuous-mixture likelihood profile");
grid on;
exportgraphics(gcf, "../figures/continuous_mixture_profile.png", "Resolution", 180);
