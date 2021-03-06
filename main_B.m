% main function ll work for both RGB and grey scale image
clear all
roi1 = imread('E:\summers 2016\Project\code_dhruv\test\5_c.png');%actual img
%roi = imread('../../data/7_n.png');%Inverted img
roi = 255-roi1;
oname='E:\summers 2016\Project\code_dhruv\test\5_c_p.png';
close all;


up=220;
down=180;
left=300;
right=300;

I=roi;
I=roi(up:size(roi,1)-down,left:size(roi,2)-right);% original image is clipped from borders (50-20 pixels) into a2 itself
II=roi1;
II=roi1(up:size(roi1,1)-down,left:size(roi1,2)-right);% original image is clipped from borders (50-20 pixels) into a2 itself
Bmask=II>100; %imshow(Bmask)
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

imshow(LT, [])
%I1 = edge(rgb2gray(I),'canny');

nhood1=ones(2);
se0=strel(nhood1);
%se1=strel(nhood1);
se1=strel('disk',4);

%nhood2=ones(1);
%se2=strel(nhood2);
se2=strel('disk',2);

LT=imerode(LT,se1);
LT=imdilate(LT,se2);
LT=imdilate(LT,se0);

LT=ccbasedth(LT,255);
%LT1=ccbasedth(I1,50);

IIc=II;
%IIc(:,:,1)=II;
%IIc(:,:,2)=II;
%IIc(:,:,3)=II;


h1=figure;
hold on;
subplot(2,2,1);imshow(IIc);title('Original Image')
subplot(2,2,2);imshow(I);title('Inverted Image')
subplot(2,2,3);imshow (LT);title('Detected Region')

%b=rgb2gray(I).*uint8(LT);
%LTc=~LT;

LTc=LT.*Bmask;

LTc=ccbasedth(LTc,200);
LTc=~LTc;

%LTc=zeros(size(LT));
%size(LT)

% LTc(:,:,1)=ones(size(LT));
% LTc(:,:,2)=~LT().*Bmask;
% LTc(:,:,3)=ones(size(LT));


b(:,:,2)=IIc;
b(:,:,1)=IIc.*uint8(LTc);
b(:,:,3)=IIc;

%bfinal=b.*uint8(Bmask);
% size(I)
% size(LTc)
% size(II)
% size(b)

subplot(2,2,4);imshow (b);title('Overlayed on Original')
hold off;
ROI=getframe(gca);
saveas(h1,oname);
%figure;
%imshow (LT1);
