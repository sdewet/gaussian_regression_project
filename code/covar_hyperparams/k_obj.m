function [obj, grad] = k_obj( X, y, theta)
% Negative Marginal likelihood (objective function to be MINimized)

K = K_mat(X, theta);
Kinv = pinv(K);

[d, N] = size(X);
obj = - 0.5 * y' * Kinv * y - 0.5 * log(det(K)) - N/2 * log(2 * pi);

grad = k_grad(X, y, theta, Kinv);

% Use negative of obj and grad, since we have to minimize
obj = - obj;
grad = -1 .* grad;
