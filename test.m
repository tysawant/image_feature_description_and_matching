image1 = imread('data/Notre Dame/921919841_a30df938f2_o.jpg');
image2 = imread('data/Notre Dame/4191453057_c86028ce1f_o.jpg');
eval_file = 'data/Notre Dame/921919841_a30df938f2_o_to_4191453057_c86028ce1f_o.mat';

% %This pair is relatively easy (still harder than Notre Dame, though)
% image1 = imread('../data/Mount Rushmore/9021235130_7c2acd9554_o.jpg');
% image2 = imread('../data/Mount Rushmore/9318872612_a255c874fb_o.jpg');
% eval_file = '../data/Mount Rushmore/9021235130_7c2acd9554_o_to_9318872612_a255c874fb_o.mat';

% %This pair is relatively difficult
% image1 = imread('../data/Episcopal Gaudi/4386465943_8cf9776378_o.jpg');
% image2 = imread('../data/Episcopal Gaudi/3743214471_1b5bbfda98_o.jpg');
% eval_file = '../data/Episcopal Gaudi/4386465943_8cf9776378_o_to_3743214471_1b5bbfda98_o.mat';

image1 = single(image1)/255;
image2 = single(image2)/255;

%make images smaller to speed up the algorithm. This parameter gets passed
%into the evaluation code so don't resize the images except by changing
%this parameter.
scale_factor = 0.5; 
image1 = imresize(image1, scale_factor, 'bilinear');
image2 = imresize(image2, scale_factor, 'bilinear');

% You don't have to work with grayscale images. Matching with color
% information might be helpful.
image1_bw = rgb2gray(image1);
image2_bw = rgb2gray(image2);

feature_width = 16; %width and height of each local feature, in pixels. 
alpha = 0.04;
rows = size(image1_bw, 1);
columns = size(image1_bw, 2);
g = fspecial('gaussian');
gderx = conv2(g,[1 0 -1]);
gdery = conv2(g,[1 0 -1]');
ix = imfilter(image1_bw,gderx);
iy = imfilter(image1_bw,gdery);
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
        if f(i,j)>0.001
        fnorm(i,j)= f(i,j)/f(i,j);
        c = c+1;
        else
            fnorm(i,j) = 0;
        end
    end
end
imshow(fnorm)
P = padarray(fnorm,[8 8],0);
[x,y] = find(P);
figure();
imshow(image1_bw)
hold on
plot(y, x, 'gs')
title('Harris corner points')
P1 = padarray(image1_bw,[8 8],0);
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
              %{
              for e = 1:4
                  for f = 1:4
                      if 0< M(c,d)<=pi/4
                      M(c,d) = pi/4;
                      elseif pi/4< M(c,d)<=pi/2
                      M(c,d) = pi/2;
                      elseif pi/2< M(c,d)<=3*pi/4
                      M(c,d) = 3*pi/4;
                      elseif 3*pi/4< M(c,d)<=pi
                      M(c,d) = pi;
                      elseif -pi< M(c,d)<=-3*pi/4
                      M(c,d) = -3*pi/4;
                      elseif -3*pi/4< M(c,d)<=-pi/2
                      M(c,d) = - pi/2;
                      elseif -pi/2< M(c,d)<=-pi/4
                      M(c,d) = -pi/4;
                      elseif -pi/4< M(c,d)<= 0
                      M(c,d) = 0; 
                      end
                  end
              end
              %}
            end
        end
     end
      % C_mat = cell2mat(C);
       %C_vect = reshape(C_mat,[1,128]);
       features = [features; F];
       F =[];
    end
     
end
