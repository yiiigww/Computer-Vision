function [energy_image] = energy_modified(image)
% Compute the energy of an image by applying filter 
% to its grayscale image

gray_image = rgb2gray(im2double(image));
[Gx, Gy] = imgradientxy(gray_image, 'intermediate');
energy_image = sqrt(Gx.^2 + Gy.^2);
end