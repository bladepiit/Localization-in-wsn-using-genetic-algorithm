function [pop] = crossover_b(parent1_position, parent2_position)
    for i = 1:1
       parent1 = parent1_position;
      
        parent2 = parent2_position;
     
        mask = randi([0 1],1,size(parent1,2));
        child1 = parent1.*mask + parent2.*(1-mask);
        child2 = parent2.*mask + parent1.*(1-mask);
        
        pop(1,:) = child1;
        pop(2,:) = child2;

       
    end
end