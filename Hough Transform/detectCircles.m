function [centers] = detectCircles(im, radius)
    % im - a h * w * 3 RGB image
    % radiu - the radius of the circles to detect

    grayIm = rgb2gray(im);
    edges = edge(grayIm, 'Canny', 0.3, 4);
    [h, w] = size(edges);
    H = zeros(h, w);
    for x = 1 : h
        for y = 1 : w
            if edges(x, y)      % for every edge pixel (x, y)
                for theta = -pi : 0.2: pi
                    a = round(x + radius * cos(theta));
                    b = round(y - radius * sin(theta));
                    % bin size = 9
                    r = fix(a/9) * 9 + 4;
                    c = fix(b/9) * 9 + 4;
                    if (r > 0 && r <= h && c > 0 && c <= w)
                        H(r, c) = H(r, c) + 1;
                    end
                end
            end
        end
    end

    % record centers
    [i, j] = find(H > 430);
    centers = [j, i];
end

