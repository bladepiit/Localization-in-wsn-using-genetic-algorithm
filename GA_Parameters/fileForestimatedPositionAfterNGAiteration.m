function fileForestimatedPositionAfterNGAiteration(estimatedPositionAfterNGAiteration,NodeNotLocalizableEGA,currentSheet)
tabOfNodeNotLocalizable = [];
for index = 1 : length(NodeNotLocalizableEGA)
    tabOfNodeNotLocalizable = [tabOfNodeNotLocalizable;0, 0, 0, NodeNotLocalizableEGA];
end
tabOfEstimatedPosition = [estimatedPositionAfterNGAiteration;tabOfNodeNotLocalizable];
tabForStocker = table(tabOfEstimatedPosition,'VariableNames',{' '});% Create a table for the row names
% Écrire les tables dans le fichier Excel
fileName ='EstimatedPositionFile.xlsx';
writetable(tabForStocker, fileName, 'Sheet', currentSheet);
end