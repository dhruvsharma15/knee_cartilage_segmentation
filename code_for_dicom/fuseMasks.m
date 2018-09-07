function final=fuseMasks(file,mask1,mask2)
%mask1=imread('/media/naditya/data2/knee_mri/dhruv/Project/D/10142439wsOverlayedirtmask.png');
%mask2=imread('/media/naditya/data2/knee_mri/dhruv/Project/D/10142439wsMSLT.png');

%file='/media/naditya/data2/knee_mri/dhruv/Project/Best_data/10142439';
img=dicomread(file);

[path, name, ext]=fileparts(file);
up=90;
down=90;
left=90;
right=90;


Img=img(up:size(img,1)-down-1,left:size(img,2)-right-1);
Img=dcm2png(Img);
%Img=gray2rgb(Img);
mask=uint8(mask1) | (mask2(:,:,1)/255);

mask=~mask;
final(:,:,1)=Img;
final(:,:,2)=Img.*uint8(mask);
final(:,:,3)=Img;
%figure
%imshow(final);title('fused')

%Img(:,:,2)=Img(:,:,2).*uint8(mask);

