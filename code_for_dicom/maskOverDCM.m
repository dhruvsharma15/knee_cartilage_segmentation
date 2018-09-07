function conv=maskOverDCM(dcm_file, mask_file)
%dcm_file='/media/naditya/data2/knee_mri/dhruv/Project/Best_data/10142454';
%dcm_file='/media/naditya/data2/knee_mri/dhruv/Project/WSoverlayed/10142439ws.dcm';
%ws_file='/media/naditya/data2/knee_mri/dhruv/Project/WaterShed/10142454ws.png';
%mask_file='/media/naditya/data2/knee_mri/dhruv/Project/MSLT_Results/10142454MSLT.png';

[path, name, ext]=fileparts(dcm_file);
dcmImg=dicomread(dcm_file);

up=90;
down=90;
left=90;
right=90;

dcmImg=dcmImg(up:size(dcmImg,1)-down-1,left:size(dcmImg,2)-right-1);

wsImg=imread(mask_file);
wsImg=uint16(wsImg);

conv=dcmImg.*wsImg(:,:,2);

Resultados='../..';
%baseFileName = sprintf(strcat(name,'ws.dcm')); % e.g. "1.png"
baseFileName = sprintf(strcat(name,'MSLToverlayed.dcm')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
%dicomwrite(conv, fullFileName);
%figure
%imshow(dcmImg,[]);title('original')
%imshow(conv,[]);title('overlayed')

img8 = uint8(255 * mat2gray(conv));
baseFileName = sprintf(strcat(name,'MSLToverlayed.png')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
%imwrite(img8, fullFileName);
