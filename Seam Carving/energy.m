function [energy_image] = energy(image)
% Compute the energy of an image by applying filter 
% to its grayscale image

gray_image = rgb2gray(im2double(image));
[Gx, Gy] = imgradientxy(gray_image);
energy_image = abs(Gx) + abs(Gy);
end