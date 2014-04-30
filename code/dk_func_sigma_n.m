function out = dk_func_n(theta, on_diagonal)
% Derivative of Matern covariance function with respect to sigma_f hyperparameter
%    theta - the struct of coordinates that can be messed with.
%       Contains (l, a vector of scaling params, and var_f and var_n, the squared sigma's for those values
%    on_diagonal - true if x1 = x2 and this element is on the diagonal of the K matrix.

% Note: sigma_f^2 = var_f

if (on_diagonal == true)
	sigma_n = sqrt(theta.var_n);
	out = 2 * sigma_n;
else
	out = 0;
end
