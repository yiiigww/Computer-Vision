austin = imread('austin.jpg');

% Compute the energy function at each pixel using the 
magnitude of the x and y gradients 
austin_energy = energy(austin);

% Compute the optimal vertical seam given an image
[M_v, seam_v] = verticalSeam(austin_energy);

% Compute the optimal horizontal seam given an image
[M_h, seam_h] = horizontalSeam(austin_energy);

% Display the selected seam on top of an image
displaySeam(seam_v, austin);
displaySeam(seam_h, austin);

% Reduce the image size by a specified amount in one dimension 
% (width or height decrease)
austin_wreduced = reduceWidth(austin, 100);
austin_hreduced = reduceHeight(austin, 100);

% Extra Credit 3.3 Enlargement
test1 = imread('travel.jpg');
test1_1 = increaseHeight(test1, 100);

% Extra Credit 3.4 Greedy
austin_wgreedy = greedyWidth(austin, 100);
austin_hgreedy = greedyHeight(austin, 100);

% 2.1
% austin = imread('austin.jpg');
% austin_reduced = reduceWidth(austin, 100);
%
% disney = imread('disney.jpg');
% disney_reduced = reduceHeight(disney, 100);
% subplot(2, 1, 1);
% imshow(austin_reduced);
% title('Reduced austin.jpg');
% 
% subplot(2, 1, 2);
% imshow(disney_reduced);
% title('Reduced disney.jpg');

% 2.2
% austin_energy = energy(austin);
% subplot(3, 1, 1);
% imshow(austin_energy);
% title('Gradient of austin.jpg');
% 
%  [M_h, seam_h] = horizontalSeam(austin_energy);
% subplot(3, 1, 2);
% imagesc(M_h);
% title('Cumulative Minimum Energy Maps - Horizontal');
% 
%  [M_v, seam_v] = verticalSeam(austin_energy);
% subplot(3, 1, 3);
% imagesc(M_v);
% title('Cumulative Minimum Energy Maps - Vertical');

% 2.3
% subplot(3, 1, 1);
% imshow(austin);
% title('Original austin.jpg');
% 
% subplot(3, 1, 2);
% with_seam_h = displaySeam(seam_h, austin);
% title('austin.jpg with First Horizontal Seam');
% 
% subplot(3, 1, 3);
% with_seam_v = displaySeam(seam_v, austin);
% title('austin.jpg with First Vertical Seam');

% 2.4
% austin_wreduced = reduceWidth(austin, 100);
% subplot(2, 1, 1);
% imshow(austin_wreduced);
% title('Gradient of austin.jpg');
% 
% austin_wreduced_m = reduceWidth_modified(austin, 100);
% subplot(2, 1, 2);
% imshow(austin_wreduced_m);
% title('Intermediate Difference Gradient of austin.jpg');

