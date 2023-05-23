% first we declare owr basic variables
global NumNodes;
nodeSizeValue = NumNodes;
global maxIteration;
maxIteration = 30;
global PopSize 
PopSize = 160;
coordinates = readCoordinates(nodeSizeValue);
NumNodes = length(coordinates);
numBeaconNodes = 20 * NumNodes / 100;
global NumUnkownNodes ;
NumUnkownNodes = NumNodes - numBeaconNodes;

distBeaconNodes = 20 ; % the RSSI or the range of beacon nodes 

%beaconNodes = [5, 10; 18, 26; 15, 30; 20, 35; 25, 25; 30, 40; 35, 14; 40, 20; 42, 10; 50, 5]; % beacon nodes coordinates define from Gps or config manual
beaconNodes = coordinates(1:numBeaconNodes,:);

sumError = 0 ;
sumError_b = 0 ;
%numBeaconNodes = length(beaconNodes);
%disp(numBeaconNodes);
% define the empty metrix NaN (valeur manquante)
%coordinates = NaN(NumUnkownNodes + numBeaconNodes,2);

% Fill the matrix with coordinates of beacon nodes
%coordinates(1:numBeaconNodes , :) = beaconNodes;
estimatePosition = NaN(NumUnkownNodes + numBeaconNodes,2);
estimatePosition_b = NaN(NumUnkownNodes + numBeaconNodes,2);
errorPosition = [];
errorPosition_b = [];
reelPosition = NaN(NumUnkownNodes + numBeaconNodes,2);
% Fill the rest of table with random coordinates of unkown nodes

jn = numBeaconNodes+1;
for i = 1:40
    reelPosition(i, :) = coordinates(jn, :);
    jn = jn + 1 ;
end
% Plot the anchor nodes and the unknown nodes
figure(1)
scatter(coordinates(1:numBeaconNodes, 1), coordinates(1:numBeaconNodes, 2),100, 'r','square');
hold on;
scatter(coordinates(numBeaconNodes+1:end, 1), coordinates(numBeaconNodes+1:end, 2), 'b');
title('Coordonnees des noeuds'); % set the title for the graph
xlabel('Ligne');
ylabel('Colonne');
legend('Noeuds balises', 'Noeuds inconnus');

numBeaconNodes_1 = numBeaconNodes;

% claculate the distance between beacon nodes and unkown nodes
i = (numBeaconNodes + 1);
while  i <= (numBeaconNodes + NumUnkownNodes)
    unknownNodePosition = [];
    beaconInRange = [];
    beaconTabOfUnkownNode = [];
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
       estimatedPosition = findPosition(unknownNodePosition, beaconInRange);
       estimatedPosition_b = findPosition_b(unknownNodePosition, beaconInRange);
       estimatePosition = [estimatePosition;estimatedPosition(:,1:2)];
       errorPosition = [errorPosition;estimatedPosition(:,3)];
       sumError = sumError + estimatedPosition(:,3);
       disp(estimatedPosition);
       estimatePosition_b = [estimatePosition_b;estimatedPosition_b(:,1:2)];
       errorPosition_b = [errorPosition_b;estimatedPosition_b(:,3)];
       sumError_b = sumError_b + estimatedPosition_b(:,3);
       (estimatedPosition_b);
       numBeaconNodes_1 = numBeaconNodes_1 + 1 ;
       i =i +1;
    else
        ithRow = coordinates(i, :);
        coordinates(i, :) = [];
        coordinates = [coordinates; ithRow];
    end
end
%disp(sumError);
%disp(sumError_b);
%disp(errorPosition_b);
ErForPupulationCase(errorPosition_b,errorPosition,PopSize);

%ErForIterationCase(errorPosition_b,errorPosition,maxIteration);
figure(2)
makeGraph(beaconNodes, estimatePosition, reelPosition);
figure(3)
makeGraph(beaconNodes, estimatePosition_b, reelPosition);
figure(4)
errorGraph(errorPosition, errorPosition_b);
