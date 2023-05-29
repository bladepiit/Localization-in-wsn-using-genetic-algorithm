function [error] = Calculate_Error_BGA(point1, point2, point3)
    error_reel = (sqrt((point3(1)-point2(1))^2 + (point3(2)-point2(2))^2)) + (sqrt((point3(1)-point2(1))^2 + (point3(2)-point2(2))^2)) * 5 / 100;
    error_individue = sqrt((point1(1)-point2(1))^2 + (point1(2)-point2(2))^2) ;
    error = (error_individue - error_reel)^2;
end