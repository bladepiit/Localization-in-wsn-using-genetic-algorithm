% first we declare owr basic variables
global numNodes;
global IterationForNodes ;
IterationForNodes = 30 ; 
IterationForGA = 30 ;
RSSI = 20 ; % the RSSI or the range of beacon nodes 


filename = 'Coordinates.xlsx'; % specifies the name of the Excel file that will be used
SheetNames = sheetnames(filename);% The sheetnames function is used to extract the sheet names from the Excel file.

for SheetIndex = 1 : length(SheetNames)
    % Get the name of the current sheet
    currentSheet = SheetNames(SheetIndex);
    Conf = readCoordinates(currentSheet);
    % Perform operations on the current sheet
    numNodes = length(Conf); % Get the number of nodes from the Conf variable
    NumBeaconNodes = 20 * numNodes / 100; % Calculate the number of beacon nodes based on a percentage
    
    global NumUnkownNodes ; % Declare a global variable to store the number of unknown nodes for use in anther place
    NumUnkownNodes = numNodes - NumBeaconNodes; % Calculate the number of unknown nodes

    ListPopulation = [10,20,40,80,160]; % Define a list of population values
    beaconNodesPossition = Conf(1:NumBeaconNodes,:);
    UnkownNodesReelPosition = Conf(NumBeaconNodes+1:end,:);
    for popIteration = 1 : length(ListPopulation)
        global PopSize;
        PopSize = ListPopulation(popIteration);
        
        FileOfAverageErrorRateForAllEGA = [];
        FileOfAverageErrorRateForAllBGA = [];
        for IterationGA = 1 : IterationForGA
            outputIteration = sprintf('%s Iteration GA Round',mat2str(IterationGA));
            disp(outputIteration);

            % claculate the distance between beacon nodes and unkown nodes
            ErrorRateForOneIterationEGA = [];
            ErrorRateForOneIterationBGA = [];

            numBeaconNodes = NumBeaconNodes;
            UnknownNodeIndex = numBeaconNodes + 1;
            while UnknownNodeIndex <= numNodes
                beaconTabOfUnkownNode = [];
                unknownNodePosition = [];

                for BeaconNodeIndex = 1 : numBeaconNodes
                    distanceBeaconUnknown = Distance_Calculation(Conf(UnknownNodeIndex,:),Conf(BeaconNodeIndex,:));
                    % when the unknown node is within range of the beacon node
                    if distanceBeaconUnknown < RSSI
                        beaconTabOfUnkownNode(end+1,:) = [Conf(BeaconNodeIndex,1),Conf(BeaconNodeIndex,2)];
                    end
                end
                if size(beaconTabOfUnkownNode,1) >= 3
                    unknownNodePosition = Conf(UnknownNodeIndex,:);
                    % Estimate Position for EGA
                    estimatedPositionEGA = findPosition(unknownNodePosition, beaconTabOfUnkownNode);
                    ErrorRateForOneIterationEGA = [ErrorRateForOneIterationEGA;estimatedPositionEGA(:,3)];

                    % Estimate Position for BGA
                    estimatedPositionBGA = findPosition_b(unknownNodePosition, beaconTabOfUnkownNode); 
                    ErrorRateForOneIterationBGA = [ErrorRateForOneIterationBGA;estimatedPositionBGA(:,3)];

                    outputStr = sprintf('Unknown node position: %s\nBeacon in range: %s', mat2str(unknownNodePosition), mat2str(beaconTabOfUnkownNode));
                    disp(outputStr);
                    disp(estimatedPositionEGA);
                    numBeaconNodes = numBeaconNodes + 1;
                    UnknownNodeIndex = UnknownNodeIndex + 1;
                else
                    ithRow = Conf(UnknownNodeIndex, :);
                    Conf(UnknownNodeIndex, :) = [];
                    Conf = [Conf; ithRow];
                end
            end
            % Error Rate for EGA
            AverageErrorRateForOneIterationEGA = sum(ErrorRateForOneIterationEGA) / length(ErrorRateForOneIterationEGA);
            FileOfAverageErrorRateForAllEGA = [FileOfAverageErrorRateForAllEGA;AverageErrorRateForOneIterationEGA];
             
            % Error Rate for BGA
            AverageErrorRateForOneIterationBGA = sum(ErrorRateForOneIterationBGA) / length(ErrorRateForOneIterationBGA);
            FileOfAverageErrorRateForAllBGA = [FileOfAverageErrorRateForAllBGA;AverageErrorRateForOneIterationBGA];
        end
        
        ErForPupulationCase(FileOfAverageErrorRateForAllBGA,FileOfAverageErrorRateForAllEGA,PopSize,currentSheet);
    end
    
end