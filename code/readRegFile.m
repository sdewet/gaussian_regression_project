function reg_data = readRegFile()
% Reads in data from the file and stores it as a matrix.

fileName = 'outvals';
path = '../workdir/sample_model_build_runs/lm/';

fileID = fopen([path fileName],'r');
formatSpec = '%d';
nCols = 33-6+1; 
for i = 2:nCols
    formatSpec = [formatSpec ' %f'];
end

reg_data = fscanf(fileID, formatSpec, [nCols Inf]);
reg_data = reg_data';

fclose(fileID);
