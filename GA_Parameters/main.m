% first we declare owr basic variables
global NumNodes;
nodeSizeValue = NumNodes;
global maxIteration;
maxIteration = 30;
filename = 'Coordinates.xlsx';
SheetNames = sheetnames(filename);
for s = 1:length(SheetNames)
EName = SheetNames(s);
coordinates = readCoordinates(nodeSizeValue,EName);
NumNodes = length(coordinates);
numBeaconNodes = 20 * NumNodes / 100;
global NumUnkownNodes ;
NumUnkownNodes = NumNodes - numBeaconNodes;

ListPop = [10,20,40,80,160];

distBeaconNodes = 20 ; % the RSSI or the range of beacon nodes 

%beaconNodes = [5, 10; 18, 26; 15, 30; 20, 35; 25, 25; 30, 40; 35, 14; 40, 20; 42, 10; 50, 5]; % beacon nodes coordinates define from Gps or config manual
beaconNodes = coordinates(1:numBeaconNodes,:);

reelPosition = NaN(NumUnkownNodes + numBeaconNodes,2);
jn = numBeaconNodes+1;
for i = 1:NumUnkownNodes
    reelPosition(i, :) = coordinates(jn, :);
    jn = jn + 1 ;
end

% Plot the anchor nodes and the unknown nodes
%figure(1)
%scatter(coordinates(1:numBeaconNodes, 1), coordinates(1:numBeaconNodes, 2),100, 'r','square');
%hold on;
%scatter(coordinates(numBeaconNodes+1:end, 1), coordinates(numBeaconNodes+1:end, 2), 'b');
%title('Coordonnees des noeuds'); % set the title for the graph
%xlabel('Ligne');
%ylabel('Colonne');
%legend('Noeuds balises', 'Noeuds inconnus');



for L = 1 : length(ListPop)
global PopSize 
PopSize = ListPop(L);


TauxError = [] ;
TauxError_b = [] ;
estimatePositionChoise = NaN(NumUnkownNodes + numBeaconNodes,2);
estimatePositionChoise_b = NaN(NumUnkownNodes + numBeaconNodes,2);
%numBeaconNodes = length(beaconNodes);
%disp(numBeaconNodes);
% define the empty metrix NaN (valeur manquante)
%coordinates = NaN(NumUnkownNodes + numBeaconNodes,2);

% Fill the matrix with coordinates of beacon nodes
%coordinates(1:numBeaconNodes , :) = beaconNodes;

errorPosition = [];
errorPosition_b = [];




numBeaconNodes_1 = numBeaconNodes;

% claculate the distance between beacon nodes and unkown nodes
i = numBeaconNodes + 1;
while  i <= (numBeaconNodes + NumUnkownNodes)
    unknownNodePosition = [];
    beaconInRange = [];
    beaconTabOfUnkownNode = [];
    estimatePosition = [];
    estimatePosition_b = [];
    Error = 0;
    Error_b = 0;
    count = 0 ;
    for j = 1 : numBeaconNodes_1  
        distance = Distance_Calculation(coordinates(i,:),coordinates(j,:));
        % when the unknown node is within range of the beacon node
        if distance < distBeaconNodes 
            count = count+1;
            beaconTabOfUnkownNode(end+1,:) = [coordinates(j,1),coordinates(j,2)];
        end

        if size(beaconTabOfUnkownNode,1) >= 3
           unknownNodePosition = coordinates(i,:);
           beaconInRange = beaconTabOfUnkownNode;
        end
    end
    outputStr = sprintf('Unknown node position: %s\nBeacon in range: %s', mat2str(unknownNodePosition), mat2str(beaconInRange));
    disp(outputStr);
    if ~isnan(beaconInRange)
       for itrg = 1 : 30
       estimatedPosition = findPosition(unknownNodePosition, beaconInRange);
       estimatePosition = [estimatePosition;estimatedPosition(:,:)];
       %errorPosition = [errorPosition;estimatedPosition(:,3)];
       Error = Error + estimatedPosition(:,3);
       
       estimatedPosition_b = findPosition_b(unknownNodePosition, beaconInRange);
       estimatePosition_b = [estimatePosition_b;estimatedPosition_b(:,:)];
       %errorPosition_b = [errorPosition_b;estimatedPosition_b(:,3)];
       Error_b = Error_b + estimatedPosition_b(:,3);
       end
      
       estimatePositionEvatuate = evaluate(estimatePosition); 
       estimatePositionEvatuateChoise = estimatePositionEvatuate(1,:);
       disp(estimatePositionEvatuateChoise);
       estimatePositionChoise = [estimatePositionChoise;estimatePositionEvatuateChoise(:,1:2)];

       estimatePositionEvatuate_b = evaluate_b(estimatePosition_b);
       estimatePositionEvatuateChoise_b = estimatePositionEvatuate_b(1,:);
       estimatePositionChoise_b = [estimatePositionChoise_b;estimatePositionEvatuateChoise_b(:,1:2)];
       MoyenneError = Error / 30;
      
       TauxError = [TauxError;MoyenneError];
       MoyenneError_b = Error_b / 30;
       TauxError_b = [TauxError_b;MoyenneError_b];
       numBeaconNodes_1 = numBeaconNodes_1 + 1 ;
       i =i +1;
    else
        ithRow = coordinates(i, :);
        coordinates(i, :) = [];
        coordinates = [coordinates; ithRow];
    end
end

%disp(sumError_b);
%disp(errorPosition_b);
ErForPupulationCase(TauxError_b,TauxError,PopSize,EName);

%ErForIterationCase(errorPosition_b,errorPosition,maxIteration);
%figure(2)
%makeGraph(beaconNodes, estimatePositionChoise, reelPosition);
%figure(3)
%makeGraph(beaconNodes, estimatePositionChoise_b, reelPosition);
figure(4)
errorGraph(TauxError, TauxError_b);
end
end