function [pop] = evaluate(pop)
pop = unique(pop,'rows','stable');
pop = sortrows(pop, -3,'ascend');
end