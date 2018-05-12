function [accuracy] = quantitativeEvaluation(database, databaseIm, means)
    % For each type of images, report the average ?top-K? accuracy 
    % for each type of images, for K=1,3,5. 
    %
    % database - a 1000 * 802 matrix representing bags of words for 802
    %   reference images
    % databaseIm - a 1 * 802 matrix representing the image 
    %   that bag belongs to
    % means - 128 * 1000 matrix representing 1000 centerdescriptors
    %
    % accuracy - a 4 * 3 matrix with each row indicate the accuracy
    %   of that type with K = 1, 3, 5 

    basedir = './data/';
    typenames = {'video_frames', 'print', 'book_covers', 'landmarks'};
    
    accuracy = zeros(length(typenames), 3);
    
    % loop over the genres of images
    for t = 1:length(typenames)
        topdir = [basedir typenames{t} '/'];
        refimnames = dir([topdir '/Reference/*.jpg']);
        
        hist = zeros(0, 1000);         % all bags of words in this type
        correctNames = strings(0, 5);        % record the correct images
        icount = 0;          % total number of images in this type
        
        % loop over every image
        for r=1:length(refimnames)
            camnames = dir(topdir);
            for c = 3:length(camnames)
                
                if(~isequal(camnames(c).name, 'Reference') && ...
                        ~isequal(camnames(c).name, '.DS_Store'))
                    load([topdir '/' camnames(c).name '/' refimnames(r).name...
                        '.sift.mat'], 'frames', 'desc');
                    
                    % Compute bag of words
                    distMeans1 = dist2(double(desc)', double(means)');
                    [~, sortedIndices] = min(distMeans1, [], 2);
                    hist1 = histcounts(sortedIndices, (1:1000+1));
                    
                    hist = vertcat(hist, hist1);
                    name = strings(1, 5);
                    name(1, :) = strcat(topdir, 'Reference/', refimnames(r).name);
                    correctNames = vertcat(correctNames, name);
                    icount = icount+1;
                end
            end
        end
        
        % Compute similarity
        distIm = getSim(double(hist), double(database));
        
        % Find top 5 images
        [~, sortedIndices] = sort(distIm, 2, 'descend');
        foundIndices = sortedIndices(:, 1:5);
        foundNames = reshape(databaseIm(1, foundIndices), [], 5);
        
        % Compare found images with the correct images
        tf = strcmp(correctNames, foundNames);
        % Compute accuracy for K = 1, 3, 5
        tmp = tf(:, 1);
        accuracy(t, 1) = sum(tmp(:));
        tmp = tf(:, 1:3);
        accuracy(t, 2) = sum(tmp(:));
        tmp = tf(:, 1:5);
        accuracy(t, 3) = sum(tmp(:));
        
        accuracy(t, :) = double(accuracy(t, :)) ./ double(icount);
    end
end

