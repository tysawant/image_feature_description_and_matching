% Local Feature Stencil Code
% Written by James Hays for CS 4476/6476 @ Georgia Tech

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

alpha = 0.04;
rows = size(image, 1);
columns = size(image, 2);
g = fspecial('gaussian');
gderx = conv2(g,[-1 0 1]);
gdery = conv2(g,[-1 0 1]');
ix = imfilter(image,gderx);
iy = imfilter(image,gdery);
ix2 = ix.^2;
iy2 = iy.^2;
ixiy = ix.*iy;
gIx2 = imgaussfilt(ix2);
gIy2 = imgaussfilt(iy2);
gIxIy = imgaussfilt(ixiy);
f = (gIx2.*gIy2) - (gIxIy.^2) - (alpha*((gIx2 + gIy2).^2));
fnorm = size(f);
c=0;
for i = 1:rows
    for j = 1:columns
        if f(i,j)>0.0001
        fnorm(i,j)= f(i,j)/f(i,j);
        c = c+1;
        else
            fnorm(i,j) = 0;
        end
    end
end
%figure();
%imshow(fnorm);
nms = fnorm > imdilate(fnorm, [1 1 1; 1 0 1; 1 1 1]);
P = padarray(nms,[8 8],0);
[x,y] = find(P);
figure();
imshow(image);
hold on;
plot(y, x, 'gx');
title('Harris corner points');
end

