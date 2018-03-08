function [M, seam] = verticalSeam(energy)
% Compute the optimal vertical seam given 
% the energy map of of a image
% return a energy map and a list of indeces (i, j) for the verticle seam

% Compute cumuative minimum energy for all entry (i, j)
% starting from the second row
M = energy;
s = size(M);
for i = 2 : s(1)
    for j = 1 : s(2)
        % check bounds, assuming there are more than 2 columns 
        if j == 1
            neighbors = [M(i-1, j) M(i-1, j+1)];
        elseif j == s(2)
            neighbors = [M(i-1, j-1) M(i-1, j)];
        else
            neighbors = [M(i-1, j-1) M(i-1, j) M(i-1, j+1)];
        end
        M(i, j) = M(i, j) + min(neighbors);
    end
end

% Find  min value in last row of M
[val, col] = min(M(s(1), :));
tmp_energy = val;

% Use dynamic programming to find the seam
seam = zeros(s(1), 2);
j = col;
i = s(1);
seam(i, 1) = i;
seam(i, 2) = col;
% Start from the last row and retrieve back
for i = s(1) : -1 : 2
    val = M(i, j);
    tmp_energy = val - energy(i, j);
    if j == 1
        neighbors = [M(i-1, j) M(i-1, j+1)];
        col = col + find(abs(neighbors - tmp_energy) < 0.0001, 1) - 1;
 	elseif j == s(2)
        neighbors = [M(i-1, j-1) M(i-1, j)];
        col = col + find(abs(neighbors - tmp_energy) < 0.0001, 1) - 2;
    else
        neighbors = [M(i-1, j-1) M(i-1, j) M(i-1, j+1)];
        col = col + find(abs(neighbors - tmp_energy) < 0.0001, 1) - 2;
    end
    seam(i - 1, 1) = i - 1;
    seam(i - 1, 2) = col;
    j = col;
end
end