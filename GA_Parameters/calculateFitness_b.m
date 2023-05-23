function [fitness] = calculateFitness_b(pop, beaconInRange, reelPosition)

beacon = beaconInRange ;
fitness = NaN(size(pop,1),3);

for i = 1:size(pop,1)
    [cordoone,Error] = calculateFitnessForOne_b(pop(i,:), beacon ,reelPosition);
    fitness(i,:) = [cordoone,Error];
end



end