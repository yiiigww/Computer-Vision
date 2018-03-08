function [output] = greedyWidth(im, numPixels)
% Reduce numPixels of pixels from width of the image im
% using greedy algorithm - remove the pixel with 
% least energy in each row
output = im;
s = size(im);
for n = 1 : numPixels
	energy_map = energy(output);
    for i = 1 : s(1)
        [~, col] = min(energy_map(i, :));
        output(i,1:end-1,:) = [output(i,1:col-1,:) output(i,col+1:end,:)];
    end
    output = output(:, 1:end-1, :);
end
end


