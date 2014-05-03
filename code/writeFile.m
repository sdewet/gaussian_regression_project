function writeFile(matrix, fName)

path = '../data/';

dlmwrite([path fName],matrix,...  %# Print the matrix
         'delimiter','\t',...
         'newline','unix');
end