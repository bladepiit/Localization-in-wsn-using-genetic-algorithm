function [pop] = evaluate_b(pop)
pop = unique(pop,'rows','stable');
pop = sortrows(pop, -3,'ascend');
end