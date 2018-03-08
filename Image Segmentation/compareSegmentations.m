function [colorLabelIm, textureLabelIm] = compareSegmentations(origIm, bank, textons, winSize, numColorRegions, numTextureRegions)
    % origIm - a h * w * 3 RGB image
    %
    % bank - a m * m * d matrix containing d filters
    %
    % textons - a k * d matrix with d textons in each center
    %
    % winSize - the size of the window to check neighbor textons
    %
    % numColorRegions - number of color segment to show
    %
    % numTextureRegions - number of color segment to show
    %
    % colorLabelIm - pixel labeled based on color segment 
    %
    % textureLabelIm - pixel labeled based on texture segment 
    %
    % Label the image in two ways: segmented in colors and 
    % segmented in textures.

    % Reshape the image into a 2-D matrix such that each pixel
    % has a vector of its color feature
    % After labeling each pixel, reshape it to a h*w matrix
    [h, w, d] = size(origIm); 
    pixelColor = reshape(origIm, h * w, d);
    colorCentered = kmeans(im2double(pixelColor), numColorRegions);
    colorLabelIm = reshape(colorCentered, h, w);

    % Reshape the gray image into a 2-D matrix such that each pixel
    % has a vector of its texton histogram
    % After labeling each pixel, reshape it to a h*w matrix
    grayIm = rgb2gray(origIm);
    textonHist = extractTextonHists(grayIm, bank, textons, winSize);
    [h, w, k] = size(textonHist);  
    hist = reshape(textonHist, h * w, k);
    textureCentered = kmeans(im2double(hist), numTextureRegions);  
    textureLabelIm = reshape(textureCentered, h, w);
end

