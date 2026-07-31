function data = simulate_censored_waiting_costs(n_callers, reward, log_cost_mean, log_cost_sd, seed)
%SIMULATE_CENSORED_WAITING_COSTS Simulate service or utility-driven abandonment.

arguments
    n_callers (1,1) double {mustBeInteger, mustBePositive}
    reward (1,1) double {mustBePositive}
    log_cost_mean (1,1) double
    log_cost_sd (1,1) double {mustBePositive}
    seed (1,1) double {mustBeInteger} = 42
end

rng(seed);
waiting_cost = exp(log_cost_mean + log_cost_sd * randn(n_callers, 1));
abandonment_time = reward ./ waiting_cost;

median_abandonment = reward / exp(log_cost_mean);
service_time = lognrnd(log(median_abandonment / 2.5), 1.2, n_callers, 1);
abandoned = abandonment_time < service_time;

data.observed_time = min(abandonment_time, service_time);
data.served = ~abandoned;
data.abandoned = abandoned;
data.reward = reward;
end
