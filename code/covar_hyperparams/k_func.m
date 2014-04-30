function k = k_func(x1, x2, theta, on_diagonal)
% Matern covariance function
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: var_f (= sigma_f^2)
%       element d+2: var_n (= sigma_n^2)
%    on_diagonal - true if x1 = x2 and this element is on the diagonal of the K matrix.

% For now, assume nu = 1/2

D = numel(x1);  % dimensions

% k = theta.var_f * exp(-norm(x1 - x2)/ theta.l) + theta.var_n * [1 if on diagonal; 0 otherwise]
if (on_diagonal == false)
	d = x1 - x2;
	k = theta(D+1) * exp( - sqrt( d' * diag(1 ./ (theta(1:D) .^2)) * d ));
else
	% exp(0) = 1, so
	k = theta(D+1) + theta(D+2);
end
