function data = simulate_continuous_mixture(n_observations, log_rate_mean, log_rate_sd, seed)
%SIMULATE_CONTINUOUS_MIXTURE Simulate exponential times with lognormal rates.

arguments
    n_observations (1,1) double {mustBeInteger, mustBePositive}
    log_rate_mean (1,1) double
    log_rate_sd (1,1) double {mustBePositive}
    seed (1,1) double {mustBeInteger} = 42
end

rng(seed);
individual_rates = exp(log_rate_mean + log_rate_sd * randn(n_observations, 1));

data.waiting_times = exprnd(1 ./ individual_rates);
data.individual_rates = individual_rates;
data.true_log_rate_mean = log_rate_mean;
data.true_log_rate_sd = log_rate_sd;
end
