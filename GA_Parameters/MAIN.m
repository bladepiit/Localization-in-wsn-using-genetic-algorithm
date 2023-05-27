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
    startSheet = sprintf('The beginning of %s in GA ',mat2str(currentSheet));
    disp(startSheet);
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
        startPop = sprintf('The beginning of %s in GA ',mat2str(PopSize));
        disp(startPop);

        FileOfAverageErrorRateForAllEGA = [];
        FileOfAverageErrorRateForAllBGA = [];
        estimatedPositionAfterNGAiteration = [];
        for IterationGA = 1 : IterationForGA
            outputIteration = sprintf('%s Iteration GA Round',mat2str(IterationGA));
            disp(outputIteration);

            % claculate the distance between beacon nodes and unkown nodes
            ErrorRateForOneIterationEGA = [];
            ErrorRateForOneIterationBGA = [];
            PositionOfAllForOneIteration = [];
            % variable for EGA
            numBeaconNodes = NumBeaconNodes;
            UnknownNodeIndex = 1;
            beaconNodesPossitionEGA = beaconNodesPossition;
            UnkownNodesReelPositionEGA = UnkownNodesReelPosition;

            % variable for BGA
            numBeaconNodesBGA = NumBeaconNodes;
            UnknownNodeIndexBGA = 1;
            beaconNodesPossitionBGA = beaconNodesPossition;
            UnkownNodesReelPositionBGA = UnkownNodesReelPosition;

            % EGA
            while UnknownNodeIndex <= NumUnkownNodes
                beaconTabOfUnkownNode = [];
                unknownNodePosition = [];
                % this is about how to calculate the distance between Unknown nodes and beacon node (EGA) 
                for BeaconNodeIndex = 1 : numBeaconNodes
                    distanceBeaconUnknown = Distance_Calculation(UnkownNodesReelPositionEGA(UnknownNodeIndex,:),beaconNodesPossitionEGA(BeaconNodeIndex,:));
                    % when the unknown node is within range of the beacon node
                    if distanceBeaconUnknown < RSSI
                        beaconTabOfUnkownNode(end+1,:) = [beaconNodesPossitionEGA(BeaconNodeIndex,1),beaconNodesPossitionEGA(BeaconNodeIndex,2)];
                    end
                end
                
                if size(beaconTabOfUnkownNode,1) >= 3
                    unknownNodePosition = UnkownNodesReelPositionEGA(UnknownNodeIndex,:);
                    % Estimate Position for EGA
                    estimatedPositionEGA = findPosition(unknownNodePosition, beaconTabOfUnkownNode);
                    ErrorRateForOneIterationEGA = [ErrorRateForOneIterationEGA;estimatedPositionEGA(:,3)];
                    PositionOfAllForOneIteration = [PositionOfAllForOneIteration;estimatedPositionEGA];
                    outputStr = sprintf('Unknown node position: %s\nBeacon in range: %s', mat2str(unknownNodePosition), mat2str(beaconTabOfUnkownNode));
                    disp(outputStr);
                    disp(estimatedPositionEGA);

                    if estimatedPositionBGA(:,3) < 0.5
                        beaconNodesPossitionEGA(end+1,:) = UnkownNodesReelPositionEGA(UnknownNodeIndex,:);
                        numBeaconNodes = numBeaconNodes + 1;
                    end
                    
                else
                    ithRow = UnkownNodesReelPositionEGA(UnknownNodeIndex, :);
                    UnkownNodesReelPositionEGA(UnknownNodeIndex, :) = [];
                    UnkownNodesReelPositionEGA = [UnkownNodesReelPositionEGA; ithRow];
                end
                UnknownNodeIndex = UnknownNodeIndex + 1;
            end


            % BGA
           while UnknownNodeIndexBGA <= (numNodes - NumBeaconNodes)
                beaconTabOfUnkownNodeBGA = [];
                unknownNodePositionBGA = [];
             
                % this is about how to calculate the distance between Unknown nodes and beacon node (BGA) 
                for BeaconNodeIndexBGA = 1 : numBeaconNodesBGA
                    distanceBeaconUnknownBGA = Distance_Calculation(UnkownNodesReelPositionBGA(UnknownNodeIndexBGA,:),beaconNodesPossitionBGA(BeaconNodeIndexBGA,:));
                    % when the unknown node is within range of the beacon node
                    if distanceBeaconUnknownBGA < RSSI
                        beaconTabOfUnkownNodeBGA(end+1,:) = [beaconNodesPossitionBGA(BeaconNodeIndexBGA,1),beaconNodesPossitionBGA(BeaconNodeIndexBGA,2)];
                    end
                end
                if size(beaconTabOfUnkownNodeBGA,1) >= 3
                    unknownNodePositionBGA = UnkownNodesReelPositionBGA(UnknownNodeIndexBGA,:);
                   
                    % Estimate Position for BGA
                    estimatedPositionBGA = findPosition_b(unknownNodePositionBGA, beaconTabOfUnkownNodeBGA); 
                    ErrorRateForOneIterationBGA = [ErrorRateForOneIterationBGA;estimatedPositionBGA(:,3)];

                    outputStr = sprintf('Unknown node position: %s\nBeacon in range: %s', mat2str(unknownNodePositionBGA), mat2str(beaconTabOfUnkownNodeBGA));
                    %disp(outputStr);
                    %disp(estimatedPositionBGA);
                    if estimatedPositionBGA(:,3) < 0.5
                        beaconNodesPossitionBGA(end+1,:) = UnkownNodesReelPositionBGA(UnknownNodeIndexBGA,:);
                        numBeaconNodesBGA = numBeaconNodesBGA + 1;
                    end
                    
                else
                    ithRowBGA = UnkownNodesReelPositionBGA(UnknownNodeIndexBGA, :);
                    UnkownNodesReelPositionBGA(UnknownNodeIndexBGA, :) = [];
                    UnkownNodesReelPositionBGA = [UnkownNodesReelPositionBGA; ithRowBGA];
                end
                UnknownNodeIndexBGA = UnknownNodeIndexBGA + 1;
            end

            % Error Rate for EGA
            AverageErrorRateForOneIterationEGA = sum(ErrorRateForOneIterationEGA) / length(ErrorRateForOneIterationEGA);
            FileOfAverageErrorRateForAllEGA = [FileOfAverageErrorRateForAllEGA;AverageErrorRateForOneIterationEGA];
             
            % Error Rate for BGA
            AverageErrorRateForOneIterationBGA = sum(ErrorRateForOneIterationBGA) / length(ErrorRateForOneIterationBGA);
            FileOfAverageErrorRateForAllBGA = [FileOfAverageErrorRateForAllBGA;AverageErrorRateForOneIterationBGA];

            % estimated position after 30 GA iteration 
            if size(estimatedPositionAfterNGAiteration,1) == 0
                estimatedPositionAfterNGAiteration = PositionOfAllForOneIteration;
            else
                for EstLength = 1 : size(estimatedPositionAfterNGAiteration,1)
                    if PositionOfAllForOneIteration(EstLength,3) < estimatedPositionAfterNGAiteration(EstLength,3)
                        estimatedPositionAfterNGAiteration(EstLength,:) = PositionOfAllForOneIteration(EstLength,:);
                    end
                end
            end
        end
        disp('after 30 iteration the estimated position :');
        disp(estimatedPositionAfterNGAiteration);
        
        %ErForPupulationCase(FileOfAverageErrorRateForAllBGA,FileOfAverageErrorRateForAllEGA,PopSize,currentSheet);
        
        endPop = sprintf('The end of %s in GA ',mat2str(PopSize));
        disp(endPop);
    end
    endSheet = sprintf('The end of %s in GA ',mat2str(currentSheet));
    disp(endSheet);
end