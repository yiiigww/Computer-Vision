function [output] = reduceHeight(im, numPixels)
% Reduce numPixels of pixels from height of the image im
% by removing the optimal seam 
output = im;
s = size(im);

% remove seam numPixels times
for n = 1 : numPixels
	energy_map = energy(output);
	[~, seam] = horizontalSeam(energy_map);
    % remove appropriate pixel from each column
	for j = 1 : s(2)
        output(1:end-1,j,:) = [output(1:seam(j, 1)-1,j,:);...
            output(seam(j, 1)+1:end,j,:)];  
    end
    output = output(1:end-1,:,:);
end
end

