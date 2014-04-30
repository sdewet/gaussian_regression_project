function out = dk_func_f(x1, x2, theta)
% Derivative of Matern covariance function with respect to sigma_f hyperparameter
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the struct of coordinates that can be messed with.
%       Contains (l, a vector of scaling params, and var_f and var_n, the squared sigma's for those values

% Note: sigma_f^2 = var_f
d = x1 - x2;
sigma_f = sqrt(theta.var_f);
out = 2 * sigma_f * exp( - sqrt( d' * diag(1 ./ (theta.ll .^2)) * d ));
