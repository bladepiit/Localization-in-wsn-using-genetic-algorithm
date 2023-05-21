function [popCordoone,error] = calculateFitnessForOne(pop, beacon, reelPosition)
    % calculate the fitness for one individuel
    popCordoone = pop;
    NodeError = zeros(1,2);
    SomeOfErrorsIndividuel = 0;
    for i = 1: size(beacon,1)
        errorForIndividuel = Calculate_Error(pop, beacon(i,:), reelPosition);
        %disp(errorForIndividuel);
        SomeOfErrorsIndividuel = SomeOfErrorsIndividuel + errorForIndividuel; % calculate the sum of all Errors of each Individuel
        
    end
   % disp(SomeOfErrorsIndividuel);
    error = calcMSE(SomeOfErrorsIndividuel,beacon);

end