function [output] = greedyHeight(im, numPixels)
% Reduce numPixels of pixels from height of the image im
% using greedy algorithm - remove the pixel with 
% least energy in each column
output = im;
s = size(im);
for n = 1 : numPixels
	energy_map = energy(output);
	for j = 1 : s(2)
        [~, row] = min(energy_map(:, j));
        output(1:end-1,j,:) = [output(1:row-1,j,:); output(row+1:end,j,:)];  
    end
    output = output(1:end-1,:,:);
end
end

