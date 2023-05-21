% ---------------------------------------------------------
% Roulette Wheel Selection Algorithm. A set of weights
% represents the probability of selection of each
% individual in a group of choices. It returns the index
% of the chosen individual.
% Usage example:
% fortune_wheel ([1 5 3 15 8 1])
%    most probable result is 4 (weights 15)
% ---------------------------------------------------------
function parent_index = roulette_wheel(probabilities)
  accumulation = cumsum(probabilities);
  p = rand() * accumulation(end);
  chosen_index = -1;
  for index = 1 : length(accumulation)
    if (accumulation(index) > p)
      chosen_index = index;
      break;
    end
  end
  parent_index = chosen_index;
end