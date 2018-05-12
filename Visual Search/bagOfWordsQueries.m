function [database,databaseIm] = bagOfWordsQueries(means)
    % Full frame queries 
    % Loop through all the reference images and create bag of words using 
    % means computed from visualizeVocabulary.m
    %
    % means - 128 * 1000 matrix representing 1000 center descriptors
    % 
    % database - a 1000 * 802 matrix representing bags of words for 802
    %   reference images
    % databaseIm - a 1 * 802 matrix representing the image 
    %   that bag belongs to

    % Constants
    K = 1000;  % number of cluster centers
    
    % Data directories
    basedir = './data/';

    typenames = {'video_frames', 'print', 'book_covers', 'landmarks'};

    database = zeros(K, 0);     % Bag of words from all images
    databaseIm = zeros(1, 0);         % Images of bags
    
    % loop over the genres of images
    for t = 1:length(typenames)
      topdir = [basedir typenames{t} '/']; 
      refimnames = dir([topdir 'Reference/*.jpg']);
      
      % loop over the reference images in that genre
      for r=1:length(refimnames)
          % read in its SIFT descriptors (pre-computed) from the mat file
          load([topdir 'Reference/' refimnames(r).name '.sift.mat'], ...
              'frames', 'desc');
          dists = dist2(double(desc)', double(means)');
          
          % Compute bag of words 
          [~, sortedIndices] = min(dists, [], 2);
          hist = histcounts(sortedIndices, (1:K+1));
          
          database = horzcat(database, hist');
          % Save the image names
          im = strings(1, 1);
          im(1, 1) = strcat(topdir, 'Reference/', refimnames(r).name);
          databaseIm = horzcat(databaseIm, im);
      end
    end    
end

