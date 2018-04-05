% PART 1.1 Merge uttower images with clicked correspondences
    uttower1 = imread('uttower1.JPG');
    uttower2 = imread('uttower2.JPG');

    % Step 1. Getting correspondences: choose at least 4 matches
    % The matching points must be chosen in the same order
    imshow(uttower1);
    hold on;
    points1 = ginput();
    imshow(uttower2);
    hold on;
    points2 = ginput();

    % % 5 manually identified points
    % points1 = [372.947389885808,290.468597063622;439.798939641109,...
    %     301.610522022839;478.795676998369,306.067292006525;...
    %     326.151305057096,504.393556280587;179.077895595432,523.334828711256];
    % points2 = [815.281810766721,319.437601957586;885.475938009788,...
    %     323.894371941272;926.701060358891,326.122756933116;...
    %     781.856035889070,537.819331158238;638.125203915172,557.874796084829];

    Step 2. Computing the homography parameters
    H = computeHomography(points1, points2);

    % % check H by ploting the selected points1 on image2
    % [h, ~] = size(points1);
    % srcPoint = [points1.'; ones(1, h)];
    % dstPoint = H * srcPoint;
    % estPoint = [(dstPoint(1, :)./dstPoint(3, :)).'...
    %     (dstPoint(2, :)./dstPoint(3, :)).'];

    % Step 3. Warping between image planes 
    warpImg = createWarp(uttower1, H);

    % Corner points positions of the warp image 
    [h, w, ~] = size(uttower1);
    cornerPoint = [1 w 1 w; 1 1 h h; 1 1 1 1];
    dstCornerPoint = H * cornerPoint;

    warpCorner = [(dstCornerPoint(1, :)./dstCornerPoint(3, :)).'...
        (dstCornerPoint(2, :)./dstCornerPoint(3, :)).'];

    % Step 4. Create the output mosaic
    uttower = merge(uttower2, warpImg, warpCorner);

    % % Show the images
    % subplot(2, 2, 1);
    % imshow(uttower1);
    % hold on;
    % plot(points1(:, 1), points1(:, 2), '*');
    % title('uttower1 with 5 manually identified points');
    % 
    % subplot(2, 2, 2);
    % imshow(uttower2);
    % hold on;
    % plot(estPoint(:, 1), estPoint(:, 2), '*');
    % title('uttower2 with 5 points mapped using H');
    % 
    % subplot(2, 2, 3);
    % imshow(warpImg);
    % title('warp of uttower1 using H');
    % 
    % subplot(2, 2, 4);
    % imshow(uttower);
    % title('merged uttower using uttower2 and warp of uttower1');

% PART 1.2 Merge my own image with clicked correspondences
    uniStudio1 = imread('uniStudio1.jpeg');
    uniStudio2 = imread('uniStudio2.jpeg');

    % Step 1. Getting correspondences: choose at least 4 matches
    % The matching points must be chosen in the same order
    imshow(uniStudio1);
    hold on;
    points1 = ginput();
    imshow(uniStudio2);
    hold on;
    points2 = ginput();

    % % 7 manually identified points
    % points1 = [1189.43811074919,309.021172638437;1323.11889250814,...
    %     304.799674267101;1188.03094462541,331.535830618893;...
    %     1324.52605863192,332.942996742671;1151.44462540717,...
    %     548.239413680782;1383.62703583062,584.825732899023;...
    %     926.298045602606,907.066775244300];
    % points2 = [295.887622149837,140.161237785016;421.125407166124,...
    %     144.382736156352;298.701954397394,161.268729641694;...
    %     422.532573289902,171.118892508143;287.444625407166,...
    %     387.822475570033;495.705211726384,408.929967426710;...
    %     81.9983713355049,794.493485342020];

    % Step 2. Computing the homography parameters
    H = computeHomography(points1, points2);

    % % check H by ploting the selected points1 on image2
    % [h, ~] = size(points1);
    % srcPoint = [points1.'; ones(1, h)];
    % dstPoint = H * srcPoint;
    % estPoint = [(dstPoint(1, :)./dstPoint(3, :)).'...
    %     (dstPoint(2, :)./dstPoint(3, :)).'];

    % Step 3. Warping between image planes 
    warpImg = createWarp(uniStudio1, H);

    % Corner points positions of the warp image 
    [h, w, ~] = size(uniStudio1);
    cornerPoint = [1 w 1 w; 1 1 h h; 1 1 1 1];
    dstCornerPoint = H * cornerPoint;

    warpCorner = [(dstCornerPoint(1, :)./dstCornerPoint(3, :)).'...
        (dstCornerPoint(2, :)./dstCornerPoint(3, :)).'];

    % Step 4. Create the output mosaic
    uniStudio4 = merge(uniStudio2, warpImg, warpCorner);
        
    % % Show the first merged image
    % subplot(2, 2, 1);
    % imshow(uniStudio1);
    % hold on;
    % plot(points1(:, 1), points1(:, 2), '*');
    % title('uniStudio1 with 7 manually identified points');
    % 
    % subplot(2, 2, 2);
    % imshow(uniStudio2);
    % hold on;
    % plot(estPoint(:, 1), estPoint(:, 2), '*');
    % title('uniStudio2 with 7 points mapped using H');
    % 
    % subplot(2, 2, 3);
    % imshow(warpImg);
    % title('warp of uniStudio1 using H');
    % 
    % subplot(2, 2, 4);
    % imshow(uniStudio4);
    % title('merged uniStudio using uniStudio2 and warp of uniStudio1');

    % Reads the thrid image to be warped
    uniStudio3 = imread('uniStudio3.jpeg');
    
    imshow(uniStudio3);
    hold on;
    points3 = ginput();
    imshow(uniStudio4);
    hold on;
    points4 = ginput();
    
    % % 8 manually identified points
    % points3 = [468.969055374593,414.558631921824;542.141693811075,...
    %     420.187296416938;630.793159609121,425.815960912052;...
    %     718.037459283388,432.851791530945;832.017915309446,...
    %     441.294788273616;945.998371335505,448.330618892508;...
    %     584.356677524430,617.190553745928;218.493485342019,719.913680781759];
    % points4 = [2915.92063492063,844.504761904762;2988.09206349206,...
    %     852.523809523810;3084.32063492064,857.869841269842;...
    %     3180.54920634921,868.561904761905;3316.87301587302,...
    %     876.580952380953;3453.19682539683,892.619047619048;...
    %     3014.82222222222,1058.34603174603;2672.67619047619,1133.19047619048];
    
    % Step 2. Computing the homography parameters
    H = computeHomography(points3, points4);
    
    % % check H by ploting the selected points1 on image2
    % [h, ~] = size(points3);
    % srcPoint = [points3.'; ones(1, h)];
    % dstPoint = H * srcPoint;
    % estPoint = [(dstPoint(1, :)./dstPoint(3, :)).'...
    %     (dstPoint(2, :)./dstPoint(3, :)).'];
        
    % Step 3. Warping between image planes 
    warpImg = createWarp(uniStudio3, H);
    
    % Corner points positions of the warp image 
    [h, w, ~] = size(uniStudio3);
    cornerPoint = [1 w 1 w; 1 1 h h; 1 1 1 1];
    dstCornerPoint = H * cornerPoint;
    
    warpCorner = [(dstCornerPoint(1, :)./dstCornerPoint(3, :)).'...
        (dstCornerPoint(2, :)./dstCornerPoint(3, :)).'];
    
    % Step 4. Create the output mosaic
    uniStudio = merge(uniStudio4, warpImg, warpCorner);
    
    % % Show the second merged image
    % subplot(2, 2, 1);
    % imshow(uniStudio3);
    % hold on;
    % plot(points1(:, 1), points1(:, 2), '*');
    % title('uniStudio3 with 8 manually identified points');
    % 
    % subplot(2, 2, 2);
    % imshow(uniStudio4);
    % hold on;
    % plot(estPoint(:, 1), estPoint(:, 2), '*');
    % title('previous merged uniStudio with 8 points mapped using H');
    % 
    % subplot(2, 2, 3);
    % imshow(warpImg);
    % title('warp of uniStudio3 using H');
    % 
    % subplot(2, 2, 4);
    % imshow(uniStudio);
    % title('newly merged uniStudio using previous merged uniStudio and warp of uniStudio3');

% PART 1.3 Warp one image into a ?frame? region in the second image. 
    utFootball = imread('utFootball.jpg');
    pokemon = imread('pokemon.jpg');

    % Step 1. Getting correspondences: choose at least 4 matches
    The matching points must be chosen in the same order
    imshow(pokemon);
    hold on;
    points1 = ginput();
    imshow(utFootball);
    hold on;
    points2 = ginput();

    % % 5 manually identified points
    % [h, w, ~] = size(pokemon);
    % points1 = [1, 1; 1, h; w, 1; w, h];
    % points2 = [232.268953068592,220.686522262335;97.4915764139592,...
    %     317.918772563177;604.832129963899,221.649217809868;...
    %     738.646811070999,327.545728038508];

    % Step 2. Computing the homography parameters
    H = computeHomography(points1, points2);

    % % check H by ploting the selected points1 on image2
    % [h, ~] = size(points1);
    % srcPoint = [points1.'; ones(1, h)];
    % dstPoint = H * srcPoint;
    % estPoint = [(dstPoint(1, :)./dstPoint(3, :)).'...
    %     (dstPoint(2, :)./dstPoint(3, :)).'];

    % Step 3. Warping between image planes 
    warpImg = createWarp(pokemon, H);

    % Corner points positions of the warp image 
    [h, w, ~] = size(pokemon);
    cornerPoint = [1 w 1 w; 1 1 h h; 1 1 1 1];
    dstCornerPoint = H * cornerPoint;

    warpCorner = [(dstCornerPoint(1, :)./dstCornerPoint(3, :)).'...
        (dstCornerPoint(2, :)./dstCornerPoint(3, :)).'];

    % Step 4. Create the output mosaic
    newFootball = merge(utFootball, warpImg, warpCorner);
    
    % % Show the images
    % subplot(2, 2, 1);
    % imshow(pokemon);
    % hold on;
    % plot(points1(:, 1), points1(:, 2), '*');
    % title('pokemon with 4 corner points');
    % 
    % subplot(2, 2, 2);
    % imshow(utFootball);
    % hold on;
    % plot(estPoint(:, 1), estPoint(:, 2), '*');
    % title('utFootball with 4 points mapped using H');
    % 
    % subplot(2, 2, 3);
    % imshow(warpImg);
    % title('warp of pokemon using H');
    % 
    % subplot(2, 2, 4);
    % imshow(newFootball);
    % title('merged utFootball using utFootballo and warp of pokemon');

% EXTRA CREDIT 1 Use VLFeat
    run('vlfeat-0.9.21/toolbox/vl_setup')

    uttower1 = imread('uttower1.JPG');
    uttower2 = imread('uttower2.JPG');

    uttower1_sift = single(rgb2gray(uttower1));
    uttower2_sift = single(rgb2gray(uttower2));

    [fa, da] = vl_sift(uttower1_sift) ;
    [fb, db] = vl_sift(uttower2_sift) ;
    [matches, scores] = vl_ubcmatch(da, db, 50) ;

    points1 = fa(1:2, matches(1, :)).';
    points2 = fb(1:2, matches(2, :)).';

    % Step 2. Computing the homography parameters
    H = computeHomography(points1, points2);

    % check H by ploting the selected points1 on image2
    % [h, ~] = size(points1);
    % srcPoint = [points1.'; ones(1, h)];
    % dstPoint = H * srcPoint;
    % estPoint = [(dstPoint(1, :)./dstPoint(3, :)).'...
    %     (dstPoint(2, :)./dstPoint(3, :)).'];
    
    % Step 3. Warping between image planes 
    warpImg = createWarp(uttower1, H);

    % Corner points positions of the warp image 
    [h, w, ~] = size(uttower1);
    cornerPoint = [1 w 1 w; 1 1 h h; 1 1 1 1];
    dstCornerPoint = H * cornerPoint;

    warpCorner = [(dstCornerPoint(1, :)./dstCornerPoint(3, :)).'...
        (dstCornerPoint(2, :)./dstCornerPoint(3, :)).'];

    % Step 4. Create the output mosaic
    uttower = merge(uttower2, warpImg, warpCorner);

    % % Show the images
    % subplot(2, 2, [1, 2]);
    % imagesc(cat(2, uttower1, uttower2)) ;
    % 
    % xa = fa(1,matches(1,:)) ;
    % xb = fb(1,matches(2,:)) + size(uttower1_sift,2) ;
    % ya = fa(2,matches(1,:)) ;
    % yb = fb(2,matches(2,:)) ;
    % 
    % hold on;
    % h = line([xa ; xb], [ya ; yb]) ;
    % set(h,'linewidth', 1, 'color', 'b') ;
    % 
    % vl_plotframe(fa(:,matches(1,:))) ;
    % fb(1,:) = fb(1,:) + size(uttower1_sift,2) ;
    % vl_plotframe(fb(:,matches(2,:))) ;
    % 
    % axis image off ;
    % 
    % title('uttower1 and uttower2 with 15 SIFT matching pairs');
    % 
    % subplot(2, 2, 3);
    % imshow(warpImg);
    % title('warp of uttower1 using H');
    % 
    % subplot(2, 2, 4);
    % imshow(uttower);
    % title('merged uttower using uttower2 and warp of uttower1');


% EXTRA CREDIT 3 Rectify an image with a known planar surface
    painting = imread('sidePainting.jpg');

    % Step 1. Getting correspondences: choose at least 4 matches
    % The matching points must be chosen in the same order
    imshow(painting);
    hold on;
    points1 = ginput();

    % % 5 manually identified points
    % points1 = [12.0745296671491,207.446454413893;214.679450072359,...
    %     22.2076700434154;23.6519536903039,586.028219971057;...
    %     238.992040520984,774.740231548480];
    % points2 = [1 1; 1000 1; 1 751; 1000 751 ];

    % Step 2. Computing the homography parameters
    H = computeHomography(points1, points2);

    % % check H by ploting the selected points1 on image2
    % [h, ~] = size(points1);
    % srcPoint = [points1.'; ones(1, h)];
    % dstPoint = H * srcPoint;
    % estPoint = [(dstPoint(1, :)./dstPoint(3, :)).'...
    %     (dstPoint(2, :)./dstPoint(3, :)).'];

    % Step 3. Warping between image planes 
    newImg = createWarp(painting, H);

    % % Show the images
    % subplot(2, 2, 1);
    % imshow(painting);
    % title('side view of painting');
    %
    % subplot(2, 2, [2, 4]);
    % imshow(warpImg);
    % title('front view of painting');
    %
    % subplot(2, 2, 3);
    % imshow(imread('actual.jpg'));
    % title('actual painting');