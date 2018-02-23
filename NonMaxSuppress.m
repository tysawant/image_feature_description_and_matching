function [newimg] = NonMaxSuppress(img,win)
dim = size(img); newimg = zeros(size(img)); 
halfwin = floor(win/2);
rst = halfwin+1; cst = halfwin+1;
ren = dim(1)-halfwin; cen = dim(2)-halfwin;
for i = rst:ren
    for j = cst:cen
        maxflag = 1;
        for m = -halfwin:halfwin
            for n = -halfwin:halfwin
                if (img(i,j)==0) || (img(i+m,j+n) > img(i,j))
                    maxflag = 0;
                end
            end
        end
        if maxflag == 1
            newimg(i,j) = 255;
        end
    end
end
newimg = uint8(newimg);
end