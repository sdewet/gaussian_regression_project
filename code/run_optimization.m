function [theta, y_val] = run_optimization()

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
theta = zeros(D+2,4,4);
fval = zeros(4,4);

randSet = randperm(N, 100);

% Specially scaled 1-100
SampleSize = 100;
local_Scaled_X = zeros(SampleSize, D);
local_mean_y = mean(y(1:SampleSize));
local_stdev_y = std(y(1:SampleSize));
local_mean_X = mean(X(1:SampleSize, :),1);
local_stdev_X = std(X(1:SampleSize, :),0,1);
local_Scaled_y = y - local_mean_y;
for i = 1:N
    local_Scaled_X(i,:) = (X(i,:) - local_mean_X) ./ local_stdev_X;
end

for cov_type = 1:1
    for data_set = 1:1
        switch data_set
            case 1 % Data between 1 and 100
                set = 1:100;
                X_set = Scaled_X(set,:);
                y_set = Scaled_y(set);
            case 2 % Data between 10001 and 10100
                set = 10001:10100;
                X_set = Scaled_X(set,:);
                y_set = Scaled_y(set);
            case 3 % Randomly selected data
                set = randSet;
                X_set = Scaled_X(set,:);
                y_set = Scaled_y(set);
            case 4 % Data between 1 and 100, normalized specifically for this case
                set = 1:100;
                X_set = local_Scaled_X(set, :);
                y_set = local_Scaled_y;
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
                if (norm(t - local_optimizers(:,i)) < 1e-2)
                    novel = false;
                end
            end
            if (novel == true)
                lastNovel = iter;
            end
        end
        [m, i] = max(local_optima);
        theta(:, cov_type, data_set) = m;
        fval(:, cov_type, data_set) = local_optima(:,i);
    end
end

save('optimized_theta', 'theta')
save('optimized_fval', 'fval')
