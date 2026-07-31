function nll = finite_mixture_nll(theta, waiting_times_days, n_classes)
%FINITE_MIXTURE_NLL Negative log-likelihood for an exponential mixture.
%
% theta = [K-1 weight logits, K log daily rates]. The final weight logit is
% fixed at zero for identification.

arguments
    theta (1,:) double
    waiting_times_days (:,1) double {mustBePositive}
    n_classes (1,1) double {mustBeInteger, mustBePositive}
end

if numel(theta) ~= 2 * n_classes - 1
    nll = Inf;
    return
end

weight_logits = [theta(1:n_classes-1), 0];
weight_logits = weight_logits - max(weight_logits);
weights = exp(weight_logits) / sum(exp(weight_logits));
daily_rates = exp(theta(n_classes:end));

if any(~isfinite(daily_rates))
    nll = Inf;
    return
end

log_components = log(weights) + log(daily_rates) ...
    - waiting_times_days .* daily_rates;
log_likelihood = logsumexp_rows(log_components);

if any(~isfinite(log_likelihood))
    nll = Inf;
else
    nll = -sum(log_likelihood);
end
end
