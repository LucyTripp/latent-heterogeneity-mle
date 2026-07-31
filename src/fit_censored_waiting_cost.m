function fit = fit_censored_waiting_cost(observed_time, reward, served, n_starts, seed)
%FIT_CENSORED_WAITING_COST Estimate a lognormal waiting-cost distribution.

arguments
    observed_time (:,1) double {mustBePositive}
    reward (1,1) double {mustBePositive}
    served (:,1) logical
    n_starts (1,1) double {mustBeInteger, mustBePositive} = 15
    seed (1,1) double {mustBeInteger} = 42
end

if numel(observed_time) ~= numel(served)
    error("Observed times and service indicators must have the same length.");
end

objective = @(theta) censored_waiting_cost_nll(theta, observed_time, reward, served);
options = optimoptions("fminunc", "Display", "off", ...
    "Algorithm", "quasi-newton", "MaxFunctionEvaluations", 20000);

rng(seed);
best_theta = [];
best_nll = Inf;

for start_id = 1:n_starts
    theta0 = [randn(), randn()];
    [theta, nll, exitflag] = fminunc(objective, theta0, options);
    if exitflag > 0 && isfinite(nll) && nll < best_nll
        best_theta = theta;
        best_nll = nll;
    end
end

if isempty(best_theta)
    error("All censored-model optimization attempts failed.");
end

fit.log_cost_mean = best_theta(1);
fit.log_cost_sd = exp(best_theta(2));
fit.nll = best_nll;
fit.theta = best_theta;
end
