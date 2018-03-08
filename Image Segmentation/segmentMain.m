% Read the images
gumballs = imread('gumballs.jpg');
snake = imread('snake.jpg');
twins = imread('twins.jpg');
redPanda = imread('red_panda.jpg');

% Load the filteer bank
load('filterBank.mat');

% Create image stack with gray images
grayGumballs = rgb2gray(gumballs);
graySnake = rgb2gray(snake);
grayTwins = rgb2gray(twins);
grayRedPanda = rgb2gray(redPanda);
imStack = {grayGumballs, graySnake, grayTwins, grayRedPanda};

% Generate texton codebook
textons = createTextons(imStack, F, 10); 

% gumballs
[colorLabelIm, textureLabelIm] = compareSegmentations(gumballs, F, ...
                                    textons, 9, 6, 3);
color = label2rgb(colorLabelIm);
texture = label2rgb(textureLabelIm);

subplot(3, 1, 1);
imshow(gumballs);
title('Original gumballs');

subplot(3, 1, 2);
imshow(color);
title('Color labeled gumballs with 6 color regions');

subplot(3, 1, 3);
imshow(texture);
title('Texture labeled gumballs with 3 texture regions');


% snake
[colorLabelIm, textureLabelIm] = compareSegmentations(snake, F, ...
                                    textons, 9, 4, 5);
color = label2rgb(colorLabelIm);
texture = label2rgb(textureLabelIm);

subplot(3, 1, 1);
imshow(snake);
title('Original snake');

subplot(3, 1, 2);
imshow(color);
title('Color labeled snake with 4 color regions');

subplot(3, 1, 3);
imshow(texture);
title('Texture labeled snake with 5 texture regions');


% twins
[colorLabelIm, textureLabelIm] = compareSegmentations(twins, F, ...
                                    textons, 15, 6, 7);
color = label2rgb(colorLabelIm);
texture = label2rgb(textureLabelIm);

subplot(3, 1, 1);
imshow(twins);
title('Original twins');

subplot(3, 1, 2);
imshow(color);
title('Color labeled twins with 6 color regions');

subplot(3, 1, 3);
imshow(texture);
title('Texture labeled twins with 7 texture regions');


% stars
[colorLabelIm, textureLabelIm] = compareSegmentations(redPanda, F, ...
                                    textons, 9, 5, 4);
color = label2rgb(colorLabelIm);
texture = label2rgb(textureLabelIm);

subplot(3, 1, 1);
imshow(redPanda);
title('Original red panda');

subplot(3, 1, 2);
imshow(color);
title('Color labeled red panda with 5 color regions');

subplot(3, 1, 3);
imshow(texture);
title('Texture labeled red panda with 4 texture regions');


% twins different window size
[colorLabelIm, textureLabelIm] = compareSegmentations(twins, F, ...
                                    textons, 5, 6, 7);
texture1 = label2rgb(textureLabelIm);

[colorLabelIm, textureLabelIm] = compareSegmentations(twins, F, ...
                                    textons, 30, 6, 7);
texture2 = label2rgb(textureLabelIm);

subplot(3, 1, 1);
imshow(twins);
title('Original twins');

subplot(3, 1, 2);
imshow(texture1);
title('Texture labeled twins with window size 5');

subplot(3, 1, 3);
imshow(texture2);
title('Texture labeled twins with window size 30');


% Load different filter bank
secF = F(:,:,3:5) + F(:,:,9:11) + F(:,:,15:17) + F(:,:,21:23)...
    + F(:,:,27:29) + F(:,:,33:35);

% Create image stack with gray images
grayGumballs = rgb2gray(gumballs);
graySnake = rgb2gray(snake);
grayTwins = rgb2gray(twins);
grayRedPanda = rgb2gray(redPanda);
imStack = {grayGumballs, graySnake, grayTwins, grayRedPanda};

% Generate texton codebook
textons1 = createTextons(imStack, F, 10); 
textons2 = createTextons(imStack, secF, 10); 

[colorLabelIm, textureLabelIm] = compareSegmentations(twins, F, ...
                                    textons1, 15, 6, 7);
texture1 = label2rgb(textureLabelIm);
[colorLabelIm, textureLabelIm] = compareSegmentations(twins, secF, ...
                                    textons2, 15, 6, 7);
texture2 = label2rgb(textureLabelIm);

subplot(3, 1, 1);
imshow(twins);
title('Original twins');

subplot(3, 1, 2);
imshow(texture1);
title('Texture labeled twins with all filters');

subplot(3, 1, 3);
imshow(texture2);
title('Texture labeled twins with vertical filters');




