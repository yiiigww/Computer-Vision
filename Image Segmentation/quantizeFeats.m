function [labelIm] = quantizeFeats(featIm, meanFeats)
    % featIm - a h * w * d matrix where the dimensionality 
    % of the feature vector is computed for each pixel.
    %
    % meanFeats - a k * d matrix of k cluster centers as
    % d-dimensional vector.
    %
    % labelIm - a h * w matrix labeled where each pixel 
    % is labeled which cluster it belongs to.
    %
    % Labels each pixel with the cluster it belongs to by
    % calculating the distance between each pixel's vector 
    % and each cluster center. The index of the minimum of 
    % the distances is the cluster that pixel belongs to.

    [h, w, d] = size(featIm);
    labelIm = zeros(h, w);

    % Loop through each column and find the cluster for 
    % that column of pixels using dist2.m
    for col = 1 : w
        % Create a matrix of vectors for each pixel in a column
        x = reshape(featIm(:, col, :), h, d);
        % Save the cluster where the pixel is closest to in labelIm
        [~, labelIm(:,col)] = min(dist2(x, meanFeats),[],2);
    end
end