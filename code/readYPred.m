function [y] = readYPred(fileName)
% Reads in data from the file and stores it as a vector.

fileID = fopen(fileName,'r');
formatSpec = '%f';
nCols = 1;

y = fscanf(fileID, formatSpec, [nCols Inf]);
y = y';

fclose(fileID);

