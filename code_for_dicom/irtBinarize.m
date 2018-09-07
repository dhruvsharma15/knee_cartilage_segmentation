function bw=irtBinarize(file);
%file = '/media/naditya/data2/knee_mri/dhruv/raytransform/pyirt-1.0/pyirt/10142439result.png';
[path,name,ext]=fileparts(file);

I=imread(file);
%figure
%imshow(I);title('original')
level=graythresh(I);
bw=im2bw(I,0.4);
%figure
%imshow(bw);title('irt binary')
%{
Resultados='/media/naditya/data2/knee_mri/dhruv/Project/D';
baseFileName = sprintf(strcat(name,'binary.png')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
%img=gray2rgb(LT*255);
imwrite(bw, fullFileName);

%}