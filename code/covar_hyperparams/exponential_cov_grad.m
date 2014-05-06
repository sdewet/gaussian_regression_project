function grad = exponential_cov_grad(X, y, theta, K_inv)

alpha = K_inv * y;
term1 = (alpha * alpha' - K_inv);

grad = zeros(numel(theta), 1);
[d,N] = size(X);

for h = 1:numel(theta)
	dK = zeros(N,N);
	for i = 1:N
		for j = i:N
			if h <= d
				if (i == j)
					% So, add a tiny bit of noise to X_i.
					% Not sure that this is legit, really.
					x_temp = X(:,j)+1e-6.*randn(d,1);
					dK(j,i) = dk_func_ll(X(:,i), x_temp, theta, h);
				else
					dK(j,i) = dk_func_ll(X(:,i), X(:,j), theta, h);
				end
			elseif h == d + 1
				dK(j,i) = dk_func_sigma_f(X(:,i), X(:,j), theta);
			elseif h == d + 2
				dK(j,i) = dk_func_sigma_n(theta, (i==j) );
			end
			dK(i, j) = dK(j, i);
		end
	end
	grad(h) = 0.5 * trace(term1*dK);  % Derivative of marginal likelihood
end




function out = dk_func_ll(x1, x2, theta, j)
% Derivative of Matern covariance function with respect to l[j] hyperparameter
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: sigma_f
%       element d+2: sigma_n
%    j - hyperparameter

D = numel(x1);

d = x1 - x2;
u = sqrt(d' * diag(1 ./ (theta(1:D) .^2)) * d);

% d/dl sigma_f * exp(-u) = sigma_f * exp(-u) * -(1/(2 * sqrt(sum(d^2/ll^2)))) * (-2 d_j^2 / l_j^3)

out = theta(D+1)^2 * (exp(-u) / u) * (d(j)^2 / theta(j)^3);




function out = dk_func_sigma_f(x1, x2, theta)
% Derivative of Matern covariance function with respect to sigma_f hyperparameter
%    x1 - first coordinate
%    x2 - second coordinate
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: sigma_f
%       element d+2: sigma_n

D = numel(x1);
d = x1 - x2;
sigma_f = theta(D+1);
out = 2 * sigma_f * exp( - sqrt( d' * diag(1 ./ (theta(1:D) .^2)) * d ));




function out = dk_func_sigma_n(theta, on_diagonal)
% Derivative of Matern covariance function with respect to sigma_f hyperparameter
%    theta - the array of coordinates that can be changed.
%       elements 1:d :  l, a vector of scaling params
%       element d+1: sigma_f
%       element d+2: sigma_n
%    on_diagonal - true if x1 = x2 and this element is on the diagonal of the K matrix.

if (on_diagonal == true)
	sigma_n = theta(end);
	out = 2 * sigma_n;
else
	out = 0;
end
