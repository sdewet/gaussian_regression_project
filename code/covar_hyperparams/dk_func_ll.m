function out = dk_func_ll(x1, x2, theta, j)
% Derivative of Matern covariance function with respect to l[j] hyperparameter
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: var_f (= sigma_f^2)
%       element d+2: var_n (= sigma_n^2)
%    j - hyperparameter

D = numel(x1);

d = x1 - x2;
u = sqrt(d' * diag(1 ./ (theta(1:D) .^2)) * d);

% d/dl sigma_f * exp(-u) = sigma_f * exp(u) * (-1/(2 * sqrt(sum(d^2/ll^2)))) * (-2 d_j^2 / l_j^3)

out = theta(D+1) * (exp(-u) / u) * (d(j)^2 / theta(j)^3);
