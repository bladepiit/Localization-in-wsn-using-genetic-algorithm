% Specify the file name
filename = 'ErrorRateInNodeCase.xlsx';
SheetNames = sheetnames(filename);

Tab = [];
STD_BGA = [];
STD_EGA = [];
for index = 1 : length(SheetNames)
    currentSheet = SheetNames(index);
    
   
    columnData = cell(1, length(SheetNames));
    

    % Read the data from the Excel file into a table
    data = readtable(filename, 'Sheet', currentSheet);

    values_BGA = data{1, 2:end-1};
    
    values_EGA = data{2, 2:end-1};

    stdValueBGA = std(values_BGA);
    stdValueEGA = std(values_EGA);
    % Extract the column named "Moyenne"
    columnData{index} = data.Moyenne;
    
    Tab = [Tab ,columnData{index}];
    
    STD_BGA = [STD_BGA ,stdValueBGA];
    STD_EGA = [STD_EGA ,stdValueEGA];
    
end

% Create a new table to store the column data
Nodes_BEGA = [Tab ; STD_BGA ;STD_EGA];

newTable = array2table(Nodes_BEGA, 'VariableNames', SheetNames);

nameofRow = {'BGA'; 'EGA';'STD_BGA';'STD_EGA'}; % Specify the names of the rows as a cell array
rowTable = table(nameofRow, 'VariableNames', {' '}); % Create a table for the row names
tabb = horzcat(rowTable, newTable);

% Write the new table to a new Excel file
newFilename = 'AverageErrorRateInNodesCase.xlsx';
writetable(tabb, newFilename, 'Sheet', 'average');
