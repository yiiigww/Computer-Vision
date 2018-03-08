coins = imread('coins.jpg');
planets = imread('planets.jpg');
circles = imread('circles.jpg');

% planets
planetsCenters = detectCircles(planets, 50);
[h, w] = size(planetsCenters);
radii = zeros(h, 1);
radii(:) = 50;
imshow(planets);
viscircles(planetsCenters,radii);
title('Planets - circles detected with radius 50');


%coins
[coinsCenters] = detectCircles(coins, 90);
[h, w] = size(coinsCenters);
radii = zeros(h, 1);
radii(:) = 93;
imshow(coins);
viscircles(coinsCenters,radii);
title('Coins - circles detected with radius 93');

% circles
circlesCenters = detectCircles(circles, 60);
[h, w] = size(circlesCenters);
radii = zeros(h, 1);
radii(:) = 60;
imshow(circles);
viscircles(circlesCenters,radii);
title('Circles - circles detected with radius 60');