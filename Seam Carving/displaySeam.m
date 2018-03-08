function [output] = displaySeam(seam, image)
% Display selected seam on top of an image

imshow(image);
hold on;
% rows are the x xis and columns are the y axis
output = plot(seam(:,2), seam(:,1), 'r');
end