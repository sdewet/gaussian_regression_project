function out = dk_func_n(theta, on_diagonal)
% Derivative of Matern covariance function with respect to sigma_f hyperparameter
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: var_f (= sigma_f^2)
%       element d+2: var_n (= sigma_n^2)
%    on_diagonal - true if x1 = x2 and this element is on the diagonal of the K matrix.

if (on_diagonal == true)
	sigma_n = sqrt(theta(end));
	out = 2 * sigma_n;
else
	out = 0;
end
