function [M, seam] = horizontalSeam(energy)
% Compute the optimal horizontal seam given 
% the energy map of of a image
% return a energy map and a list of indeces (i, j) for the horizontal seam

% Compute cumuative minimum energy for all entry (i, j)
% starting from the second column
M = energy;
s = size(M);

for j = 2 : s(2)
    for i = 1 : s(1)
        % check bounds, assuming there are more than 2 rows 
        if i == 1
            neighbors = [M(i, j-1) M(i+1, j-1)];
        elseif i == s(1)
            neighbors = [M(i-1, j-1) M(i, j-1)];
        else
            neighbors = [M(i-1, j-1) M(i, j-1) M(i+1, j-1)];
        end
        M(i, j) = M(i, j) + min(neighbors);
    end
end


% Find  min value in last column of M
[val, row] = min(M(:, s(2)));
tmp_energy = val;

% Use dynamic programming to find the seam
seam = zeros(s(2), 2);
i = row;
j = s(2);
seam(j, 1) = row;
seam(j, 2) = j;
% Start from the last column and retrieve back
for j = s(2) : -1 : 2
    val = M(i, j);
    tmp_energy = val - energy(i, j);
    if i == 1
        neighbors = [M(i, j-1) M(i+1, j-1)];
        row = row + find(abs(neighbors - tmp_energy) < 0.0001, 1) - 1;
	elseif i == s(1)
        neighbors = [M(i-1, j-1) M(i, j-1)];
        row = row + find(abs(neighbors - tmp_energy) < 0.0001, 1) - 2;
    else
        neighbors = [M(i-1, j-1) M(i, j-1) M(i+1, j-1)];
        row = row + find(abs(neighbors - tmp_energy) < 0.0001, 1) - 2;
    end
    seam(j - 1, 1) = row;
    seam(j - 1, 2) = j - 1;
    i = row;
end
end