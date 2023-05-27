function Graph(beaconNode,reelPosition, estimatePosition,  positionForNodeNotLocalizable)
% Plotting the data
hold on;
plot(beaconNode(:, 1), beaconNode(:, 2), 'ro', 'MarkerSize', 10);
plot(estimatePosition(:, 1), estimatePosition(:, 2), 'bs', 'MarkerSize', 10);
plot(reelPosition(:, 1), reelPosition(:, 2), 'gx', 'MarkerSize', 10);
plot(positionForNodeNotLocalizable(:, 1), positionForNodeNotLocalizable(:, 2), 'kv', 'MarkerSize', 10);

% Adding labels and legend
xlabel('X');
ylabel('Y');
legend('Beacon Node', 'Estimated Position', 'Real Position', 'Position for Non-Localizable Nodes');

% Adjusting the plot limits
xlim([min([beaconNode(:, 1); estimatePosition(:, 1); reelPosition(:, 1); positionForNodeNotLocalizable(:, 1)]) - 1, max([beaconNode(:, 1); estimatePosition(:, 1); reelPosition(:, 1); positionForNodeNotLocalizable(:, 1)]) + 1]);
ylim([min([beaconNode(:, 2); estimatePosition(:, 2); reelPosition(:, 2); positionForNodeNotLocalizable(:, 2)]) - 1, max([beaconNode(:, 2); estimatePosition(:, 2); reelPosition(:, 2); positionForNodeNotLocalizable(:, 2)]) + 1]);

% Display the plot
hold off;
end