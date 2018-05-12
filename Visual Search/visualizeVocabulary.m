function [ membership, means ] = visualizeVocabulary()
    % Build a visual vocabulary with 1000 means
    %
    % means - 128 * 1000 matrix representing 1000 center descriptors

    % Constants
    K = 1000;  % number of cluster centers

    % Data directories
    basedir = './data/';

    typenames = {'video_frames', 'print', 'book_covers', 'landmarks'};

    sampleDesc = zeros(128, 0);     % Random descriptors from all images
    sampleFrames = zeros(4, 0);     % Frames of those descriptors
    sampleTags = strings(1, 0);       % Images of those descriptors
    
    % loop over the genres of images
    for t = 1:length(typenames)
      topdir = [basedir typenames{t} '/']; 
      refimnames = dir([topdir 'Reference/*.jpg']);
      
      % loop over the reference images in that genre
      for r=1:length(refimnames)
          % read in its SIFT descriptors (pre-computed) from the mat file
          load([topdir 'Reference/' refimnames(r).name '.sift.mat'], ...
              'frames', 'desc');
          
          % Ramdomly downsample the descriptors to 1/30
          descN = size(desc, 2);
          randomIndices = randperm(descN);
          
          sampleDesc = horzcat(sampleDesc, ...
              desc(:, randomIndices(1, 1:round(descN/30))));
          
          % Records the frames and images of the chosen descriptors.
          sampleFrames = horzcat(sampleFrames, ...
              frames(:, randomIndices(1, 1:round(descN/30))));
          
          tag = strings(1, round(descN/30));
          tag(1, :) = strcat(topdir, 'Reference/', refimnames(r).name);
          sampleTags = horzcat(sampleTags, tag);
      end
    end
    
    % Divides sample descriptors into 1000 cluster centers
    [membership, means, ~] = kmeansML(K, double(sampleDesc));
end

