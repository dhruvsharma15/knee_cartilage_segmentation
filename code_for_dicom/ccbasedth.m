function [outG outB] = ccbasedth(img,th)
%th is proportional to the size(no of pixel scaled to [0-255]) of the connected component;
CC = bwconncomp(img);
numPixels = cellfun(@numel,CC.PixelIdxList);
label = labelmatrix(CC);

[h w] = size(img);
pixelc=zeros(h,w); 
for r=1:h
    for c=1:w
        if(label(r,c))
           pixelc(r,c) = numPixels(label(r,c));
        else
            
    end
end

maxC=max(max(pixelc));
NpixelC=pixelc/maxC*255;
outG=uint8(NpixelC)>=th;
outB1=uint8(NpixelC)<th;
outB2=uint8(NpixelC)>0.00001;
outB=and(outB1,outB2);
%imshow(out);
end
