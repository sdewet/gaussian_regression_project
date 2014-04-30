function [theta, fval] = optimize_covar(X,y)

addpath covar_hyperparams/.

options = optimoptions(@fmincon,...
'Display','iter', ...
'Algorithm','interior-point');  % or trust-region-reflective

n_theta = 29;
theta_0 = ones(n_theta, 1);

Xt = X'; % Each column of X is a 27-param table entries
%y is a column vector

objective = @(theta) k_obj(Xt,y,theta);

% Lower bound - bound all to be >= 0
lb = zeros(n_theta,1);

[theta, fval] = fmincon(objective,theta_0,...
[],[],[],[],lb,[],[],options);

