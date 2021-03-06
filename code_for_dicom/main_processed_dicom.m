% main function ll work for both RGB and grey scale image
%roi1 = imread('../../data/2.png');%actual img
function mask=main_processed_dicom(file)

%file='/media/naditya/data2/knee_mri/dhruv/Project/10142439ws.dcm';
[path,name,ext]=fileparts(file);
roi1 = dicomread(file);%actual img

%roi = imread('../../data/7_n.png');%Inverted img
roi = 490-roi1; %???inverting the image colors???
oname=fullfile('../../MSLT_Results',strcat(name,'results.png'));
close all;


up=90;
down=90;
left=90;
right=90;

I=roi;
%I=roi(up:size(roi,1)-down-1,left:size(roi,2)-right-1);% original image is clipped from borders (50-20 pixels) into a2 itself
II=roi1;
%II=roi1(up:size(roi1,1)-down-1,left:size(roi1,2)-right-1);% original image is clipped from borders (50-20 pixels) into a2 itself
Bmask=II>50; %imshow(Bmask)
%imshow(Bmask, [])
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
%h = fspecial('gaussian', [12 12], 1);
%I=imfilter(I,h);


[GC,ATW,ATG,Vs,ATW2,VsM,dilateEdge] = FnTrackInit8_dicom(I,1,1);

% change the value of T(threhold) decrease or increase in FnTrack21() function for more or less edges
 
[LT Final A B C D E]  = FnTrack21(GC,VsM,dilateEdge);

%imshow(LT, [])
%I1 = edge(rgb2gray(I),'canny');

nhood1=ones(2);
se0=strel(nhood1);
%se1=strel(nhood1);
se1=strel('disk',1);

%nhood2=ones(1);
%se2=strel(nhood2);
se2=strel('disk',1);

LT=imerode(LT,se1);
%imshow(LT)
%LT=imdilate(LT,se2);
%LT=imdilate(LT,se0);
%imshow(LT)
LT=ccbasedth(LT,255);
%figure
%imshow(LT);title('Detected')
%LT1=ccbasedth(I1,50);

IIc=II;
% IIc(:,:,1)=II;
% IIc(:,:,2)=II;
% IIc(:,:,3)=II;


h1=figure;
hold on;
subplot(2,2,1);imshow(IIc,[]);title('Original Image')
subplot(2,2,2);imshow(I);title('Inverted Image')
subplot(2,2,3);imshow (LT);title('Detected Region')


%b=rgb2gray(I).*uint8(LT);
%LTc=~LT;

LTc=LT.*Bmask;

LTc=ccbasedth(LTc,255);
LTc=~LTc;

%LTc=zeros(size(LT));
%size(LT)

% LTc(:,:,1)=ones(size(LT));
% LTc(:,:,2)=~LT().*Bmask;
% LTc(:,:,3)=ones(size(LT));

pngImg=dcm2png(II);
%pngImg=pngImg(up:size(pngImg,1)-down-1,left:size(pngImg,2)-right-1);

b(:,:,2)=pngImg;
b(:,:,1)=pngImg.*uint8(LTc);
b(:,:,3)=pngImg;

mask=~LTc;

%bfinal=b.*uint8(Bmask);
% size(I)
% size(LTc)
% size(II)
% size(b)

subplot(2,2,4);imshow (b);title('Overlayed on Original')

Resultados='../../MSLT_Results';
baseFileName = sprintf(strcat(name,'MSLT.png')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
img=gray2rgb(LT*255);
%imwrite(img, fullFileName);

%{
baseFileName = sprintf(strcat(name,'.png')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
imwrite(pngImg, fullFileName);

inverted= uint8(255 * mat2gray(I));
baseFileName = sprintf(strcat(name,'inv.png')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
imwrite(inverted, fullFileName);

baseFileName = sprintf(strcat(name,'overlayed.png')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
imwrite(b, fullFileName);
%}

hold off;
ROI=getframe(gca);
saveas(h1,oname);
%figure;
%imshow (LT1);

