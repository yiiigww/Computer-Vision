function [inlier] = spatialVerification(imPath1,imPath2)
    % Spatial verification
    % RANSAC Loop:
    % Randomly select 6 matches from two images.
    % Calculate the affine transformation
    % Apply the transformation and compare the euclidean distance
    % Use threshold to find inliers
    % Loop 100 times to find the maximum number of inliers
    % 
    % imPath1 - path to the first image
    % imPath2 - path to the second image
    % 
    % inlier - number of maximum inliers of these two images
    
    % Retrieve information from two images
    load([imPath1 '.sift.mat'], 'frames', 'desc');
    frames1 = frames;
    desc1 = desc;
    load([imPath2 '.sift.mat'], 'frames', 'desc');
    frames2 = frames;
    desc2 = desc;

    % Compute the Euclidean distance between all descriptors 
    % in image 1 and image 2.
    dists = dist2(double(desc1)', double(desc2)');

    % Sort those distances.
    [~, sortedIndices] = min(dists, [], 2);

    allPoints1 = frames1(1:2, :);

    maxInlier = 0;
    for i = 1:300
        % Ramdomly downsample the matches.
        refN = size(desc1,2);
        randomIndices = randperm(refN, 6);
        
        % Compute the affine transformation
        points1 = frames1(1:2, randomIndices)';
        points2 = frames2(1:2, sortedIndices(randomIndices, :))';
        [M, T] = computeAffine(points1,points2);
        
        % Apply the affine transformation to points1 
        % and get estimated points
        estPoints = M * allPoints1 + T;

        % Calculate the distance between estimated points and
        % actual points with smallest distance
        allPoints2 = frames2(1:2, sortedIndices(:, :));
        euDist = euclideanDist(estPoints, allPoints2);
        inlier = numel(find(euDist < 30));
        
        % Update max if necessary
        if inlier > maxInlier
            maxInlier = inlier;
        end
    end
end

