function [estimatedPosition] = findPosition_b(unknownNodePosition, beaconInRange)
    reelPosition = unknownNodePosition;
    numBeaconNodes = length(beaconInRange);
   
    global PopSize 
    popSize = PopSize ; % size of population will create
    maxIteration = 40 ; % maximum number of iteration
    xMin = 0 ; % minimum value of x
    xMax = 50 ; % maximum value of x
    yMin = 0 ; % minimum value of y
    yMax = 50 ; % maximum value of y
    mutationRate = 0.01 ; % mutation rate

    

    pop = generatePopulation_b(popSize, xMin, xMax, yMin, yMax) ; % generate population
    %disp(pop);
    fitness = calculateFitness_b(pop, beaconInRange, reelPosition) ; % calculate fitness of population
    
    newPopulation = fitness;
    for i = 1 : maxIteration
        
        for j = 1 : 20
            parent1_position = get_parent_b(numBeaconNodes, fitness); 
            parent2_position = get_parent_b(numBeaconNodes, fitness);
           
            parent1 = fitness(parent1_position,:);
            parent2 = fitness(parent2_position,:);
            sons = crossover_b(parent1, parent2) ; % crossover population
            sons = mutation_b(sons, mutationRate, xMin, xMax, yMin, yMax) ; % mutate population
            
            
           % add the sons to the new population
            newPopulation = [newPopulation; sons];
           % disp(length(fitness));
        end
        
        
        newPopulation = evaluate_b(newPopulation);
       

        
        
    end
    estimatedPosition = newPopulation(1, :) ; % return the best individual
    
    
end