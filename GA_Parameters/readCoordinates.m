function [coordinates] = readCoordinates(NumNodes,EName)
% Specify the file name
filename = 'Coordinates.xlsx';
%SheetName = sprintf('Fpop%d',NumNodes);
% Read the values from the Excel file
coordinates = readmatrix(filename,'Sheet', EName);
%data = readtable(filename, 'Sheet', sheetName);
% Display the values
%disp(data);

end