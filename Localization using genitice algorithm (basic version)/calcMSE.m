function [mean_squared_error] = calcMSE(errors,Numbeacon)
% Calcule la moyenne des carrés des erreurs (MSE)
% errors : vecteur contenant les erreurs individuelles
% mean_squared_error : la MSE

m = length(Numbeacon); % Nombre total d'erreurs
mean_squared_error = errors / m; % Moyenne des carrés des erreurs
end