function makeGraph(beacon, estimatePosition, reelPosition)
    % Plotting the beacon positions
    scatter(beacon(:, 1), beacon(:, 2), 'ro', 'filled');
    hold on;

    % Plotting the estimated positions
    scatter(estimatePosition(:, 1), estimatePosition(:, 2), 'b*');

    % Plotting the real positions
    scatter(reelPosition(:, 1), reelPosition(:, 2), 'g+');

    % Adding labels to the plot
    xlabel('X');
    ylabel('Y');
    title('Beacon, Estimated, and Real Positions');
    legend('Beacon', 'Estimated Position', 'Real Position');

    hold off;
end