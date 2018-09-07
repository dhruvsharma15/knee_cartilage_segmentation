function main(input,output)

roi1=imread(input);
roi = 255-roi1;;
% main function ll work for both RGB and grey scale image 

%roi1 = imread('a.png');
%roi = imread('b.png');


close all;

up=220;
down=180;
left=150;
right=150;

I=roi;
I=roi(up:size(roi,1)-down,left:size(roi,2)-right);% original image is clipped from borders (50-20 pixels) into a2 itself
II=roi1;
II=roi1(up:size(roi1,1)-down,left:size(roi1,2)-right);% original image is clipped from borders (50-20 pixels) into a2 itself

%th = graythresh(I);%otsu thresholding

%f=0.4;
%I = im2bw(I,th*f);
%imshow(I)

% if I = [MxNx4]
if(size(I,3)==4)
    I(:,:,4)=[]; % convert to I = [MxNx3]
end

% if I = [MxN]
if(size(I,3)    ==1)
    [I]=gray2rgb(I); % convert to I = [MxNx3]
%     figure;imshow(I);
end
%filter
h = fspecial('gaussian', [5 5], 1);
I=imfilter(I,h);

[GC,ATW,ATG,Vs,ATW2,VsM,dilateEdge] = FnTrackInit8(I,1);

% change the value of T(threhold) decrease or increase in FnTrack21() function for more or less edges
 
[LT Final A B C D E]  = FnTrack21(GC,VsM,dilateEdge);


%I1 = edge(rgb2gray(I),'canny');

nhood1=ones(2);
se0=strel(nhood1);
%se1=strel(nhood1);
se1=strel('disk',4);

%nhood2=ones(1);
%se2=strel(nhood2);
se2=strel('disk',1);

LT=imerode(LT,se1);
LT=imdilate(LT,se2);
LT=imdilate(LT,se0);

LT=ccbasedth(LT,250);
%LT1=ccbasedth(I1,50);

IIc(:,:,1)=II;
IIc(:,:,2)=II;
IIc(:,:,3)=II;



%b=rgb2gray(I).*uint8(LT);
LTc(:,:,1)=ones(size(LT));
LTc(:,:,2)=~LT;
LTc(:,:,3)=ones(size(LT));


b=IIc.*uint8(LTc);

size(I)
size(LTc)
size(II)
size(b)

%figure
%subplot(2,2,1);imshow(IIc);title('Original Image')
%subplot(2,2,2);imshow(I);title('Inverted Image')
%subplot(2,2,3);imshow (LT);title('Detected Region')
%subplot(2,2,4);imshow (b);title('Overlayed on Original')
imwrite(b,output)
%figure;
%imshow (LT1);