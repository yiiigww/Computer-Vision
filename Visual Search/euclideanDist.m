function [euDist] = euclideanDist(points1,points2)
% Compute the euclidean distance between points at the same column
% Each column of the input is the x, y cordinates
euDist = sqrt((points1(1, :) - points2(1, :)) .^2 + ...
    (points1(2, :) - points2(2, :)) .^2);
end

