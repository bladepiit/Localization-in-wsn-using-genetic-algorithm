function ErForPupulationCase(ErForBasicAlgo, ErForEnhAlgo,NumUnkownNodes,EName)

    % Calculer la somme des valeurs
    MynForBasedGA = sum(ErForBasicAlgo) / length(ErForBasicAlgo);
    MynForEnhGA = sum(ErForEnhAlgo) / length(ErForEnhAlgo);

    % Generate the variable names based on the column index
    
    numColumns = length(ErForBasicAlgo);
    variableNames = cell(1, numColumns);
    for i = 1:numColumns
        variableNames{i} = sprintf('Value%d', i);
    end
   % variableNames = {'value'};
    % Créer une table avec les valeurs et les sommes
    data = [ErForBasicAlgo(:), ErForEnhAlgo(:)];
    sumData = [MynForBasedGA; MynForEnhGA];

    tableData = array2table(data', 'VariableNames', variableNames);
    sumTable = array2table(sumData, 'VariableNames', {'Moyenne'});

    nameofRow = {'Bised GA'; 'Enhancement GA'}; % Specify the names of the rows as a cell array
    rowTable = table(nameofRow, 'VariableNames', {'AlgoName'}); % Create a table for the row names

    % Split the nested table variables
    tableDataSplit = splitvars(tableData);

    % Vertically concatenate the rowTable and tableData
    %tabb = [rowTable; tableData];
    tabb = horzcat(rowTable, tableData);
    tabb = horzcat(tabb, sumTable); % Concatenate the sumTable with the tabb table

    % Écrire les tables dans le fichier Excel
    filename = 'ErForPopulationCase.xlsx';
    % Read the existing sheets in the file
    %existingSheets = sheetnames(filename);
    % Generate the new sheet name
    %SheetName = sprintf('Sheet%d', length(existingSheets) + 1);
    SheetName = sprintf('%s%d', EName, NumUnkownNodes);
    writetable(tabb, filename, 'Sheet', SheetName);

end
