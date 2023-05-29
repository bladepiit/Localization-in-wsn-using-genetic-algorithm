function [popCordoone,error] = calculateFitnessForOneBGA(pop, beacon, reelPosition)
    % calculate the fitness for one individuel
    popCordoone = pop;
    NodeError = zeros(1,2);
    SomeOfErrorsIndividuel = 0;
    for i = 1: size(beacon,1)
        errorForIndividuel = Calculate_Error_BGA(pop, beacon(i,:), reelPosition);
        %disp(errorForIndividuel);
        SomeOfErrorsIndividuel = SomeOfErrorsIndividuel + errorForIndividuel; % calculate the sum of all Errors of each Individuel
        
    end
   % disp(SomeOfErrorsIndividuel);
    error = calcMSE_BGA(SomeOfErrorsIndividuel,beacon);

end