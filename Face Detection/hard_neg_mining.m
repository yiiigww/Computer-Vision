function features_hard_neg= hard_neg_mining(non_face_scn_path, w, b, feature_params)
% 'non_face_scn_path' is a string. This directory contains many images
%   which have no faces in them.
% 'w' and 'b' are the linear classifier parameters
% 'feature_params' is a struct, with fields
%   feature_params.template_size (probably 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.

% % 'features_neg' is N/2 by D matrix where N is the number of non-faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% if you're using the default vl_hog parameters

test_scenes = dir( fullfile( non_face_scn_path, '*.jpg' ));

features_hard_neg = zeros(0, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);

num_cells_per_template = feature_params.template_size / feature_params.hog_cell_size;

scales = 0.9 .^ (0 : 30);
% scales = 0.7 .^ (0 : 15);

for i = 1:2:length(test_scenes)

    img = imread( fullfile( non_face_scn_path, test_scenes(i).name ));
    img = single(img)/255;
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end

    for scale = scales
        resized_img = im2single(imresize(img, scale));
        if min(size(resized_img)) < feature_params.template_size
            break;
        end
        hog = vl_hog(resized_img, feature_params.hog_cell_size);
        max_r = size(hog, 1) - num_cells_per_template + 1;
        max_c = size(hog, 2) - num_cells_per_template + 1;
        
        % Loop through each template in the hog
        for r = 1 : max_r
            for c = 1 : max_c
                template_hog = reshape(hog(r : r + num_cells_per_template - 1, ...
                    c : c + num_cells_per_template - 1, :), 1, []);
                score = template_hog * w + b;
                if score > 1
                    features_hard_neg = [features_hard_neg; template_hog];
                end
            end
        end
    end
end
end






