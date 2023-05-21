function [coordinates] = makeGraph(beaconNodes, reelPos,coordinates)
    % Reel postion of the unkown noeud
    pos1 = reelPos(1);
    pos2 = reelPos(2);
    numBeaconNodes = length(beaconNodes);
    % Create the graph
    scatter(coordinates,100, 'r','square');
    hold on;
   % scatter(coordinates(numBeaconNodes+1:end, 1), coordinates(numBeaconNodes+1:end, 2), 'b');
   % hold on;
    scatter(pos1, pos2,50, 'g','x'); % Set the real position just for testing porposes
    title('Coordonnees des noeuds'); % set the title for the graph
    xlabel('Ligne');
    ylabel('Colonne');
    legend('Noeuds balises', 'Noeuds inconnus','Position reel');
end