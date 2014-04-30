function [theta, fval] = optimize_hyperparams(X,y,cov_type)

addpath covar_hyperparams/.

if cov_type == 2  % Matern (1/2) [exponential covariance]

	options = optimoptions(@fmincon,...
	'Display','iter', ...
	'Algorithm','interior-point');  % or trust-region-reflective

	n_theta = 29;
	theta_0 = ones(n_theta, 1);

	Xt = X'; % Each column of X is a 27-param table entries
	%y is a column vector

	objective = @(theta) exponential_cov_obj(Xt,y,theta);

	% Lower bound - bound all to be >= 0
	lb = zeros(n_theta,1);

	[theta, fval] = fmincon(objective,theta_0,...
	[],[],[],[],lb,[],[],options);

	% We made the function negative to minimize.  Switch sign back.
	fval = -fval;
else
	error('Wrong covariance type.  This only supports Matern (1/2) right now');
	theta = ones(27);
	fval = 0;
end
