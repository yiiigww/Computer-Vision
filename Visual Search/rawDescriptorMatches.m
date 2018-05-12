function [ matchMatrix ] = rawDescriptorMatches( imPath1, imPath2 )
    % Given two images, load their SIFT descriptors and
    % compute the nearest neighbor matches. 
    %
    % imPath1 - path to the first image
    % imPath2 - path to the second image
    %
    % matchMatrix - a 3 x n matrix containing n matches.
    % -- first row: indices in im1
    % -- second row: indices in im2 that they matched to
    % -- third row: distances

    % Some flags
    SHOW_ALL_MATCHES_AT_ONCE = 1;

    % Constants
    N = 25;  % how many SIFT matches to display.
    
    % read in the first image.
    im1 = im2single(rgb2gray(imread(imPath1)));

    % get its precomputed SIFT descriptors from mat file.
    load([imPath1 '.sift.mat'], 'frames', 'desc');
    
    frames1 = frames;
    desc1 = desc;
    
    % read in the second image.
    im2 = im2single(rgb2gray(imread(imPath2)));
    
    % get its precomputed SIFT descriptors from mat file.
    load([imPath2 '.sift.mat'], 'frames', 'desc');
    
    frames2 = frames;
    desc2 = desc;
    
    % Compute the Euclidean distance between all descriptors in image 1
    % and all descriptors in Canon image.
    dists = dist2(double(desc1)', double(desc2)');
    
    % Sort those distances.
    [sortedDists, sortedIndices] = sort(dists, 2, 'ascend');
    
    % Take the first neighbor as a candidate match.
    % Record the match as a column in the matrix 'matchMatrix',
    % where the first row gives the index of the feature from the first
    % image, the second row gives the index of the feature matched to it in
    % the second image, and the third row records the distance between
    % them.
    
    % Ramdomly downsample the matches.
    refN = size(desc1,2);
    randomIndices = randperm(refN);
    matchMatrix = [randomIndices(1: 25); ...
        sortedIndices(randomIndices(1: 25), 1)'; ...
        sortedDists(randomIndices(1: 25), 1)'];
        
    % Display the matched patch
    clf;
    showMatchingPatches(matchMatrix, desc1, desc2, frames1, frames2, ...
        im1, im2, SHOW_ALL_MATCHES_AT_ONCE);
    hold on;
    title('displays SIFT matches with descriptors');
    fprintf('Showing samples of nearest neighbor patch match. Type dbcont to continue.\n');
    keyboard;
    
    % Show lines connecting the matches (no patches)
    clf;
    showLinesBetweenMatches(im1, im2, frames1, frames2, matchMatrix);
    hold on;
    title('displays SIFT matches with lines');
    fprintf('Showing the matches with lines connecting. Type dbcont to continue.\n');
    keyboard;
end

