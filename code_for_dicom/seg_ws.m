function ws_path=seg_ws(file);
%clc;close all;clear all;
%img = (dicomread('D:\IITSummerProject\knee mr data\03370000\10098810')); % axial view
%img = (dicomread('D:\IITSummerProject\knee mr data\03370000\10116285'));
%img = dicomread('/home/tuhin/Documents/IITSummerProject/knee mr data - Copy/03370000/coronal/New folder/10116301');% coronal view
%img = imread('/home/tuhin/Documents/IITSummerProject/Results_IRT3-JPG/6_cresult(params1).png')

%img = imread('/home/tuhin/Documents/IITSummerProject/Results-MSLT for dcm/10142439.png')

%roi = dicomread('/media/naditya/data2/knee_mri/dhruv/Project/Best_data/10142439');

%file='/media/naditya/data2/knee_mri/dhruv/Project/Best_data/10142454';
[path,name,ext]=fileparts(file);
roi = dicomread(file);

up=90;
down=90;
left=90;
right=90;

%I=roi;
img=roi(up:size(roi,1)-down-1,left:size(roi,2)-right-1);% original image is clipped from borders (50-20 pixels) into a2 itself


%img2 = imread('D:\IITSummerProject\knee mr data - Copy\03370000\coronal\New folder\1st.jpg');

%img2 = imcrop(img);
%img2 = imcrop(img,[0 0 1280 960]); %cropping out the label in original image
%img2 = imcrop(img, [135 175 325 325]);

%lines=edge(img2);

%imshow(img2);
I1 = imtophat(img, strel('disk',5));     %morphological tranformation via disks to extract the cells
%I1=img;
%figure,imshow(I1);
I2 = imadjust(I1);                         %adjusts the contrast and visibility
%I2=I1;
%figure,imshow(I2);
level = graythresh(I2)                    %computing global threshold(Otsu's method)
bw = im2bw(I2,level);                      %converting to bw based on intensity of binarization

%figure,imshow(bw,[]);title('watershed')   

Resultados='../../WaterShed';
baseFileName = sprintf(strcat(name,'ws.png')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
img=gray2rgb(bw);
imwrite(img, fullFileName);

ws_path=fullFileName;

%imfreehand
%stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength')
count = edge(bw,'canny');
%figure,imshow(count);
c = ~bw;                                   %negative of image
%figure,imshow(c);

% d = -bwdist(c);                            %computing distance transform on binary image
% d(c) = -Inf;
% L = watershed(d);
% figure,imshow(L);                          %returns the label matrix watershed segmentation
% lrgb = label2rgb(L,'hot','w');             %converting the label matrix to rgb color format image
% figure,imshow(lrgb);

%lines = edge(bw,'canny',127);


% I = img2;
% I(L==0)=0;                                 
% figure,imshow(I);

