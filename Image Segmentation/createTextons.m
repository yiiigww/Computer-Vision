function [textons] = createTextons(imStack, bank, k)
    % imStack - a cell array of containing n grayscale images
    %
    % bank - a m * m * d matrix containing d filters
    %
    % k - number of cluster centers
    %
    % textons -  a k * d matrix with d textons in each center
    %
    % Compute a texton codebook based on images' responses to sample
    % filters. For each image in imStack, apply each filter and record
    % the responses. Sample the responses from all pixels and find k
    % cluster centers which will be the textons.

    % Get number of images and filters
    [h, w] = size(imStack);
    numIm = h * w;
    [~, ~, numFilter] = size(bank);

    response = uint8.empty;

    % Loop through each image
    for i = 1 : numIm
        % Get the size of this image
        [h, w] = size(imStack{i});
        oneResponse = zeros(h, w, numFilter);
        % Loop through each filter and record the filter responses
        for j = 1 : numFilter
            oneResponse(:,:,j) = imfilter(imStack{i}, bank(:,:,j));
        end
        response = [response; reshape(oneResponse, h * w, numFilter)];
    end

    % Select samples randomly, one sample pixel per 200 pixels
    [max, ~] = size(response);
    sample = randi(max, fix(max/2000), 1);
    [~,textons] = kmeans(double(response(sample, :)), k);
end

