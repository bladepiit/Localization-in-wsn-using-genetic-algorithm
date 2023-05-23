function errorGraph(error_1, error_2)

x = 1:length(error_1);
    
plot(x, error_1, 'b-', 'LineWidth', 2);
hold on;
plot(x, error_2, 'r-', 'LineWidth', 2);
    
xlabel('Index');
ylabel('Error');
title('Comparison of Error_1 and Error_2');
legend('Error_1', 'Error_2');
    
hold off;

end