function obj = exponential_cov_obj(theta, y)
% Negative Marginal likelihood of exponential covariance (objective function to be MINimized)

if exist('debug.txt','file')
	theta'
	keyboard
end

K = K_mat(theta);
try
	Kinv = pinv(K);
catch exception
	Kinv = pinv(K + 1e-8 * randn(size(K)));
end

[N, ~] = size(K);
% sum(log(svd(K))) is equivalent to log(det(K)), but less likely to blow up
obj = - 0.5 * y' * Kinv * y - 0.5 * sum(log(svd(K))) - N/2 * log(2 * pi);

%grad = exponential_cov_grad(y, theta, Kinv);

% Use negative of obj and grad, since we have to minimize
obj = - obj;
%grad = -1 .* grad;




function out = K_mat(theta)
% Matern covariance function matrix (objective function)
%    theta - the struct of coordinates that can be messed with.
%       Contains ll, a vector of scaling params, and sigma_f and sigma_n

global X_prime;
N = size(X_prime, 1);
D = size(X_prime, 3);
out = zeros(N);
for i = 1:N
	out(i,i) =  k_func(reshape(X_prime(i,i,:),D,1), theta, true);
	for j = i+1:N
		out(i,j) = k_func(reshape(X_prime(i,j,:),D,1), theta, false);
		out(j,i) = out(i,j);
    end
end




function k = k_func(d, theta, on_diagonal)
% Matern covariance function
%    d - x1 - x2
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: sigma_f
%       element d+2: sigma_n
%    on_diagonal - true if x1 = x2 and this element is on the diagonal of the K matrix.

% For now, assume nu = 1/2

D = numel(d);  % dimensions

% k = theta.var_f * exp(-norm(x1 - x2)/ theta.l) + theta.var_n * [1 if on diagonal; 0 otherwise]
if (on_diagonal == false)
	k = theta(D+1)^2 * exp( - sqrt( d' * diag(1 ./ (theta(1:D) .^2)) * d ));
else
	% exp(0) = 1, so
	k = theta(D+1)^2 + theta(D+2)^2;
end
