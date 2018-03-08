function [featIm] = extractTextonHists(origIm, bank, textons, winSize)
    % origIm - a h * w grayscale image
    %
    % bank - a m * m * d matrix containing d filters
    %
    % textons - a k * d matrix with d textons in each center
    %
    % winSize - the size of the window to check neighbor textons
    %
    % featIm - a h * w * k matrix with texton histogram for each pixel
    %
    % Apply each filter to the image such that feature vector is 
    % computed for each pixel. Then label each pixel its texton.
    % Last, construct a texton histogram for each pixel based on the 
    % frequency of each texton within its winSize neighborhood.

    % get featImA used for quantizeFeats
    [h, w] = size(origIm);
    [~, ~, numFilter] = size(bank);
    filterIm = zeros(h, w, numFilter);
    
    % Loop through each filter and apply it to the image
    for i = 1 : numFilter
        filterIm(:,:,i) = imfilter(origIm, bank(:,:,i));
    end

    % get labelIm with textons
    labelIm = quantizeFeats(filterIm, textons);

    % calculate frequency of each texton in window
    [numCenter,~] = size(textons);
    featIm = zeros(h, w, numCenter);
    for i = 1 : h
        for j = 1 : w
            window = labelIm(max(i - fix(winSize / 2), 1) : ... 
                             min(i + fix(winSize / 2), h), ...
                             max(j - fix(winSize / 2), 1) : ...
                             min(j + fix(winSize / 2), w));
            temp = unique(window);
            freq = [temp, histc(window(:), temp)];
            featIm(i, j, freq(:, 1)) = freq(:, 2);
        end
    end
end

