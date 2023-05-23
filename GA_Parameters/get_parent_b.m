function [parent_position] = get_parent_b(numBeaconNodes, fitness)
    errors_array = fitness(:,3);
    sum_errors_array = sum(errors_array);
    errors_array_inverted = errors_array.^(-1);
    roulette_wheel_array = errors_array_inverted.*sum_errors_array;
    parent_index = roulette_wheel_b(roulette_wheel_array);
    parent_position = parent_index ;
end