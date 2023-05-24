
% Specify the file name
filename = 'ErForPopulationCase.xlsx';
SheetNames = sheetnames(filename);

% Filter the sheet names to select those starting with 'p'
selectedPSheetNames = {};
selectedSSheetNames = {};
selectedTSheetNames = {};
for i = 1:length(SheetNames)
    if startsWith(SheetNames{i}, 'F', 'IgnoreCase', true)
        selectedPSheetNames{end+1} = SheetNames{i};
    else if startsWith(SheetNames{i}, 'S', 'IgnoreCase', true)
            selectedSSheetNames{end+1} = SheetNames{i};
         else
            selectedTSheetNames{end+1} = SheetNames{i};
         end
    end
end
% Read the data from the selected sheets and extract the column named "Moyenne"
selectedSheetNames = {selectedPSheetNames, selectedSSheetNames, selectedTSheetNames};



ListSheets = {'FMnPop', 'SMnPop', 'TMnPop'};
for j = 1 : length(selectedSheetNames) 
PopulationSheet = selectedSheetNames{j};
Sheets = ListSheets{j};
columnData = cell(1, length(PopulationSheet));

Tab = [];
rate = [];
STD_BGA = [];
STD_EGA = [];
for i = 1:length(PopulationSheet)
    % Read the data from the Excel file into a table
    data = readtable(filename, 'Sheet', PopulationSheet{i});
    %disp(data);
    values = data{1, 2:end-1};
    
    values_E = data{2, 2:end-1};

    stdValue = std(values);
    stdValue_E = std(values_E);
    % Extract the column named "Moyenne"
    columnData{i} = data.Moyenne;
    Tab = [Tab ,columnData{i}];
    %rate =[rate, Tab(2,i) / Tab(1,i)];
    STD_BGA = [STD_BGA ,stdValue];
    STD_EGA = [STD_EGA ,stdValue_E];
end


% Convert columnData to a vertical array
columnDataVertical = vertcat(columnData{:});

% Display the column data
columnDataForDGA = columnDataVertical(1:(length(columnDataVertical)/2));
columnDataForEGA = columnDataVertical((length(columnDataVertical)/2)+1:end);
%data = [columnDataForDGA, columnDataForEGA];
% Create a new table to store the column data
Pop_BEGA = [Tab ; STD_BGA;STD_EGA];
%Pop_EGA = [Pop_BGA ;STD_EGA];

newTable = array2table(Pop_BEGA, 'VariableNames', PopulationSheet);
% Create a new table to store the column data

%PopulationSheet = PopulationSheet';
%newTable = table(PopulationSheet,columnDataForDGA, columnDataForEGA, 'VariableNames', {'POP','DGA', 'EGA'});

nameofRow = {'BGA'; 'EGA';'STD_BGA';'STD_EGA'}; % Specify the names of the rows as a cell array
rowTable = table(nameofRow, 'VariableNames', {' '}); % Create a table for the row names
tabb = horzcat(rowTable, newTable);
% Write the new table to a new Excel file
newFilename = 'MyErrPopCase.xlsx';
writetable(tabb, newFilename, 'Sheet', Sheets);
HistoGraph(Tab,j);
end



