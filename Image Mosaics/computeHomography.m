function [H] = computeHomography(points1,points2)
    % Compute homography matrix H such that points2 = H * points1
    % Ax = B 
    % A - [x y 1 0 0 0 -x'x -x'y; 0 0 0 x y 1 -y'x -y'y]
    %     for each pair of [x; y] in B
    % x - 8 values in H
    % B - [x; y] in points2

    [h, ~] = size(points1);
    x = ones(h, 1);
    B = reshape(points2.', [], 1);
    A = zeros(numel(B), 8);

    % [x y 1 0 0 0 -x'x -x'y] for odd rows of A
    one = ones(numel(B)/2, 1);
    zero = zeros(numel(B)/2, 1);
    A(1:2:end,:) = [points1(:, 1) points1(:, 2) one zero zero zero ...
                    -points2(:, 1).*points1(:, 1) -points2(:, 1).*points1(:, 2)];

    % [0 0 0 x y 1 -y'x -y'y] for even rows of A
    A(2:2:end,:) = [zero zero zero points1(:, 1) points1(:, 2) one ...
                    -points2(:, 2).*points1(:, 1) -points2(:, 2).*points1(:, 2)];

    % Solve for x
    x = A\B;
    x = [x; 1];
    H = reshape(x, 3, 3).';
end

