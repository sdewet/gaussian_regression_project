function [obj, grad] = se_cov_obj( X, y, theta)
% Negative Marginal likelihood of squared exponential covariance (SE) (objective function to be MINimized)

K = K_mat(X, theta);
try
	Kinv = pinv(K);
catch exception
	Kinv = pinv(K + 1e-8 * randn(size(K)));
end

[d, N] = size(X);
% sum(log(svd(K))) is equivalent to log(det(K)), but less likely to blow up
obj = - 0.5 * y' * Kinv * y - 0.5 * sum(log(svd(K))) - N/2 * log(2 * pi);
%fprintf('term 1: %f, term 2: %f, term 3: %f\n', -0.5*y'*Kinv*y, -0.5*sum(log(svd(K))), -N/2*log(2*pi));
grad = se_cov_grad(X, y, theta, Kinv);

% Use negative of obj and grad, since we have to minimize
obj = - obj;
grad = -1 .* grad;




function out = K_mat(X, theta)
% SE covariance function matrix (objective function)
%    X - data matrix
%    theta - the struct of coordinates that can be messed with.
%       Contains ll, a vector of scaling params, and sigma_f and sigma_n

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
% SE covariance function
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: sigma_f
%       element d+2: sigma_n
%    on_diagonal - true if x1 = x2 and this element is on the diagonal of the K matrix.

D = numel(x1);  % dimensions

% k = theta.var_f * exp(- 1/2 * (x1 - x2)^2/ theta.l^2) + theta.var_n * [1 if on diagonal; 0 otherwise]
d = x1 - x2;
k = theta(D+1)^2 * exp( - 0.5 * d' * diag(1 ./ (theta(1:D) .^2)) * d );
if (on_diagonal == true)
	k = k + theta(D+2)^2;
end
