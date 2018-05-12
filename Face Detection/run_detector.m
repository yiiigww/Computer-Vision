% Starter code prepared by James Hays for CS 143, Brown University
% This function returns detections on all of the images in a given path.
% You will want to use non-maximum suppression on your detections or your
% performance will be poor (the evaluation counts a duplicate detection as
% wrong). The non-maximum suppression is done on a per-image basis. The
% starter code includes a call to a provided non-max suppression function.
function [bboxes, confidences, image_ids] = .... 
    run_detector(test_scn_path, w, b, feature_params)
% 'test_scn_path' is a string. This directory contains images which may or
%    may not have faces in them. This function should work for the MIT+CMU
%    test set but also for any other images (e.g. class photos)
% 'w' and 'b' are the linear classifier parameters
% 'feature_params' is a struct, with fields
%   feature_params.template_size (probably 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.

% 'bboxes' is Nx4. N is the number of detections. bboxes(i,:) is
%   [x_min, y_min, x_max, y_max] for detection i. 
%   Remember 'y' is dimension 1 in Matlab!
% 'confidences' is Nx1. confidences(i) is the real valued confidence of
%   detection i.
% 'image_ids' is an Nx1 cell array. image_ids{i} is the image file name
%   for detection i. (not the full path, just 'albert.jpg')

% The placeholder version of this code will return random bounding boxes in
% each test image. It will even do non-maximum suppression on the random
% bounding boxes to give you an example of how to call the function.

% Your actual code should convert each test image to HoG feature space with
% a _single_ call to vl_hog for each scale. Then step over the HoG cells,
% taking groups of cells that are the same size as your learned template,
% and classifying them. If the classification is above some confidence,
% keep the detection and then pass all the detections for an image to
% non-maximum suppression. For your initial debugging, you can operate only
% at a single scale and you can skip calling non-maximum suppression.

test_scenes = dir( fullfile( test_scn_path, '*.jpg' ));
num_cells_per_template = feature_params.template_size / feature_params.hog_cell_size;


%initialize these as empty and incrementally expand them.
bboxes = zeros(0,4);
confidences = zeros(0,1);
image_ids = cell(0,1);

scales = 0.9 .^ (0 : 30);
% scales = 0.7 .^ (0 : 10);

for i = 1:length(test_scenes)

%     fprintf('Detecting faces in %s\n', test_scenes(i).name)
    img = imread( fullfile( test_scn_path, test_scenes(i).name ));
    img = single(img)/255;
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end
    
    cur_bboxes = [];
    cur_confidences = [];
    cur_image_ids = [];
    
    for scale = scales
        resized_img = im2single(imresize(img, scale));
        if min(size(resized_img)) < feature_params.template_size
            break;
        end
        hog = vl_hog(resized_img, feature_params.hog_cell_size);
        max_r = size(hog, 1) - num_cells_per_template + 1;
        max_c = size(hog, 2) - num_cells_per_template + 1;
        
        template_hog = zeros(max_r * max_c, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);
        % Loop through each template in the hog
        for r = 1 : max_r
            for c = 1 : max_c
                template_hog((r - 1) * max_c + c, :) = reshape(hog(r : r + num_cells_per_template - 1, ...
                    c : c + num_cells_per_template - 1, :), 1, []);
            end
        end
        
        % find faces above threshold confidence
        scores = template_hog * w + b;
        indices = find(scores > 0.5);
        
        % compute x and y cordinates for this hog in original image
        template_x = mod(indices, max_c)-1;
        template_y = floor(indices./max_c);
        cur_x_min = template_x * feature_params.hog_cell_size + 1;
        cur_y_min = template_y * feature_params.hog_cell_size + 1;
        cur_x_max = (template_x + num_cells_per_template) * feature_params.hog_cell_size;
        cur_y_max = (template_y + num_cells_per_template) * feature_params.hog_cell_size;

        cur_bboxes = [cur_bboxes; [cur_x_min, cur_y_min, cur_x_max, cur_y_max] ./ scale];
        cur_confidences = [cur_confidences; scores(indices)];
        cur_image_ids = [cur_image_ids; repmat({test_scenes(i).name}, size(indices,1), 1)];
    end

    %non_max_supr_bbox can actually get somewhat slow with thousands of
    %initial detections. You could pre-filter the detections by confidence,
    %e.g. a detection with confidence -1.1 will probably never be
    %meaningful. You probably _don't_ want to threshold at 0.0, though. You
    %can get higher recall with a lower threshold. You don't need to modify
    %anything in non_max_supr_bbox, but you can.
    [is_maximum] = non_max_supr_bbox(cur_bboxes, cur_confidences, size(img));

    cur_confidences = cur_confidences(is_maximum,:);
    cur_bboxes      = cur_bboxes(     is_maximum,:);
    cur_image_ids   = cur_image_ids(  is_maximum,:);
 
    bboxes      = [bboxes;      cur_bboxes];
    confidences = [confidences; cur_confidences];
    image_ids   = [image_ids;   cur_image_ids];
end
end




