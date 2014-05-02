function [obj, grad] = matern_1p5_cov_obj( X, y, theta)
% Negative Marginal likelihood of Matern covariance (nu = 3/2) (objective function to be MINimized)

K = K_mat(X, theta);
try
	Kinv = pinv(K);
catch exception
	Kinv = pinv(K + 1e-8 * randn(size(K)));
end

[d, N] = size(X);
obj = - 0.5 * y' * Kinv * y - 0.5 * log(det(K)) - N/2 * log(2 * pi);

grad = matern_1p5_cov_grad(X, y, theta, Kinv);

% Use negative of obj and grad, since we have to minimize
obj = - obj;
grad = -1 .* grad;




function out = K_mat(X, theta)
% Matern covariance function matrix (nu = 3/2) (objective function)
%    X - data matrix
%    theta - the struct of coordinates that can be messed with.
%       Contains ll, a vector of scaling params, and var_f and var_n, the squared sigma's for those values

[d, N] = size(X);
out = zeros(N);
for i = 1:N
	out(i,i) =  k_func(X(:,i), X(:,i), theta, true);
	for j = i+1:N
		out(i,j) = k_func(X(:,i), X(:,j), theta, false);
		out(j,i) = out(i,j);
	end
end




function k = k_func(x1, x2, theta, on_diagonal)
% Matern covariance function (nu = 3/2)
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: var_f (= sigma_f^2)
%       element d+2: var_n (= sigma_n^2)
%    on_diagonal - true if x1 = x2 and this element is on the diagonal of the K matrix.

D = numel(x1);  % dimensions

% u = 1 + sqrt(3)*(x1-x2)/l
% k = theta.var_f * (1 + u) * exp(-u) + theta.var_n * [1 if on diagonal; 0 otherwise]
if (on_diagonal == false)
	d = x1 - x2;
	u = sqrt(3 * d' * diag(1 ./ theta(1:D) .^2) * d);
	k = theta(D+1) * (1 + u) * exp(-u);
else
	% u = 0, and (1 + u) exp(-u) = (1) * exp(0) = 1, so
	k = theta(D+1) + theta(D+2);
end
