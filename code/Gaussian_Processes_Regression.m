function Gaussian_Processes_Regression(windowSize, cov_type)

%Call readProcessedData to get our data from the file into y and X 
[y, X] = readProcessedData();

mean_y = mean(y);
stdev_y = std(y);

%Strategy 1: Keep those rows for which mean_y - stdev_y <= y <= mean_y +
%stdev_y
% y_inliers = (mean_y - stdev_y) <= y & y <= (mean_y + stdev_y);
% Pruned_X = X(y_inliers, :);
% Pruned_y = y(y_inliers);


%Strategy 2: Keep those rows for which y <= mean_y - stdev_y and y >= 
%mean_y + stdev_y
% y_outliers = y <= (mean_y - stdev_y) & y >= (mean_y + stdev_y);
% Pruned_X = X(y_outliers, :);
% Pruned_y = y(y_outliers);

%Strategy 3: No strategies
Pruned_X = X;
Pruned_y = y;

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

X_Window = Design_X(:,1:windowSize); y_Window = Design_y(1:windowSize);
ctr = windowSize;

%Select the hyper-parameters
sigma_f = 1.0; sigma_n = 0.1;
l = ones(size(X_Window,1),1)';   %All characteristic length scales are initialized to 1

%Check to see whether K is stored. If not, build the matrix from scratch
num_examples = size(X_Window,2);
K = zeros(num_examples);
fileName = 'K_Matrix';
fileName = strcat(fileName, '_', num2str(windowSize),'_', num2str(cov_type), '.txt');
path = '../data/';
if exist([path fileName], 'file')
   K = dlmread([path fileName],'\t');
else
    %Build the Gram matrix - K, using all of the data in X_Window
    fprintf('Building the initial Gram matrix - K using %d examples \n', windowSize);        
    for i=1:num_examples
        for j=i:num_examples  
            switch cov_type
                case 1
                    K(i,j) = Squared_Exponential(X_Window(:,i), X_Window(:,j), sigma_f, l);
                case 2
                    K(i,j) = Ornstein_Uhlenbeck(X_Window(:,i), X_Window(:,j), sigma_f, l);
                case 3
                    K(i,j) = Matern(X_Window(:,i), X_Window(:,j), sigma_f, l, (5/2));
                case 4
                    K(i,j) = Matern(X_Window(:,i), X_Window(:,j), sigma_f, l, (3/2));
                otherwise
                    error('Wrong covariance function type. Please try again!');                    
            end
            if (i == j)
                K(i,j) = K(i,j) + sigma_n^2;  %Add noise to the diag elem of K
            else
                K(j,i) = K(i,j);  %K should be symmetric
            end
        end
        if (mod(i,100) == 0)
            fprintf('Finished building row no. %d\n', i);
        end
    end
    writeFile(K, fileName);
end


%Train the hyperparameters of the initial K matrix


Predicted_yValues = [];
while (ctr < size(Design_X,2))        
    
    %Build the delta Gram matrix
    if (ctr ~= windowSize)
        K(1,:) = []; K(:,1) = [];
        new_X = X_Window(:,end);
        k_delta = ones(num_examples,1);
        for i=1:num_examples  
            switch cov_type
                case 1
                    k_delta(i) = Squared_Exponential(X_Window(:,i), new_X, sigma_f, l);
                case 2
                    k_delta(i) = Ornstein_Uhlenbeck(X_Window(:,i), new_X, sigma_f, l);
                case 3
                    k_delta(i) = Matern(X_Window(:,i), new_X, sigma_f, l, (5/2));
                case 4
                    k_delta(i) = Matern(X_Window(:,i), new_X, sigma_f, l, (3/2));
                otherwise
                    error('Wrong covariance function type. Please try again!');                    
            end
            if (i == num_examples)
                k_delta(i) = k_delta(i) + sigma_n^2;  %The last elem of k_delta represents K(new_X, new_X)
            end
        end
        K = [K, k_delta(1:(end-1))]; K = [K; k_delta'];
    
        %Train the hyperparameters
        
    end    


    %Predict the change in stock price for the next time instant
    
    k_star = ones(num_examples,1);
    x_star = Design_X(:,(ctr+1));
    for i=1:num_examples  
        switch cov_type
            case 1
                k_star(i) = Squared_Exponential(X_Window(:,i), x_star, sigma_f, l);
            case 2
                k_star(i) = Ornstein_Uhlenbeck(X_Window(:,i), x_star, sigma_f, l);
            case 3
                k_star(i) = Matern(X_Window(:,i), x_star, sigma_f, l, (5/2));
            case 4
                k_star(i) = Matern(X_Window(:,i), x_star, sigma_f, l, (3/2));
            otherwise
                error('Wrong covariance function type. Please try again!');                    
        end
    end
    L = chol(K, 'lower');
    alpha = L'\(L\y_Window');
    %We need to rescale the predicted y by adding back the mean
    predicted_y = (k_star' * alpha) + mean_Pruned_y;      % Also, our predicted change in price is the mean of the gaussian posterior
    Predicted_yValues = [Predicted_yValues; predicted_y];
    fprintf('Finished prediction of Data Point no. %d\n', (ctr+1));
    
    %
    ctr = ctr+1;
    X_Window = [X_Window, Design_X(:,ctr)];
    X_Window(:,1)=[];
    %y_Window = [y_Window, Design_y(ctr)];
    y_Window = [y_Window, predicted_y];
    y_Window(1) = [];

end %end of while

fileName = 'Predicted_yValues.txt';
fileName = strcat(fileName, '_', num2str(windowSize),'_', num2str(cov_type), '.txt');
writeFile(Predicted_yValues, fileName);
end %end of function

function k_elem = Squared_Exponential(x_p, x_q, sigma_f, l)
l = l.^(-2); M = diag(l);
k_elem = sigma_f^2 * exp( (-1/2) * (x_p - x_q)' * M * (x_p - x_q));
end

function k_elem = Ornstein_Uhlenbeck (x_p, x_q, sigma_f, l)
l = l.^(-2); M = diag(l);
k_elem = sigma_f^2 * exp( -1 * sqrt((x_p - x_q)' * M * (x_p - x_q)));
end

function k_elem = Matern(x_p, x_q, sigma_f, l, nu)
l = l.^(-2); M = diag(l);
if nu == (5/2)
    k_elem = sigma_f^2 * ( 1 + sqrt(5 * ((x_p - x_q)' * M * (x_p - x_q))) + (5/3) * ((x_p - x_q)' * M * (x_p - x_q))) * exp( -1 * sqrt(5 * ((x_p - x_q)' * M * (x_p - x_q))));
elseif nu == (3/2)
    k_elem = sigma_f^2 * ( 1 + sqrt(3 * ((x_p - x_q)' * M * (x_p - x_q)))) * exp( -1 * sqrt(3 * ((x_p - x_q)' * M * (x_p - x_q))));
end
end