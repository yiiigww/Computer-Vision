function [newImg] = merge(img, warpImg, warpCorner)
    % img - the second image that will be copied directly into
    % the new image
    % warpImg - the warped first image to fit to second image
    % warpCorner - the relative position of the four corners 
    % of the warped image to the second image. Used to align.

    % Find the bounding values of the merged image.
    [h, w, ~] = size(img);
    maxHeight = ceil(max(max(warpCorner(:, 2)), h));
    maxWidth = ceil(max(max(warpCorner(:, 1)), w));
    minHeight = floor(min(min(warpCorner(:, 2)), 1));
    minWidth = floor(min(min(warpCorner(:, 1)), 1));
 
    % Compute the size based on the bounds.
    newHeight = maxHeight - minHeight + 1;
    newWidth = maxWidth - minWidth + 1;
    newImg = zeros(newHeight, newWidth, 3);

    % Copy the first image directly by channel
    newTemp = newImg(:,:,1);
        
    % Only copy pixels with value greater than 0
    [row, col] = find(img(:, :, 1) > 0);
    newR = row - minHeight + 1;
    newC = col - minWidth + 1;
    idx = sub2ind([newHeight, newWidth], newR, newC); 
    oldTemp = img(:, :, 1);
    newTemp(idx) = oldTemp(sub2ind(size(oldTemp), row, col));
    newImg(:,:,1) = newTemp;
    
    [row, col] = find(img(:, :, 2) > 0);
    newR = row - minHeight + 1;
    newC = col - minWidth + 1;
    idx = sub2ind([newHeight, newWidth], newR, newC); 
    oldTemp = img(:, :, 2);
    newTemp(idx) = oldTemp(sub2ind(size(oldTemp), row, col));
    newImg(:,:,2) = newTemp;
    
    [row, col] = find(img(:, :, 3) > 0);
    newR = row - minHeight + 1;
    newC = col - minWidth + 1;
    idx = sub2ind([newHeight, newWidth], newR, newC); 
    oldTemp = img(:, :, 3);
    newTemp(idx) = oldTemp(sub2ind(size(oldTemp), row, col));
    newImg(:,:,3) = newTemp;

    % Find warp position in relevant to the first image
    warpMinHeight = floor(min(warpCorner(:, 2)));
    warpMinWidth = floor(min(warpCorner(:, 1)));
   
    % Copy warp image into the new image by channel
    newTemp = newImg(:,:,1);
    [row, col] = find(warpImg(:, :, 1) > 0);
    newR = row + warpMinHeight - minHeight;
    newC = col + warpMinWidth - minWidth;
    idx = sub2ind([newHeight, newWidth], newR, newC); 
    oldTemp = warpImg(:, :, 1);
    newTemp(idx) = oldTemp(sub2ind(size(oldTemp), row, col));
    newImg(:,:,1) = newTemp;
    
    newTemp = newImg(:,:,2);
    [row, col] = find(warpImg(:, :, 2) > 0);
    newR = row + warpMinHeight - minHeight;
    newC = col+warpMinWidth - minWidth;
    idx = sub2ind([newHeight, newWidth], newR, newC); 
    oldTemp = warpImg(:, :, 2);
    newTemp(idx) = oldTemp(sub2ind(size(oldTemp), row, col));
    newImg(:,:,2) = newTemp;
    
    newTemp = newImg(:,:,3);
    [row, col] = find(warpImg(:, :, 3) > 0);
    newR = row + warpMinHeight - minHeight;
    newC = col+warpMinWidth - minWidth;
    idx = sub2ind([newHeight, newWidth], newR, newC); 
    oldTemp = warpImg(:, :, 3);
    newTemp(idx) = oldTemp(sub2ind(size(oldTemp), row, col));
    newImg(:,:,3) = newTemp;
    
    newImg = uint8(newImg);
end

