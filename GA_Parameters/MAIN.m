% first we declare owr basic variables
global numNodes;
global IterationForNodes ;

IterationForGA = 30 ;
RSSI = 20 ; % the RSSI or the range of beacon nodes 


filename = 'FileOfConfigurationNodes.xlsx'; % specifies the name of the Excel file that will be used
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

    %ListPopulation = [10,20,40,80,160]; % Define a list of population values
    ListPopulation = [80];
    beaconNodesPossition = Conf(1:NumBeaconNodes,:);
    UnkownNodesReelPosition = Conf(NumBeaconNodes+1:end,:);

   % TabIteration =[10, 25, 50, 100, 200]; % Define a list of iteration nodes values
   TabIteration =[50];
    for numIteration = 1 : length(TabIteration)
        startIteration = sprintf('The beginning of %s iteration for Nodes ',mat2str(IterationForNodes));
        disp(startIteration);
        IterationForNodes = TabIteration(numIteration) ; 
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
            NodeNotLocalizableEGA = [];
            NodeNotLocalizableBGA = [];
            NodeEstimatedReelPosition =[];
            FirstTimeForNodeNotLocalizableEGA = [];
            FirstTimeForNodeNotLocalizableBGA = [];
            % variable for EGA
            numBeaconNodes = NumBeaconNodes;
            UnknownNodeIndex = 1;
            beaconNodesPossitionEGA = beaconNodesPossition;
            UnkownNodesReelPositionEGA = UnkownNodesReelPosition;
           
            CountForBreak = 3;
            % variable for BGA
            numBeaconNodesBGA = NumBeaconNodes;
            UnknownNodeIndexBGA = 1;
            beaconNodesPossitionBGA = beaconNodesPossition;
            UnkownNodesReelPositionBGA = UnkownNodesReelPosition;
 
            CountForBreakBGA = 2;

            % EGA
            while UnknownNodeIndex <= length(UnkownNodesReelPositionEGA) %NumUnkownNodes
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
                    estimatedPositionEGA = findPositionEGA(unknownNodePosition, beaconTabOfUnkownNode);
                    ErrorRateForOneIterationEGA = [ErrorRateForOneIterationEGA;estimatedPositionEGA(:,3)];
                    NodeEstimatedReelPosition = horzcat(estimatedPositionEGA,unknownNodePosition);
                    PositionOfAllForOneIteration = [PositionOfAllForOneIteration;NodeEstimatedReelPosition];
                    disp(PositionOfAllForOneIteration);
                    
                    outputStr = sprintf('Unknown node position: %s\nBeacon in range: %s', mat2str(unknownNodePosition), mat2str(beaconTabOfUnkownNode));
                    disp(outputStr);
                    disp(estimatedPositionEGA);

                    if estimatedPositionEGA(:,3) < 0.5
                        beaconNodesPossitionEGA(end+1,:) = UnkownNodesReelPositionEGA(UnknownNodeIndex,:);
                        numBeaconNodes = numBeaconNodes + 1;
                    end
                    % Check if coordinate exists in the Unknown nodes not localizable matrix
                    if ~isnan(NodeNotLocalizableEGA)
                    [row, ~] = find(ismember(NodeNotLocalizableEGA, unknownNodePosition, 'rows'));
                    if ~isempty(row)
                         % Coordinate exists, remove it
                         NodeNotLocalizableEGA(row, :) = [];
                         if size(FirstTimeForNodeNotLocalizableEGA,1) ~= 0
                             FirstTimeForNodeNotLocalizableEGA(1,:) = [];
                         end
    
                    end
                    end
                    UnknownNodeIndex = UnknownNodeIndex + 1;
               else
                   if size(FirstTimeForNodeNotLocalizableEGA,1) == 0
                       FirstTimeForNodeNotLocalizableEGA = UnkownNodesReelPositionEGA(UnknownNodeIndex, :);
                       disp(FirstTimeForNodeNotLocalizableEGA);
                   else
                       [rowForNode, ~] = find(ismember(FirstTimeForNodeNotLocalizableEGA, UnkownNodesReelPositionEGA(UnknownNodeIndex, :), 'rows')); 
                       disp(rowForNode);
                       if ~isempty(rowForNode)
                           CountForBreak = CountForBreak - 1;
                           disp(CountForBreak);
                           % Check if the loop should be terminated
                           if CountForBreak == 0
                               break; % Exit the loop
                           end
                       end
                   end
                    ithRow = UnkownNodesReelPositionEGA(UnknownNodeIndex, :);
                    disp(ithRow);
                    NodeNotLocalizableEGA = [NodeNotLocalizableEGA;ithRow];
                    NodeNotLocalizableEGA = unique(NodeNotLocalizableEGA, 'rows', 'stable');
                    UnkownNodesReelPositionEGA(UnknownNodeIndex, :) = [];
                    UnkownNodesReelPositionEGA = [UnkownNodesReelPositionEGA; ithRow];
                    disp('NAN');

                end
                
            end
            disp('node not Localizable :');
            disp(NodeNotLocalizableEGA);

            % BGA
           while UnknownNodeIndexBGA <= length(UnkownNodesReelPositionBGA) %(numNodes - NumBeaconNodes)
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
                    estimatedPositionBGA = findPositionBGA(unknownNodePositionBGA, beaconTabOfUnkownNodeBGA); 
                    ErrorRateForOneIterationBGA = [ErrorRateForOneIterationBGA;estimatedPositionBGA(:,3)];

                    outputStr = sprintf('Unknown node position BGA: %s\nBeacon in range: %s', mat2str(unknownNodePositionBGA), mat2str(beaconTabOfUnkownNodeBGA));
                    disp(outputStr);
                    %disp(estimatedPositionBGA);
                    if estimatedPositionBGA(:,3) < 0.5
                        beaconNodesPossitionBGA(end+1,:) = UnkownNodesReelPositionBGA(UnknownNodeIndexBGA,:);
                        numBeaconNodesBGA = numBeaconNodesBGA + 1;
                    end
                    % Check if coordinate exists in the Unknown nodes not localizable matrix
                    if ~isnan(NodeNotLocalizableBGA)
                    [rowBGA, ~] = find(ismember(NodeNotLocalizableBGA, unknownNodePositionBGA, 'rows'));
                    if ~isempty(rowBGA)
                         % Coordinate exists, remove it
                         NodeNotLocalizableBGA(rowBGA, :) = [];
                         if size(FirstTimeForNodeNotLocalizableBGA,1) ~= 0
                             FirstTimeForNodeNotLocalizableBGA(1,:) = [];
                         end
    
                    end
                    end
                    UnknownNodeIndexBGA = UnknownNodeIndexBGA + 1;
                else

                   if size(FirstTimeForNodeNotLocalizableBGA,1) == 0
                       FirstTimeForNodeNotLocalizableBGA = UnkownNodesReelPositionBGA(UnknownNodeIndexBGA, :);
                       disp(FirstTimeForNodeNotLocalizableBGA);
                   else
                       [rowForNodeBGA, ~] = find(ismember(FirstTimeForNodeNotLocalizableBGA, UnkownNodesReelPositionBGA(UnknownNodeIndexBGA, :), 'rows')); 
                       disp(rowForNodeBGA);
                       if ~isempty(rowForNodeBGA)
                           CountForBreakBGA = CountForBreakBGA - 1;
                           disp(CountForBreakBGA);
                           % Check if the loop should be terminated
                           if CountForBreakBGA == 0
                               break; % Exit the loop
                           end
                       end
                  end

                    ithRowBGA = UnkownNodesReelPositionBGA(UnknownNodeIndexBGA, :);
                    disp(ithRowBGA);
                    NodeNotLocalizableBGA = [NodeNotLocalizableBGA;ithRowBGA];
                    NodeNotLocalizableBGA = unique(NodeNotLocalizableBGA, 'rows', 'stable');
                    UnkownNodesReelPositionBGA(UnknownNodeIndexBGA, :) = [];
                    UnkownNodesReelPositionBGA = [UnkownNodesReelPositionBGA; ithRowBGA];
                    disp('NANBGA');
                end
                
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
                 disp(size(PositionOfAllForOneIteration,1));
                 disp(size(estimatedPositionAfterNGAiteration,1));
                for EstLength = 1 : size(PositionOfAllForOneIteration,1)
                    [r, ~] = find(ismember(estimatedPositionAfterNGAiteration(:,4:5), PositionOfAllForOneIteration(EstLength,4:5), 'rows'));
                    disp(estimatedPositionAfterNGAiteration);
                    disp(r);
                    if ~isempty(r)
                        for ts = 1:length(r)
                        if PositionOfAllForOneIteration(EstLength,3) < estimatedPositionAfterNGAiteration(r,3)
                            estimatedPositionAfterNGAiteration(r(ts),:) = PositionOfAllForOneIteration(EstLength,:);
                        end
                        end
                    else
                        estimatedPositionAfterNGAiteration(end+1,:) = PositionOfAllForOneIteration(EstLength,:);
                    end
                 end
                
            end
        end
        disp('after 30 iteration the estimated position :');
        disp(estimatedPositionAfterNGAiteration);
        fileForestimatedPositionAfterNGAiteration(estimatedPositionAfterNGAiteration,NodeNotLocalizableEGA,currentSheet);
       
        %ErForPupulationCase(FileOfAverageErrorRateForAllBGA,FileOfAverageErrorRateForAllEGA,PopSize,currentSheet);
        endPop = sprintf('The end of %s in GA ',mat2str(PopSize));
        disp(endPop);
    end
    %ErForIterationCase(FileOfAverageErrorRateForAllBGA,FileOfAverageErrorRateForAllEGA,IterationForNodes,currentSheet);
    endIteration = sprintf('The end of %s iteration for Nodes ',mat2str(IterationForNodes));
    disp(endIteration);
    end
    ErrorRateOfNodesCase(FileOfAverageErrorRateForAllBGA,FileOfAverageErrorRateForAllEGA,currentSheet)
    endSheet = sprintf('The end of %s in GA ',mat2str(currentSheet));
    disp(endSheet);
    %figure(1);
    %Graph(beaconNodesPossition,UnkownNodesReelPosition,estimatedPositionAfterNGAiteration,NodeNotLocalizableEGA);
end