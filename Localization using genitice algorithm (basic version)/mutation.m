function newPop = mutation(pop, mutationRate, xMin, xMax, yMin, yMax)
% Perform mutation on the population
% Iterate over each gene and mutate with probability mutationRate
% Mutation is performed by adding a random value to the gene
% The random value is sampled from a uniform distribution between -0.1 and 0.1

popSize = size(pop,1);
newPop = zeros(size(pop));

for i=1:popSize
    for j=1:size(pop,2)
        if rand() < mutationRate
            % mutate gene
            newGene = pop(i,j) + (rand()*0.2 - 0.1);
            
            % ensure that gene is within range
            if j == 1 % x coordinate
                newGene = max(newGene, xMin);
                newGene = min(newGene, xMax);
            else % y coordinate
                newGene = max(newGene, yMin);
                newGene = min(newGene, yMax);
            end
            
            % update population with mutated gene
            newPop(i,j) = newGene;
        else
            % copy gene to new population
            newPop(i,j) = pop(i,j);
        end
    end
end
end
 