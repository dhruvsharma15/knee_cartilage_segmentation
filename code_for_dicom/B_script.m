%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define folder B in the irt folder
%convert main_processed_dicom.m to a function
%define folder B in the project folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


file='/media/naditya/data2/knee_mri/dhruv/Project/Best_data/10142439';
[path,name,ext]=fileparts(file);

%read the dicom
img=dicomread(file);

%apply water shed segmentation
ws_path=seg_ws(file);

%overlay ws_mask over original dcm
new_dcm=maskOverDCM(file,ws_path);
Resultados='/media/naditya/data2/knee_mri/dhruv/Project/B';
%baseFileName = sprintf(strcat(name,'ws.dcm')); % e.g. "1.png"
baseFileName = sprintf(strcat(name,'wsoverlayed.dcm')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
dicomwrite(new_dcm, fullFileName);

%apply MSLT over new new_dcm
mslt_mask=main_processed_dicom(fullFileName);
Resultados='/media/naditya/data2/knee_mri/dhruv/Project/B';
baseFileName = sprintf(strcat(name,'wsMSLTmask.png')); % e.g. "1.png"
fullFileName2 = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
imwrite(mslt_mask, fullFileName2);

%overlay the  MSLT mask over new_dcm 
new_dcm2=maskOverDCM(fullFileName,fullFileName2);

%dcm to png conversion
png=dcm2png(new_dcm2);
png_path='cd /media/naditya/data2/knee_mri/dhruv/raytransform/pyirt-1.0/pyirt/B';
imwrite(strcat(name,('wsMSLTOverlayed.png')),pngpath);

%running commands on terminal
system('cd /media/naditya/data2/knee_mri/dhruv/raytransform/pyirt-1.0/pyirt');
system(strcat('python run_irt.py B/',strcat(name,('wsMSLTOverlayed.png'))));
