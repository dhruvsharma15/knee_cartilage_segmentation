function img8=dcm2png(X)
%file='/media/naditya/data2/knee_mri/dhruv/Project/knee_data/06580000/coronal/10142439';
%[pathstr,name,ext] = fileparts(file); %file is the path of the dicom file to be converted
img8 = uint8(255 * mat2gray(X));
%{
result=strcat(pathstr,'/png');
mkdir(result);
path=fullfile(result,strcat(name,'.png'));
imwrite(img8,path, 'png');
imshow(img8);
%}
