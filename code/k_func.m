function k = k_func(x1, x2, theta, on_diagonal)
% Matern covariance function
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the struct of coordinates that can be messed with.
%       Contains (l, a vector of scaling params, and var_f and var_n, the squared sigma's for those values
%    on_diagonal - true if x1 = x2 and this element is on the diagonal of the K matrix.


% For now, assume nu = 1/2

% k = theta.var_f * exp(-norm(x1 - x2)/ theta.l) + theta.var_n * [1 if on diagonal; 0 otherwise]
if (on_diagonal == false)
	d = x1 - x2;
	k = theta.var_f * exp( - sqrt( d' * diag(1 ./ (theta.ll .^2)) * d ));
else
	% exp(0) = 1, so
	k = theta.var_f + theta.var_n;
end
