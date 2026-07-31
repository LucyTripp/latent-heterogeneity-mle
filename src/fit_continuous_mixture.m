function fit = fit_continuous_mixture(waiting_times, n_nodes, n_starts, seed)
%FIT_CONTINUOUS_MIXTURE Estimate lognormal rate heterogeneity by quadrature MLE.

arguments
    waiting_times (:,1) double {mustBePositive}
    n_nodes (1,1) double {mustBeInteger, mustBePositive} = 30
    n_starts (1,1) double {mustBeInteger, mustBePositive} = 15
    seed (1,1) double {mustBeInteger} = 42
end

[nodes, weights] = gauss_hermite_normal(n_nodes);
objective = @(theta) continuous_mixture_nll(theta, waiting_times, nodes, weights);
options = optimoptions("fminunc", "Display", "off", ...
    "Algorithm", "quasi-newton", "MaxFunctionEvaluations", 20000);

rng(seed);
best_theta = [];
best_nll = Inf;

for start_id = 1:n_starts
    theta0 = [log(1 / mean(waiting_times)) + randn(), log(0.5) + 0.5 * randn()];
    [theta, nll, exitflag] = fminunc(objective, theta0, options);
    if exitflag > 0 && isfinite(nll) && nll < best_nll
        best_theta = theta;
        best_nll = nll;
    end
end

if isempty(best_theta)
    error("All continuous-mixture optimization attempts failed.");
end

fit.log_rate_mean = best_theta(1);
fit.log_rate_sd = exp(best_theta(2));
fit.mean_rate = exp(fit.log_rate_mean + fit.log_rate_sd^2 / 2);
fit.nll = best_nll;
fit.theta = best_theta;
end
