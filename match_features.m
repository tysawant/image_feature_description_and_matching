% Local Feature Stencil Code
% Written by James Hays for CS 4476/6476 @ Georgia Tech

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

dist_array =[];
matches = [];
confidences =[];
for g = 1:size(features1,1)
    for h = 1:size(features2,1)
     diff = features1(g,:) - features2(h,:);
     dist = sum(diff(:).^2);
     dist_array = [dist_array, dist];
    end
 [~, index] = min(dist_array);
 match = sort(dist_array);
 match1 = match(1);
 match2 = match(2);
 ratio = match1/match2;
 if ratio < 0.6
 matches = [matches;g index];
 confidences = [confidences; ratio];
 end
 dist_array=[];
end

% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);