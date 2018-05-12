function [similarity] = getSim(query, database)
    % Get the similarity between two bags of words.
    %
    % query - a n * 1000 matrix query images' bag of words
    %   n is the number of images
    % database - a 1000 * 802 matrix representing bags of words for 802
    %   reference images
    % similarity - a n * 802 matrix with each element representing 
    %   the similarity between ith image in query and jth reference image
    
    similarity = zeros(size(query, 1), size(database, 2));
    % Loop through the bags of the query images
    for row = 1 : size(query, 1)
        im = query(row, :);
        % Loop through the bags of all reference images
        for col = 1 : size(database, 2)
            word = database(:, col);
            tmp1 = dot(im, word);
            numerator = sum(tmp1(:));
            tmp2 = im .^2;
            tmp3 = word .^2;
            denominator = sqrt(sum(tmp2(:))) * sqrt(sum(tmp3(:)));
            similarity(row, col) = numerator/denominator;
        end
    end
end

