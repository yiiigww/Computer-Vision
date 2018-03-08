function [output] = reduceWidth_modified(im, numPixels)
% Reduce numPixels of pixels from width of the image im
% use a different energy filter

output = im;
s = size(im);
for n = 1 : numPixels
	energy_map = energy_modified(output);
	[~, seam] = verticalSeam(energy_map);
	for i = 1 : s(1)
        output(i,1:end-1,:) = [output(i,1:seam(i, 2)-1,:) ...
            output(i,seam(i, 2)+1:end,:)];  
    end
    output = output(:, 1:end-1, :);
end
end

