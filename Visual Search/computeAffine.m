function [M, T] = computeAffine(points1,points2)
    % Compute affine transformation points2 = M * points1 + T
    % Ax = B 
    % A - [x y 0 0 1 0; 0 0 x y 0 1]
    %     for each pair of [x; y] in B
    % x - 6 values in H
    % B - [x; y] in points2

    B = reshape(points2.', [], 1);
    A = zeros(size(B, 1), 6);
    % [x y 0 0 1 0] for odd rows of A
    one = ones(size(B, 1)/2, 1);
    zero = zeros(size(B, 1)/2, 1);
    A(1:2:end,:) = [points1(:, 1) points1(:, 2) zero zero one zero];

    % [0 0 x y 0 1] for even rows of A
    A(2:2:end,:) = [zero zero points1(:, 1) points1(:, 2) zero one];

    % Solve for x
    x = A\B;
    M = reshape(x(1:4, :), 2, 2)';
    T = x(5:6, :);
end

