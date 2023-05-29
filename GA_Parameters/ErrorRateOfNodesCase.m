function ErrorRateOfNodesCase(FileOfAverageErrorRateForAllBGA,FileOfAverageErrorRateForAllEGA,currentSheet)
% Calculer la somme des valeurs
    AverageErrorRateForBGA = sum(FileOfAverageErrorRateForAllBGA) / length(FileOfAverageErrorRateForAllBGA);
    AverageErrorRateForEGA = sum(FileOfAverageErrorRateForAllEGA) / length(FileOfAverageErrorRateForAllEGA);

    % Generate the variable names based on the column index
    
    numColumns = length(FileOfAverageErrorRateForAllBGA);
    variableNames = cell(1, numColumns);
    for i = 1:numColumns
        variableNames{i} = sprintf('Value%d', i);
    end

    % Create a table with values and sums
    data = [FileOfAverageErrorRateForAllBGA(:), FileOfAverageErrorRateForAllEGA(:)];
    sumData = [AverageErrorRateForBGA; AverageErrorRateForEGA];

    tableData = array2table(data', 'VariableNames', variableNames);
    sumTable = array2table(sumData, 'VariableNames', {'Moyenne'});


    nameofRow = {'BGA'; 'EGA'}; % Specify the names of the rows as a cell array
    rowTable = table(nameofRow, 'VariableNames', {' '}); % Create a table for the row names

    tabb = horzcat(rowTable, tableData);
    tabb = horzcat(tabb, sumTable); % Concatenate the sumTable with the tabb table

    % Write the tables to the Excel file
    filename = 'ErrorRateInNodeCase.xlsx';
    writetable(tabb, filename, 'Sheet', currentSheet);

end