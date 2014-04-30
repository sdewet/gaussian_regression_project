function out = dk_func_ll(x1, x2, theta, j)
% Derivative of Matern covariance function with respect to l[j] hyperparameter
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the struct of coordinates that can be messed with.
%       Contains (l, a vector of scaling params, and var_f and var_n, the squared sigma's for those values
%    j - hyperparameter

d = x1 - x2;
u = sqrt(d' * diag(1 ./ (theta.ll .^2)) * d);

% d/dl exp(-u) = exp(u) * (-1/(2 * sqrt(sum(d^2/l^2)))) * (-2 d_j^2 / l_j^3)

out = theta.var_f * exp(-u) / u * d(j)^2 / theta.ll^3;
