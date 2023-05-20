% first we declare owr basic variables

NumUnkownNodes = 40 ;
distBeaconNodes = 20 ; % the RSSI or the range of beacon nodes 
popSize = 40;
beaconNodes = [5, 10; 18, 26; 15, 30; 20, 35; 25, 25; 30, 40; 35, 14; 40, 20; 42, 10; 50, 5]; % beacon nodes coordinates define from Gps or config manual

numBeaconNodes = length(beaconNodes);
%disp(numBeaconNodes);
% define the empty metrix NaN (valeur manquante)
coordinates = NaN(NumUnkownNodes + numBeaconNodes,2);

% Fill the matrix with coordinates of beacon nodes
coordinates(1:numBeaconNodes , :) = beaconNodes;

% Fill the rest of table with random coordinates of unkown nodes
for i = (numBeaconNodes+1) : (numBeaconNodes + NumUnkownNodes)
    % genirate the random value
    rowCoord = randi([1, 50]);
    colCoord = randi([1, 50]);
    
    coordinates(i, :) = [rowCoord,colCoord];
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
for i = (numBeaconNodes + 1) : (numBeaconNodes + NumUnkownNodes)
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

       disp(estimatedPosition);
       numBeaconNodes_1 = numBeaconNodes_1 + 1 ;
    end
end


