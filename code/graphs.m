function graphs()
% Reads in data from the file and stores it as a matrix.
addpath '../data/';
folders = dir('../data');
close all;

%        deleted:    data/Predicted_yValues_10000_2trained_with_500vals__0.txt
%         deleted:    data/Predicted_yValues_15000_1trained_with_500vals__0.txt
%         deleted:    data/Predicted_yValues_15000_2_trained_with_500vals__0__msecs800.txt
%         deleted:    data/Predicted_yValues_15000_2trained_with_500vals__0.txt
%         deleted:    data/Predicted_yValues_15000_2trained_with_500vals__0_1000msecs_diff.txt
%         deleted:    data/Predicted_yValues_15000_2trained_with_500vals__0_500msecs_diff.txt
%         deleted:    data/Predicted_yValues_15000_2trained_with_500vals__1.txt
%         deleted:    data/Predicted_yValues_20000_1trained_with_500vals__0.txt
%         deleted:    data/Predicted_yValues_20000_3trained_with_500vals__0.txt
%         deleted:    data/Predicted_yValues_20000_4_trained_with_500vals_rand_0.txt
%         deleted:    data/Predicted_yValues_3000_1trained_with_500vals__2.txt
%         deleted:    data/Predicted_yValues_3000_2trained_with_500vals__2.txt
%         
%       

plotNum = 1;
folder = '../data/data_20000_500_500_0/';
files = cell(1,4);
files{1} = 'Predicted_yValues_20000_1trained_with_500vals__0.txt';
files{2} = 'Predicted_yValues_20000_2trained_with_500vals__0.txt';
files{3} = 'Predicted_yValues_20000_3trained_with_500vals__0.txt';
files{4} = 'Predicted_yValues_20000_4_trained_with_500vals_rand_0.txt';
labels = cell(1,4);
labels{1} = '10 * Predictions with Squared Exponential';
labels{2} = '10 * Predictions with Ornstein-Ulenbeck';
labels{3} = '10 * Predictions with Matern \nu = 3/2';
labels{4} = '10 * Predictions with Matern \nu = 5/2';
titl = 'Different covariance functions, trained with 20000 samples';
xlabl = 'Testing Value #';
ylabl = 'Change in price';



% Do the plot
p = ['../data/', folder, '/']; % path
if exist([p, 'processed_data.txt'], 'file')

     [y, ~] = readProcessedData(p);


    %files = dir(p);
    split_folder_name = regexp(folder,'_','split');       
    n_train_data = str2num(split_folder_name{2});
    y_training = y(1:n_train_data);
    y_result = y(n_train_data+1:n_train_data+500);
    
%     plot (1:n_train_data, y_training,'k');
%     title('Training data');
%     ylabel('Change in stock price');
%     saveas(gcf, 'fig_0.png');
%     close;
%     
    next = 0;
    for j = 1 : numel(files)
        next = next + 1;
        yPredicted(next,:) = readYPred([p, files{j}]);
    end
    x = 1:500;
    plot (x, y_result','k', ...
        x, 10*yPredicted(4,:),'--c', ...
        x, 10*yPredicted(2,:),'--r', ...
        x, 10*yPredicted(3,:),'--b', ...
        x, 10*yPredicted(1,:), '--g');
        
    title(titl)
    xlabel(xlabl)
    ylabel(ylabl)
    xlim([200 400])
    ylim([-1 1.5])
    legend('Test values', labels{1}, labels{2}, labels{3}, labels{4})

    saveas(gcf, ['fig_', num2str(plotNum), '.png']);
end



clear;
plotNum = 2;
folders = cell(1,3);
folders{1} = '../data/data_10000_500_500_0/';
folders{2} = '../data/data_15000_500_500_0/';
folders{3} = '../data/data_20000_500_500_0/';
files = cell(1,3);
files{1} = 'Predicted_yValues_10000_2trained_with_500vals__0.txt';
files{2} = 'Predicted_yValues_15000_2trained_with_500vals__0.txt';
files{3} = 'Predicted_yValues_20000_2trained_with_500vals__0.txt';
labels = cell(1,3);
labels{1} = '10 * Predictions with 10000 Training samples';
labels{2} = '10 * Predictions with 15000 Training samples';
labels{3} = '10 * Predictions with 20000 Training samples';
titl = 'Ornstein-Uhlenbeck with different number of training samples';
xlabl = 'Testing Value #';
ylabl = 'Change in price';

next = 0;
for j = 1 : numel(folders)
    next = next + 1;
    p = ['../data/', folders{j}, '/']; % path
    [y, ~] = readProcessedData(p);
    split_folder_name = regexp(folders{j},'_','split');       
    n_train_data = str2num(split_folder_name{2});
    y_result(next,:) = y(n_train_data+1:n_train_data+500);
    yPredicted(next,:) = readYPred([p, files{j}]);
end

x = 1:500;
subplot(3,1,1);
plot (x, y_result(1,:),'b', ...
    x, 10 * yPredicted(1,:),'--g');
title('10000 Training Samples')
xlabel(xlabl)
ylabel(ylabl)
subplot(3,1,2);
plot(x, y_result(2,:),'b', ...
    x, 10 * yPredicted(2,:),'--g');
title('15000 Training Samples')
xlabel(xlabl)
ylabel(ylabl)
subplot(3,1,3);
plot(x, y_result(3,:),'b', ...
    x, 10*yPredicted(3,:),'--g');
title('20000 Training Samples')
xlabel(xlabl)
ylabel(ylabl)
saveas(gcf, ['fig_', num2str(plotNum), '.png']);



clear;
plotNum = 3;
folders = cell(1,3);
folders{1} = '../data/data_15000_500_500_0/';
folders{2} = '../data/data_15000_500_500_1/';
folders{3} = '../data/data_3000_500_500_2/';
files = cell(1,3);
files{1} = 'Predicted_yValues_15000_2trained_with_500vals__0.txt';
files{2} = 'Predicted_yValues_15000_2trained_with_500vals__1.txt';
files{3} = 'Predicted_yValues_3000_2trained_with_500vals__2.txt';
labels = cell(1,3);
labels{1} = '10 * Predictions with strategy 0';
labels{2} = '10 * Predictions with strategy 1';
labels{3} = '10 * Predictions with strategy 2';
titl = 'Ornstein-Uhlenbeck with different strategies';
xlabl = 'Testing Value #';
ylabl = 'Change in price';

next = 0;
for j = 1 : numel(folders)
    next = next + 1;
    p = ['../data/', folders{j}, '/']; % path
    [y, ~] = readProcessedData(p);
    split_folder_name = regexp(folders{j},'_','split');       
    n_train_data = str2num(split_folder_name{2});
    y_result(next,:) = y(n_train_data+1:n_train_data+500);
    yPredicted(next,:) = readYPred([p, files{j}]);
end

x = 1:500;
subplot(3,1,1);
plot (x, y_result(1,:),'b', ...
    x, 10*yPredicted(1,:),'--g');
title('Strategy 0')
xlabel(xlabl)
ylabel(ylabl)
subplot(3,1,2);
plot(x, y_result(2,:),'b', ...
    x, 10*yPredicted(2,:),'--g');
title('Strategy 1')
xlabel(xlabl)
ylabel(ylabl)
subplot(3,1,3);
plot(x, y_result(3,:),'b', ...
    x, 10*yPredicted(3,:),'--g');
title('Strategy 2')
xlabel(xlabl)
ylabel(ylabl)
saveas(gcf, ['fig_', num2str(plotNum), '.png']);


%LR, NN, PCA Reg vs GPR. Keep window size fixed at 20000, timesecs_diff at 500,
%strategy_type fixed at 0 and Ornstein-Uhlenbeck covariance function 
close all;
plotNum = 4;
barnames = cell(5,1);
barnames{1} = 'Predicted_yValues_10000_2trained_with_500vals__0.txt';
barnames{2} = 'Predicted_yValues_15000_2trained_with_500vals__0_1000msecs_diff.txt';
%barnames{3} = 'Predicted_yValues_15000_1trained_with_500vals__0.txt';
%barnames{4} = 'Predicted_yValues_15000_2trained_with_500vals__0.txt';
%barnames{5} = 'Predicted_yValues_15000_2trained_with_500vals__0_500msecs_diff.txt';
barnames{3} = 'Predicted_yValues_15000_2trained_with_500vals__1.txt';
%barnames{6} = 'Predicted_yValues_15000_2_trained_with_500vals__0__msecs800.txt';
%barnames{7} = 'Predicted_yValues_20000_1trained_with_500vals__0.txt';
%barnames{8} = 'Predicted_yValues_20000_3trained_with_500vals__0.txt';
barnames{4} = 'Predicted_yValues_20000_4_trained_with_500vals_rand_0.txt';
barnames{5} = 'Predicted_yValues_3000_1trained_with_500vals__2.txt';
%barnames{12} = 'Predicted_yValues_3000_2trained_with_500vals__2.txt';

bars = [11.08, -10.96, 3.80; ... %0
    3.86, 4.14, 4.02; ... %1
    %3.86, 4.14, 4.02; ... %2 
    %3.86, 4.14, 4.02; ... %3
    %3.86, 4.14, 4.02; ... %4
    42.88, -57.00, -74.32; ... %5
    %3.86, 4.14, 4.02; ... %6
    %12.87, -8.92, -16.53; ... %7
    %12.87, -8.92, -16.53; ... %8
    12.87, -8.92, -16.53; ... %9
    28.39, -61.22, -76.70]; %... %10
    %28.39, -61.22, -76.70]; %11
bar(1:5, bars)
legend('Our model', 'LM', 'PCA\_reg');
title('Profit');
xlabel('Some experiments from this paper');
ylabel('Profit');

saveas(gcf, ['fig_', num2str(plotNum), '.png']);

% clear;
% plotNum = 5;
% folders = cell(1,3);
% folders{1} = '../data/data_15000_500_500_0/';
% folders{2} = '../data/data_15000_500_800_0/';
% folders{3} = '../data/data_15000_500_1000_0/';
% files = cell(1,3);
% files{1} = 'Predicted_yValues_15000_2trained_with_500vals__0.txt';
% files{2} = 'Predicted_yValues_15000_2_trained_with_500vals__0__msecs800.txt';
% files{3} = 'Predicted_yValues_15000_2trained_with_500vals__0_1000msecs_diff.txt';
% labels = cell(1,3);
% labels{1} = '10 * Predictions for 500 msec in future';
% labels{2} = '10 * Predictions for 800 msec in future';
% labels{3} = '10 * Predictions for 10000 msec in future';
% titl = 'Ornstein-Uhlenbeck with different strategies';
% xlabl = 'Testing Value #';
% ylabl = 'Change in price';
% 
% next = 0;
% for j = 1 : numel(folders)
%     next = next + 1;
%     p = ['../data/', folders{j}, '/']; % path
%     [y, ~] = readProcessedData(p);
%     split_folder_name = regexp(folders{j},'_','split');       
%     n_train_data = str2num(split_folder_name{2});
%     y_result(next,:) = y(n_train_data+1:n_train_data+500);
%     yPredicted(next,:) = readYPred([p, files{j}]);
% end

x = 1:500;
subplot(3,1,1);
plot (x, y_result(1,:),'b', ...
    x, 10*yPredicted(1,:),'--g');
title(labels{1})
xlabel(xlabl)
ylabel(ylabl)
subplot(3,1,2);
plot(x, y_result(2,:),'b', ...
    x, 10*yPredicted(2,:),'--g');
title(labels{2})
xlabel(xlabl)
ylabel(ylabl)
subplot(3,1,3);
plot(x, y_result(3,:),'b', ...
    x, 10*yPredicted(3,:),'--g');
title(labels{3})
xlabel(xlabl)
ylabel(ylabl)
saveas(gcf, ['fig_', num2str(plotNum), '.png']);


