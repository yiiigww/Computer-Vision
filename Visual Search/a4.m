% Code from a4starter.m
% add vl feats to the search path.
run('../vlfeat-0.9.21/toolbox/vl_setup');

% Some flags
DISPLAY_PATCHES = 1;
SHOW_ALL_MATCHES_AT_ONCE = 1;

% Constants
K = 1000;  % number of cluster centers

% Q1. Raw descriptor matching using image from 'print'.
    % Data directories
    basedir = './data/';
    typenames = {'video_frames', 'print', 'book_covers', 'landmarks'};
    topdir = [basedir typenames{2} '/'];

    % 1st reference image in print.
    refimnames = dir([topdir 'Reference/*.jpg']);
    imPath1 = [topdir 'Reference/' refimnames(1).name];

    % 1st image taken by Canon in print.
    camnames = dir(topdir);
    imPath2 = [topdir '/' camnames(3).name '/' refimnames(1).name];

    matchMatrix = rawDescriptorMatches(imPath1, imPath2);

% Q2. Visualizing the vocabulary
    [membership, means] = visualizeVocabulary();
    % means = load('means.mat');
    % membership = load('membership.mat');

    % Finds two random words
    randWordIndices = randperm(K,2);
    for wordIndex = randWordIndices
        % Finds the first 15 patches of that word
        patchIndices = find(membership == wordIndex, 15);
        for i = 1 : 15
            patchIndex = patchIndices(i);
            patch = getPatchFromSIFTParameters(...
                sampleFrames(1:2, patchIndex), ...
                sampleFrames(3, patchIndex), ...
                sampleFrames(4, patchIndex), ...
                rgb2gray(imread(char(sampleTags(1, patchIndex)))));
            subplot(3,5,i);
            imshow(patch);
        end
        fprintf('Showing descriptors of one word. Type dbcont to continue.\n');
        keyboard;
    end

% Q3. Full frame queries
    [database, databaseIm] = bagOfWordsQueries(means);
    % database = load('allBagsOfWords.mat');
    % databaseIm = load('allBagsIm.mat');
    
    % Mobile phone image examples
    im1 = imread('./data/video_frames/5800/064.jpg');
    load('./data/video_frames/5800/064.jpg.sift.mat', ...
        'frames', 'desc');
    % Compute bag of words
    distMeans = dist2(double(desc)', double(means)');
    [~, sortedIndices] = min(distMeans, [], 2);
    hist = histcounts(sortedIndices', (1:K+1));
    % Find similar reference images
    distIm = getSim(hist, database);
    [~, sortedIndices] = sort(distIm, 2, 'descend');
    subplot(2, 3, 1);
    imshow(im1);
    title('./data/video_frames/5800/064.jpg');
    for i = 1 : 5
        ImIndex = sortedIndices(1, i);
        subplot(2, 3, i+1);
        imshow(imread(char(databaseIm(1, ImIndex))));
        title(databaseIm(1, ImIndex));
    end
    
    im2 = imread('./data/landmarks/Query/450.jpg');
    load('./data/landmarks/Query/450.jpg.sift.mat', ...
        'frames', 'desc');
    % Compute bag of words
    distMeans = dist2(double(desc)', double(means)');
    [~, sortedIndices] = min(distMeans, [], 2);
    hist = histcounts(sortedIndices', (1:K+1));
    % Find similar reference images
    distIm = getSim(hist, database);
    [~, sortedIndices] = sort(distIm, 2, 'descend');
    subplot(2, 3, 1);
    imshow(im2);
    title('./data/landmarks/Query/450.jpg');
    for i = 1 : 5
        ImIndex = sortedIndices(1, i);
        subplot(2, 3, i+1);
        imshow(imread(char(databaseIm(1, ImIndex))));
        title(databaseIm(1, ImIndex));
    end
    
    im3 = imread('./data/print/Palm/083.jpg');
    load('./data/print/Palm/083.jpg.sift.mat', ...
        'frames', 'desc');
    % Compute bag of words
    distMeans = dist2(double(desc)', double(means)');
    [~, sortedIndices] = min(distMeans, [], 2);
    hist = histcounts(sortedIndices', (1:K+1));
    % Find similar reference images
    distIm = getSim(hist, database);
    [~, sortedIndices] = sort(distIm, 2, 'descend');
    subplot(2, 3, 1);
    imshow(im3);
    title('./data/print/Palm/083.jpg');
    for i = 1 : 5
        ImIndex = sortedIndices(1, i);
        subplot(2, 3, i+1);
        imshow(imread(char(databaseIm(1, ImIndex))));
        title(databaseIm(1, ImIndex));
    end

% Q4. Quantitatively evaluate your results for retrieval 
    [accuracy] = quantitativeEvaluation(database, databaseIm, means);
    % accuracy = load('accuracy.mat');
    
% Q5. Spatial verification
% Using image 490 from landmark as an example

    % Top 5 images without Spatial verification 
    top5 = strings(1, 5);
    im = imread('./data/landmarks/Query/490.jpg');
    load('./data/landmarks/Query/490.jpg.sift.mat', ...
        'frames', 'desc');
    distMeans = dist2(double(desc)', double(means)');
    % Sort those distances.
    [~, sortedIndices] = min(distMeans, [], 2);
    hist = histcounts(sortedIndices', (1:1000+1));
    distIm = getSim(hist, database1);
    % Sort those distances.
    [~, sortedIndices] = sort(distIm, 2, 'descend');
    subplot(2, 3, 1);
    imshow(im);
    title('./data/landmarks/Query/490.jpg');
    for i = 1 : 5 
        ImIndex = sortedIndices(1, i);
        subplot(2, 3, i+1);
        top5(1, i) = databaseIm(1, ImIndex);
        imshow(imread(char(databaseIm(1, ImIndex))));
        title(databaseIm(1, ImIndex));
    end

    % Loop through the top images and do spatial verification on each one
    % Resort them based on number of inliers
    inliers = zeros(1, 5);
    for i = 1:5
        imPath1 = './data/landmarks/Query/490.jpg';
        imPath2 = char(top5(1, i));
        inliers(1, i) = spatialVerification(imPath1,imPath2);
    end
    
    [~, sortedIndices] = sort(inliers, 2, 'descend');
    
    % Reordered top 5 images after Spatial verification 
    subplot(2, 3, 1);
    imshow(im);
    title('./data/landmarks/Query/490.jpg');
    for i = 1 : 5
        ImIndex = sortedIndices(1, i);
        subplot(2, 3, i+1);
        imshow(imread(char(top5(1, ImIndex))));
        title(top5(1, ImIndex));
    end
