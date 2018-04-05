function [warpImg] = createWarp(img, H)
    % img - the input image to warp from
    % H - the homography matrix
    % For each pixel in the new image, apply inverse warping to
    % get the source point, then use interp2 get the interpolated color.

    % Find where the corner of the source image will map.
    [h, w, ~] = size(img);
    cornerPoint = [1 w 1 w; 1 1 h h; 1 1 1 1];
    dstCornerPoint = H * cornerPoint;
    estCornerPoint = [(dstCornerPoint(1, :)./dstCornerPoint(3, :)).'...
    (dstCornerPoint(2, :)./dstCornerPoint(3, :)).'];

    % The bounding values of the warp image.
    maxWidth = ceil(max(estCornerPoint(:, 1)));
    minWidth = floor(min(estCornerPoint(:, 1)));
    maxHeight = ceil(max(estCornerPoint(:, 2)));
    minHeight = floor(min(estCornerPoint(:, 2)));

    % Compute the size based on the bounds.
    newHeight = maxHeight - minHeight + 1;
    newWidth = maxWidth - minWidth + 1;
    warpImg = zeros(newHeight, newWidth, 3);
    
    % Create all possiblt pixels within the bounds.
    x = minWidth : maxWidth;
    y = minHeight : maxHeight;
    [X,Y] = meshgrid(x,y);
    perm = reshape(cat(2,X',Y'),[],2);
    dstPoint = [perm.'];
    [~, w]= size(dstPoint);
    dstPoint = [dstPoint; ones(1, w)];

    % Apply inverse warping to every destination points
    srcPoint = H\dstPoint;
    estPoint = round([(srcPoint(1, :)./srcPoint(3, :)).' ...
        (srcPoint(2, :)./srcPoint(3, :)).']);

    % Adjust indices to starting at 1
    perm(:, 1) = perm(:, 1) - minWidth + 1;
    perm(:, 2) = perm(:, 2) - minHeight + 1;

    [h, w, ~] = size(warpImg);
    idx = sub2ind([h, w], perm(:,2), perm(:,1)); 
    
    % Convert each channel at a time
    temp = warpImg(:,:,1);
    temp(idx) = interp2(double(img(:,:,1)), estPoint(:,1), estPoint(:,2));
    warpImg(:,:,1) = temp;
    
    temp(idx) = interp2(double(img(:,:,2)), estPoint(:,1), estPoint(:,2));
    warpImg(:,:,2) = temp;
    
    temp(idx) = interp2(double(img(:,:,3)), estPoint(:,1), estPoint(:,2));
    warpImg(:,:,3) = temp;

    warpImg = uint8(warpImg);
end

