function nll = continuous_mixture_nll(theta, waiting_times, nodes, weights)
%CONTINUOUS_MIXTURE_NLL Quadrature likelihood for lognormal rate heterogeneity.

log_rate_mean = theta(1);
log_rate_sd = exp(theta(2));
quadrature_rates = exp(log_rate_mean + sqrt(2) * log_rate_sd * nodes');

if any(~isfinite(quadrature_rates))
    nll = Inf;
    return
end

log_components = log(weights') + log(quadrature_rates) ...
    - waiting_times .* quadrature_rates;
log_likelihood = logsumexp_rows(log_components);

if any(~isfinite(log_likelihood))
    nll = Inf;
else
    nll = -sum(log_likelihood);
end
end
