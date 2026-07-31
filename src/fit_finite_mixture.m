function fit = fit_finite_mixture(waiting_times_days, n_classes, n_starts, seed)
%FIT_FINITE_MIXTURE Estimate an exponential mixture using multi-start MLE.

arguments
    waiting_times_days (:,1) double {mustBePositive}
    n_classes (1,1) double {mustBeInteger, mustBePositive}
    n_starts (1,1) double {mustBeInteger, mustBePositive} = 20
    seed (1,1) double {mustBeInteger} = 42
end

rng(seed);
objective = @(theta) finite_mixture_nll(theta, waiting_times_days, n_classes);
options = optimoptions("fminunc", "Display", "off", ...
    "Algorithm", "quasi-newton", "MaxFunctionEvaluations", 20000, ...
    "OptimalityTolerance", 1e-8);

best_theta = [];
best_nll = Inf;

for start_id = 1:n_starts
    initial_weights = diff([0, sort(rand(1, n_classes - 1)), 1]);
    if n_classes > 1
        initial_logits = log(initial_weights(1:end-1) / initial_weights(end));
    else
        initial_logits = [];
    end

    quantile_levels = linspace(0.10, 0.90, n_classes);
    initial_rates = 1 ./ quantile(waiting_times_days, quantile_levels);
    initial_rates = sort(initial_rates) .* exp(0.25 * randn(1, n_classes));
    theta0 = [initial_logits, log(initial_rates)];

    [theta, nll, exitflag] = fminunc(objective, theta0, options);
    if exitflag > 0 && isfinite(nll) && nll < best_nll
        best_theta = theta;
        best_nll = nll;
    end
end

if isempty(best_theta)
    error("All finite-mixture optimization attempts failed.");
end

logits = [best_theta(1:n_classes-1), 0];
logits = logits - max(logits);
weights = exp(logits) / sum(exp(logits));
annual_rates = 365 * exp(best_theta(n_classes:end));

[annual_rates, order] = sort(annual_rates);
fit.weights = weights(order);
fit.annual_rates = annual_rates;
fit.nll = best_nll;
fit.bic = (2 * n_classes - 1) * log(numel(waiting_times_days)) + 2 * best_nll;
fit.n_classes = n_classes;
fit.theta = best_theta;
end
