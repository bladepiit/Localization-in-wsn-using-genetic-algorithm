function [coordinates] = SCord(coordinates,Sheets)
% Définir les données des tableaux

values = coordinates;
filename = 'Coordinates.xlsx';
%sheets = sheetnames(filename);
% Write the values to the Excel file vertically
%xlswrite(filename, values);
%SheetName = sprintf(Sheets,'%d',length(coordinates));
%if any(strcmp(sheets, SheetName)) %ismember(SheetName, Sheet)
%    SheetName = sprintf('pop%d',length(coordinates) + rand(1:2));
%end

writematrix(values, filename, 'Sheet', Sheets);
end