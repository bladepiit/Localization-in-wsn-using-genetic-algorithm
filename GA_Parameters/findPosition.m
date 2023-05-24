function [estimatedPosition] = findPosition(unknownNodePosition, beaconInRange)
    reelPosition = unknownNodePosition;
    numBeaconNodes = length(beaconInRange);
    global NumUnkownNodes ;
    UnkownNodesLenght = NumUnkownNodes;
    global PopSize 
    popSize = PopSize ; % size of population will create
    global maxIteration;
    NumIteration = maxIteration; % maximum number of iteration
    
    xMin = 0 ; % minimum value of x
    xMax = 50 ; % maximum value of x
    yMin = 0 ; % minimum value of y
    yMax = 50 ; % maximum value of y
    mutationRate = 0.01 ; % mutation rate

    

    pop = generatePopulation(popSize, xMin, xMax, yMin, yMax) ; % generate population
    %disp(pop);
    fitness = calculateFitness(pop, beaconInRange, reelPosition) ; % calculate fitness of population
    
    newPopulation = fitness;
    for i = 1 : NumIteration
        
        for j = 1 : (UnkownNodesLenght / 2)
            parent1_position = get_parent(numBeaconNodes, fitness); 
            parent2_position = get_parent(numBeaconNodes, fitness);
            if parent1_position == parent2_position
                parent2_position = get_parent(numBeaconNodes, fitness);
            end
            parent1 = fitness(parent1_position,:);
            parent2 = fitness(parent2_position,:);
            sons = crossover(parent1, parent2) ; % crossover population
            sons = mutation(sons, mutationRate, xMin, xMax, yMin, yMax) ; % mutate population
            fitness_sons = calculateFitness(sons, beaconInRange, reelPosition) ; % calculate fitness of population
            sons = selection(fitness_sons) ; % select population
            
           % add the sons to the new population
            newPopulation = [newPopulation; sons];
           % disp(length(fitness));
        end
        
        
        newPopulation = evaluate(newPopulation);
       

        
        
    end
    estimatedPosition = newPopulation(1, :) ; % return the best individual
    
    
end