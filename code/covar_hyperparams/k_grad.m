function grad = k_grad(X, y, theta, K_inv)

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
