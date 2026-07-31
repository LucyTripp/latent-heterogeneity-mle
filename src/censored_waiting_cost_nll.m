function nll = censored_waiting_cost_nll(theta, observed_time, reward, served)
%CENSORED_WAITING_COST_NLL Likelihood with exact abandonment and censoring.

log_cost_mean = theta(1);
log_cost_sd = exp(theta(2));
implied_cost = reward ./ observed_time;
log_contribution = zeros(size(observed_time));

abandoned = ~served;
log_contribution(abandoned) = lognpdf(implied_cost(abandoned), ...
    log_cost_mean, log_cost_sd) + log(reward) ...
    - 2 * log(observed_time(abandoned));

% Service before abandonment implies cost < reward / observed service time.
cdf_values = logncdf(implied_cost(served), log_cost_mean, log_cost_sd);
log_contribution(served) = log(max(cdf_values, realmin));

if any(~isfinite(log_contribution))
    nll = Inf;
else
    nll = -sum(log_contribution);
end
end
