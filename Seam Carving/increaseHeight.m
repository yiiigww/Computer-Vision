function [output] = increaseHeight(im, numPixels)
% Increase numPixels of pixels from height of the image im
% by averaging the seam with its neighbors

output = im;
s = size(im);
for n = 1 : numPixels
	energy_map = energy(output);
	[~, seam] = horizontalSeam(energy_map);
    tmp = output;
	for j = 1 : s(2)
        % combine valid neighbors
        sum = double(output(seam(j, 1),j,:));
        count = 1;
        s_o = size(output);
        if (seam(j, 1) > 1)
            sum = sum + double(output(seam(j, 1)-1,j,:));
            count = count + 1;
        elseif (seam(j, 1) < s_o(2))
            sum = sum + double(output(seam(j, 1)+1,j,:));
            count = count + 1;
        end
        avg = uint8(sum/count);
        % add one extra pixel
        output(1:end,j,:) = [output(1:seam(j, 1),j,:); avg; ...
            output(seam(j, 1)+1:end-1,j,:)];  
    end
    output = [output; tmp(end, :, :)];
end
end
