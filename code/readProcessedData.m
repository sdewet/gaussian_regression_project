function [y, X] = readProcessedData(dir)
% Reads in data from the file and stores it as a matrix.
addpath '../data/';

fileName = [dir, 'processed_data.txt'];

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
