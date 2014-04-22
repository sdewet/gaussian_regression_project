function data = readData()
% Reads in data from the file and stores it as a matrix.

fileName = 'prod_data_v.txt';
path = '../workdir/';

fileID = fopen([path fileName],'r');
formatSpec = '%d';
nCols = 33;
for i = 2:nCols
    formatSpec = [formatSpec ' %f'];
end

data = fscanf(fileID, formatSpec, [nCols Inf]);
data = data';

fclose(fileID);
