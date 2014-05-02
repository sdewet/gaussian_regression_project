function [theta, fval] = optimize_hyperparams(X,y,cov_type)

addpath covar_hyperparams/.

n_theta = 29;
theta_0 = ones(n_theta, 1);

Xt = X'; % Each column of X is a 27-param table entries
%y is a column vector

% Lower bound - bound all to be >= 0
lb = zeros(n_theta,1);

switch cov_type
	case 1  % Squared exponential
		options = optimoptions(@fmincon,...
			'Display','iter', ...
			'GradObj','on', ...
			'Algorithm','interior-point'); %trust-region-reflective');
		objective = @(theta) se_cov_obj(Xt,y,theta);
	case 2  % Matern (1/2) [exponential covariance]
		options = optimoptions(@fmincon,...
			'Display','iter', ...
			'Algorithm','interior-point');  % or trust-region-reflective
		objective = @(theta) exponential_cov_obj(Xt,y,theta);
	case 3  % Matern (3/2)
		options = optimoptions(@fmincon,...
			'Display','iter', ...
			'GradObj','on', ...
			'Algorithm', 'interior-point'); %'trust-region-reflective');
		objective = @(theta) matern_1p5_cov_obj(Xt,y,theta);
	case 4  % Matern (5/2)
		options = optimoptions(@fmincon,...
			'Display','iter', ...
			'GradObj','on', ...
			'Algorithm', 'interior-point'); %'trust-region-reflective');
		objective = @(theta) matern_2p5_cov_obj(Xt,y,theta);
	otherwise
		error('Invalid covariance type.  This only supports Matern (1/2) right now');
		theta = theta_0;
		fval = 0;
end

[theta, fval] = fmincon(objective,theta_0,...
[],[],[],[],lb,[],[],options);

% We made the function negative to minimize.  Switch sign back.
fval = -fval;
