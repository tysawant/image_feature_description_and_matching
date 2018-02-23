function [newimg,rgbimg] = HarrisCorner(img,win,alpha,thr)
rgbimg = img; img = double(rgb2gray(img)); dim = size(img);
newimg = zeros(dim); halfwin = floor(win/2);
rst = halfwin+1; cst = halfwin+1;
ren = dim(1)-halfwin; cen = dim(2)-halfwin;
for i = rst:ren
    for j = cst:cen
        xxder = 0; yyder = 0; xyder = 0;
        for m = -halfwin:halfwin
            for n = -halfwin:halfwin
                if i+m+1 > dim(1)
                    xnextpix = 0;
                else
                    xnextpix = img(i+m+1,j+n);
                end
                if j+n+1 > dim(2)
                    ynextpix = 0;
                else
                    ynextpix = img(i+m,j+n+1);
                end
                dx = xnextpix-img(i+m,j+n);
                dy = ynextpix-img(i+m,j+n);
                xxder = xxder+(dx*dx);
                yyder = yyder+(dy*dy);
                xyder = xyder+(dx*dy);
            end
        end
        cmat = [xxder,xyder;xyder,yyder];
        r = det(cmat)-(alpha*(trace(cmat)^2));
        if r > thr
            newimg(i,j) = r;
        end
    end
end
newimg = NonMaxSuppress(newimg,win);
for i = rst+1:ren-1
    for j = cst+1:cen-1
        if(newimg(i,j) > 0)
            rgbimg(i,j,:) = [255;0;0];
            rgbimg(i+1,j,:) = [255;0;0];
            rgbimg(i,j+1,:) = [255;0;0];
            rgbimg(i+1,j+1,:) = [255;0;0];
            rgbimg(i,j-1,:) = [255;0;0];
            rgbimg(i-1,j,:) = [255;0;0];
            rgbimg(i-1,j-1,:) = [255;0;0];
            rgbimg(i+1,j-1,:) = [255;0;0];
            rgbimg(i-1,j+1,:) = [255;0;0];
        end
    end
end
end