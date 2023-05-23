function [coordinates] = readCoordinates(NumNodes)
% Specify the file name
filename = 'Coordinates.xlsx';
SheetName = sprintf('Tpop%d',NumNodes);
% Read the values from the Excel file
coordinates = readmatrix(filename,'Sheet', SheetName);
%data = readtable(filename, 'Sheet', sheetName);
% Display the values
%disp(data);

end