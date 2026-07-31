function data = simulate_finite_mixture(n_observations, mixture_weights, annual_rates, seed)
%SIMULATE_FINITE_MIXTURE Draw exponential waiting times from latent classes.
%
% Times are returned in days; component rates are supplied per year.

arguments
    n_observations (1,1) double {mustBeInteger, mustBePositive}
    mixture_weights (1,:) double {mustBeNonnegative}
    annual_rates (1,:) double {mustBePositive}
    seed (1,1) double {mustBeInteger} = 42
end

if numel(mixture_weights) ~= numel(annual_rates)
    error("Mixture weights and rates must have the same length.");
end
if abs(sum(mixture_weights) - 1) > 1e-10
    error("Mixture weights must sum to one.");
end

rng(seed);
edges = [0, cumsum(mixture_weights)];
uniform_draws = rand(n_observations, 1);
class_id = discretize(uniform_draws, edges);
daily_rates = annual_rates(class_id)' / 365;
waiting_times_days = exprnd(1 ./ daily_rates);

data.waiting_times_days = waiting_times_days;
data.class_id = class_id;
data.true_weights = mixture_weights;
data.true_annual_rates = annual_rates;
end
