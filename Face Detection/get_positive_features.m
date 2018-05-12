% Starter code prepared by James Hays for CS 143, Brown University
% This function should return all positive training examples (faces) from
% 36x36 images in 'train_path_pos'. Each face should be converted into a
% HoG template according to 'feature_params'. For improved performance, try
% mirroring or warping the positive training examples.

function features_pos = get_positive_features(train_path_pos, train_path_pos1, feature_params)
% 'train_path_pos' is a string. This directory contains 36x36 images of
%   faces
% 'feature_params' is a struct, with fields
%   feature_params.template_size (probably 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.


% 'features_pos' is N by D matrix where N is the number of faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% if you're using the default vl_hog parameters

% Useful functions:
% vl_hog, HOG = VL_HOG(IM, CELLSIZE)
%  http://www.vlfeat.org/matlab/vl_hog.html  (API)
%  http://www.vlfeat.org/overview/hog.html   (Tutorial)
% rgb2gray

image_files = dir( fullfile( train_path_pos, '*.jpg') ); %Caltech Faces stored as .jpg
num_images = length(image_files);

features_pos = zeros(num_images * 2, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);

% Loop through each face image and append its HoG features 
for i = 1 : num_images
    im1 = im2single(imread(fullfile(train_path_pos, image_files(i).name)));
    im2 = flip(im1, 2);
    hog1 = vl_hog(im1, feature_params.hog_cell_size, 'verbose');
    features_pos(i, :) = reshape(hog1, 1, []);
    hog2 = vl_hog(im2, feature_params.hog_cell_size, 'verbose');
    features_pos(i+num_images, :) = reshape(hog2, 1, []);
end

% Additional images from AT&T dataset
for j = 1 : 40
    image_files = dir( fullfile( train_path_pos1, 's'+j, '*.pgm') ); %Caltech Faces stored as .jpg
    num_images = length(image_files);
    
    features_pos1 = zeros(num_images, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);
    
    % Loop through each face image and append its HoG features
    for i = 1 : num_images
        im1 = imresize(im2single(imread(fullfile(train_path_pos, image_files(i).name))), [36, 36]);
        hog1 = vl_hog(im1, feature_params.hog_cell_size, 'verbose');
        features_pos1(i, :) = reshape(hog1, 1, []);
    end
    features_pos = [features_pos; features_pos1];
end

end