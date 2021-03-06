function [theta, y_val] = run_optimization(type, set, amt, num)

%Call readProcessedData to get our data from the file into y and X
[y, X] = readProcessedData();

% Scale data in the same way as GPR code
mean_y = mean(y);
stdev_y = std(y);
mean_X = mean(X,1);
stdev_X = std(X,0,1);
Scaled_X = zeros(size(X));
Scaled_y = y - mean_y;
N = size(X, 1);
for i = 1:N
	Scaled_X(i,:) = (X(i,:) - mean_X) ./ stdev_X;
end

% Run the optimizations several times
D = size(X, 2);
theta = zeros(D+2,4,3);
fval = zeros(4,3);

randSet = randperm(10000, amt);

for cov_type = type:type
    for data_set = set:set
        switch data_set
            case 1 % Data between 1 and 100
                set = 1:amt;
                X_set = Scaled_X(set,:);
                y_set = Scaled_y(set);
            case 2 % Data between 8001 and 8100
                set = 8001:8000+amt;
                X_set = Scaled_X(set,:);
                y_set = Scaled_y(set);
            case 3 % Randomly selected data
                set = randSet;
                X_set = Scaled_X(set,:);
                y_set = Scaled_y(set);
        end
        local_optima = [];
        local_optimizers = [];
        lastNovel = 1; % iteration where last optimum was a new spot!
        iter = 0;
        max_iter = 1;
        while (iter - lastNovel < 3 && iter < max_iter)
            
            if exist('debug.txt','file')
                fprintf('currently on iter %f.\n', int(iter))
                keyboard
            end
            
            iter = iter + 1;
            [t, f] = optimize_hyperparams(X_set, y_set, cov_type);
            
            local_optima(iter) = f;
            local_optimizers(:,iter) = t;
            novel = true;
            for i = 1:iter-1
                if (norm(t - local_optimizers(:,i)) < 1e-1)
                    novel = false;
                end
            end
            if (novel == true)
                lastNovel = iter;
            end
	    fprintf('current optimum: %f', f);
	    fprintf('current optimzer:');
	    t'
	    save(['optimized_t', num2str(num)], 't')
	    save(['optimized_f', num2str(num)], 'f')
        end
        [m, i] = max(local_optima);
        theta(:, cov_type, data_set) = local_optimizers(:,i);
        fval(:, cov_type, data_set) = local_optima(i);
        fprintf('local optimum: %f', m);
    end
end

save(['optimized_theta', num2str(num)], 'theta')
save(['optimized_fval', num2str(num)], 'fval')
