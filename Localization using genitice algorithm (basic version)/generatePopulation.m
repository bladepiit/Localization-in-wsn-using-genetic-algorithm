function [pop] = generatePopulation(popSize, xMin, xMax, yMin, yMax)
    pop = zeros(popSize, 2);
    for i = 1:popSize
        pop(i, 1) = xMin + (xMax - xMin) * rand();
        pop(i, 2) = yMin + (yMax - yMin) * rand();
    end
end