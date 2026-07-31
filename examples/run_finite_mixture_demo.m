clear; clc; close all;
addpath("../src");

% Well-separated components make the introductory recovery example clear.
% Try closer rates to explore weak identification.
true_weights = [0.45, 0.30, 0.15, 0.10];
true_annual_rates = [0.10, 1.50, 8.00, 30.00];
data = simulate_finite_mixture(20000, true_weights, true_annual_rates, 42);

candidate_classes = 1:5;
fits = cell(size(candidate_classes));
for k = candidate_classes
    fprintf("Estimating K = %d...\n", k);
    fits{k} = fit_finite_mixture(data.waiting_times_days, k, 20, 100 + k);
end

bic = cellfun(@(fit) fit.bic, fits);
[~, selected_k] = min(bic);
selected_fit = fits{selected_k};

fprintf("\nSelected %d classes by BIC.\n", selected_k);
disp(table(selected_fit.weights', selected_fit.annual_rates', ...
    "VariableNames", ["EstimatedWeight", "EstimatedAnnualRate"]));

figure("Color", "white");
plot(candidate_classes, bic, "-o", "LineWidth", 1.8, "MarkerSize", 7);
xlabel("Number of latent classes");
ylabel("BIC");
title("Finite-mixture model selection");
grid on;
exportgraphics(gcf, "../figures/finite_mixture_bic.png", "Resolution", 180);

if selected_k == numel(true_weights)
    figure("Color", "white");
    tiledlayout(1, 2);
    nexttile;
    bar([true_weights(:), selected_fit.weights(:)]);
    xlabel("Class (sorted by rate)");
    ylabel("Mixture weight");
    legend("True", "Estimated", "Location", "best");
    title("Weight recovery");
    nexttile;
    bar([true_annual_rates(:), selected_fit.annual_rates(:)]);
    xlabel("Class (sorted by rate)");
    ylabel("Annual rate");
    legend("True", "Estimated", "Location", "best");
    title("Rate recovery");
    exportgraphics(gcf, "../figures/finite_mixture_recovery.png", "Resolution", 180);
end
