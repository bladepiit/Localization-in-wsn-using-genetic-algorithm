global NumNodes;
NumNodes = 50 ;
ListSheets = {'Fpop', 'Spop', 'Tpop'};
for j = 1 : length(ListSheets)
Sheets = ListSheets{j};
coordinates = NaN(NumNodes,2);
for i = 1 : NumNodes
    % genirate the random value
    rowCoord = randi([1, 50]);
    colCoord = randi([1, 50]);
    
    coordinates(i, :) = [rowCoord,colCoord];
    
end
SCord(coordinates,Sheets);
end
