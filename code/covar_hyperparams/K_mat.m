function out = K_mat(X, theta)
% Matern covariance function matrix (objective function)
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
