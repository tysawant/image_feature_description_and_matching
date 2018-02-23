% Local Feature Stencil Code
% Written by James Hays for CS 4476/6476 @ Georgia Tech

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width)

P1 = padarray(image,[8 8],0);
F =[];
features =[];
edges = [-pi -3*pi/4 -pi/2 -pi/4 0 pi/4 pi/2 3*pi/4 pi];

for a = 1:size(x)
    for b = 1:size(y)
    if a == b  
        window = P1((x(a)-7):(x(a)+8),(y(b)-7):(y(b)+8));
        xgrad = imfilter(window,[-1 0 1]);
        ygrad = imfilter(window,[-1 0 1]');
        ori = atan2(ygrad,xgrad);
        C = mat2cell(ori, [4 4 4 4],[4 4 4 4]);    
        for d = 1:4
            for e = 1:4
              M = C{d,e};
              Mg = imgaussfilt(M);
              N = histcounts(Mg,edges);
              F = [F,N];
            end
        end
    end
    features = [features; F];
    F =[];
    end     
end
end








