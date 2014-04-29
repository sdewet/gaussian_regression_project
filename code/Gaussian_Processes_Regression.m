function Gaussian_Processes_Regression()

%Call readProcessedData to get our data from the file into y and X 
[y, X] = readProcessedData();

mean_y = mean(y);
stdev_y = std(y);

%Strategy 1: Keep those rows for which mean_y - stdev_y <= y <= mean_y +
%stdev_y
y_outliers = (mean_y - stdev_y) <= y & y <= (mean_y + stdev_y);
Pruned_X = X(y_outliers, :);
Pruned_y = y(y_outliers);


%Strategy 2: Keep those rows for which y <= mean_y - stdev_y and y >= 
%mean_y + stdev_y
% y_outliers = y <= (mean_y - stdev_y) & y >= (mean_y + stdev_y);
% Pruned_X = X(y_outliers, :);
% Pruned_y = y(y_outliers);

%Strategy 3: No strategies
% Pruned_X = X;
% Pruned_y = y;

%Calculate the mean and std_dev of the pruned X and y
mean_Pruned_X = mean(Pruned_X,1);
stdev_Pruned_X = std(Pruned_X,0,1);

mean_Pruned_y = mean(Pruned_y);

%Scaled data with 0 mean and 1 variance
Scaled_X = zeros(size(Pruned_X));
Scaled_y = zeros(size(Pruned_y));
for i = 1:size(Pruned_X,1)
    Scaled_X(i,:) = (Pruned_X(i,:) - mean_Pruned_X) ./ stdev_Pruned_X;
    Scaled_y(i) = Pruned_y(i) - mean_Pruned_y;
end

Design_X = Scaled_X'; Design_y = Scaled_y';

%Select the hyper-parameters
sigma_f = 1.0; sigma_n = 0.1;
l = ones(size(Design_X,1),1);   %All characteristic length scales are initialized to 1

%Build the Gram matrix, K
num_examples = size(Design_X,2);
K = ones(num_examples);
for i=1:num_examples
    for j=i:num_examples        
        K(i,j) = Squared_Exponential(X(:,i), X(:,j), sigma_f, l, diag_elem);   
        if (i == j)
            K(i,j) = K(i,j) + sigma_n^2;  %Add noise to the diag elem of K
        else
            K(j,i) = K(i,j);  %K should be symmetric
        end
    end
end

end

function k_elem = Squared_Exponential(x_p, x_q, sigma_f, l)
x_diff
k_elem = sigma_f^2 * exp(
end

function k_elem = Ornstein_Uhlenbeck (x_p, x_q, sigma_f, l)

end