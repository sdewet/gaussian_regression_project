function graphs()
% Reads in data from the file and stores it as a matrix.
addpath '../data/';
folders = dir('../data');
for i = 1 : numel(folders)
    if (folders(i).isdir == 1 && ~strcmp(folders(i).name,'.') && ~strcmp(folders(i).name,'..'))
        p = ['../data/', folders(i).name, '/']; % path
        if exist([p, 'processed_data.txt'], 'file')
        
            [y, ~] = readProcessedData(p);

            files = dir(p);
            split_folder_name = regexp(folders(i).name,'_','split');       
            n_train_data = str2num(split_folder_name{2});
            y_training = y(1:n_train_data);
            y_result = y(n_train_data+1:n_train_data+500);
            next = 0;
            for j = 1 : numel(files)
                if files(j).isdir == 0 && (strcmp('Predicted_yValues',files(j).name(1:17)) == 1)
                    next = next + 1;
                    yPredicted(next,:) = readYPred([p, files(j).name]);
                end
            end
            figure;
            plot (1:n_train_data, y_training,'k.');
            hold
            title('Plot for training with 20000 samples')
            xlabel('sample #')
            ylabel('Change in price')
            legend('Training values','Test values')
            plot (n_train_data+1:n_train_data+500, y_result,'bo');
            for j = 1 : next
                plot (n_train_data+1:n_train_data+500, yPredicted(j,:),'c*');
            end
            saveas(gcf, 'fig_i.png');
        end
        
        
    end
end



fileName = 'processed_data.txt';

fileID = fopen(fileName,'r');
formatSpec = '%f';
nCols = 33-6+1;
for i = 2:nCols
    formatSpec = [formatSpec ' %f'];
end

data = fscanf(fileID, formatSpec, [nCols Inf]);
data = data';

fclose(fileID);

y = data(:,1);
X = data(:,2:nCols);
