function [output] = reduceWidth(im, numPixels)
% Reduce numPixels of pixels from width of the image im
% by removing the optimal seam 
output = im;
s = size(im);

% remove seam numPixels times
for n = 1 : numPixels
	energy_map = energy(output);
	[~, seam] = verticalSeam(energy_map);
    % remove appropriate pixel from each row
	for i = 1 : s(1)
        output(i,1:end-1,:) = [output(i,1:seam(i, 2)-1,:) ...
            output(i,seam(i, 2)+1:end,:)];  
    end
    output = output(:, 1:end-1, :);
end
end

