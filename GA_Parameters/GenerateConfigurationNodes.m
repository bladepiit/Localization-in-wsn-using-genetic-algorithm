ListOfNodes = [40, 100, 200, 500, 1000];

ListSheets = {'Nodes_40', 'Nodes_100', 'Nodes_200', 'Nodes_500', 'Nodes_1000'};
for index = 1 : length(ListOfNodes)
Sheets = ListSheets{index};
coordinates = NaN(ListOfNodes(index),2);
for i = 1 : ListOfNodes(index)
    % genirate the random value
    rowCoord = randi([1, 50]);
    colCoord = randi([1, 50]);
    
    coordinates(i, :) = [rowCoord,colCoord];
    
end
SCord(coordinates,Sheets);
end