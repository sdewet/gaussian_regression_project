function out = dk_func_f(x1, x2, theta)
% Derivative of Matern covariance function with respect to sigma_f hyperparameter
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: var_f (= sigma_f^2)
%       element d+2: var_n (= sigma_n^2)

D = numel(x1);
d = x1 - x2;
sigma_f = sqrt(theta(D+1));
out = 2 * sigma_f * exp( - sqrt( d' * diag(1 ./ (theta(1:D) .^2)) * d ));
