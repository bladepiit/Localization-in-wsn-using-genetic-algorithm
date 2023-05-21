function [coordinates] = selection(fitness)
    % Selects two parents based on fitness
    % Input: fitness - fitness of each individual
    % Output: coordinates - coordinates of the two parents
   
    sort = sortrows(fitness, -3,'ascend');
    coordinates = sort(1:2,:);
    
    
end