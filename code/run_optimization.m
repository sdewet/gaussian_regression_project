%function [theta, y_val] = run_optimization()

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
%theta = zeros(D+2,4,4);
%fval = zeros(4,4);

for cov_type = 2:4
 	[theta(:, cov_type, 1), fval(cov_type, 1)] = optimize_hyperparams( Scaled_X(1:100,:), Scaled_y(1:100), cov_type);
 	[theta(:, cov_type, 2), fval(cov_type, 2)] = optimize_hyperparams( Scaled_X(101:200,:), Scaled_y(101:200), cov_type);
 	randSet = randperm(nData, 100);
 	[theta(:, cov_type, 3), fval(cov_type, 3)] = optimize_hyperparams( Scaled_X(randSet,:), Scaled_y(randSet), cov_type);

	% Also - check to see if this makes things better.  (Scale the sample separately.)
	% This would mean that we would scale 1-10000, then rescale at each time step.
	SampleSize = 100;
	Scaled_X = zeros(SampleSize, D);
	mean_y = mean(y(1:SampleSize));
	stdev_y = std(y(1:SampleSize));
	mean_X = mean(X(1:SampleSize, :),1);
	stdev_X = std(X(1:SampleSize, :),0,1);
	Scaled_y = y - mean_y;
	for i = 1:N
		Scaled_X(i,:) = (X(i,:) - mean_X) ./ stdev_X;
	end
	[theta(:, cov_type, 4), fval(cov_type, 4)] = optimize_hyperparams( Scaled_X(1:100,:), Scaled_y(1:100), cov_type);

end

save('optimized_theta', 'theta')
save('optimized_fval', 'fval')
