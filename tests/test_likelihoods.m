function tests = test_likelihoods
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repo_root = fileparts(fileparts(mfilename("fullpath")));
addpath(fullfile(repo_root, "src"));
testCase.TestData.repo_root = repo_root;
end

function testQuadratureWeights(testCase)
[~, weights] = gauss_hermite_normal(30);
verifyEqual(testCase, sum(weights), 1, "AbsTol", 1e-12);
verifyGreaterThan(testCase, min(weights), 0);
end

function testFiniteMixtureLikelihoodPrefersTruth(testCase)
data = simulate_finite_mixture(5000, [0.7, 0.3], [1.5, 8], 9);
true_theta = [log(0.7 / 0.3), log([1.5, 8] / 365)];
bad_theta = [0, log([0.2, 20] / 365)];
verifyLessThan(testCase, ...
    finite_mixture_nll(true_theta, data.waiting_times_days, 2), ...
    finite_mixture_nll(bad_theta, data.waiting_times_days, 2));
end

function testContinuousMixtureRecovery(testCase)
data = simulate_continuous_mixture(8000, -1.5, 0.6, 11);
fit = fit_continuous_mixture(data.waiting_times, 25, 8, 11);
verifyEqual(testCase, fit.log_rate_mean, -1.5, "AbsTol", 0.15);
verifyEqual(testCase, fit.log_rate_sd, 0.6, "AbsTol", 0.15);
end

function testCensoredLikelihoodRecovery(testCase)
data = simulate_censored_waiting_costs(10000, 5.8, 0.15, 0.08, 12);
fit = fit_censored_waiting_cost(data.observed_time, 5.8, data.served, 8, 12);
verifyEqual(testCase, fit.log_cost_mean, 0.15, "AbsTol", 0.03);
verifyEqual(testCase, fit.log_cost_sd, 0.08, "AbsTol", 0.03);
end
