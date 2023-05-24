function HistoGraph(Tab,Sheets)

BGA = [];
EGA = [];
for i = 1 :length(Tab)
BGA = [BGA;Tab(1,i)];
EGA = [EGA;Tab(2,i)];
end
% Generate x-axis labels for each index
xLabels = cellstr(num2str((1:numel(BGA))'));

% Create a matrix of values for the bar plot
data = [BGA' ;EGA'];
disp(data);
% Create a bar plot with grouped bars
figure(Sheets);
hold on;
bar(1:numel(BGA), data, 'grouped');
hold off;

% Customize the plot
title('Comparison of BGA and EGA');
xlabel('Index');
ylabel('Values');
legend('BGA', 'EGA');
set(gca, 'XTick', 1:numel(BGA));
set(gca, 'XTickLabel', xLabels);

end