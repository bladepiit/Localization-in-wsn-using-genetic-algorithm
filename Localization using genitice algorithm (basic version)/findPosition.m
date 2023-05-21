function [estimatedPosition] = findPosition(unknownNodePosition, beaconInRange)
    reelPosition = unknownNodePosition;
    numBeaconNodes = length(beaconInRange);
   
    popSize = 40 ; % size of population will create
    maxIteration = 40 ; % maximum number of iteration
    xMin = 0 ; % minimum value of x
    xMax = 50 ; % maximum value of x
    yMin = 0 ; % minimum value of y
    yMax = 50 ; % maximum value of y
    mutationRate = 0.01 ; % mutation rate

    

    pop = generatePopulation(popSize, xMin, xMax, yMin, yMax) ; % generate population
    %disp(pop);
    fitness = calculateFitness(pop, beaconInRange, reelPosition) ; % calculate fitness of population
    
    newPopulation = fitness;
    for i = 1 : maxIteration
        
        for j = 1 : 20
            parent1_position = get_parent(numBeaconNodes, fitness); 
            parent2_position = get_parent(numBeaconNodes, fitness);
           
            parent1 = fitness(parent1_position,:);
            parent2 = fitness(parent2_position,:);
            sons = crossover(parent1, parent2) ; % crossover population
            sons = mutation(sons, mutationRate, xMin, xMax, yMin, yMax) ; % mutate population
            
            
           % add the sons to the new population
            newPopulation = [newPopulation; sons];
           % disp(length(fitness));
        end
        
        
        newPopulation = evaluate(newPopulation);
       

        
        
    end
    estimatedPosition = newPopulation(1, :) ; % return the best individual
    
    
end