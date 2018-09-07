%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define folder A in the irt folder
%move main_processed.m in the working folder
%convert it to a function
%define folder A in the project folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


file='/media/naditya/data2/knee_mri/dhruv/Project/Best_data/10142439';
[path,name,ext]=fileparts(file);

%read the dicom
img=dicomread(file);

%apply water shed segmentation
ws_path=seg_ws(file);

%overlay ws_mask over original dcm
new_dcm=maskOverDCM(file,ws_path);

%dcm to png conversion
new_png=dcm2png(new_dcm);
png_path='cd /media/naditya/data2/knee_mri/dhruv/raytransform/pyirt-1.0/pyirt/A';
imwrite(strcat(name,('wsOverlayed.png')),pngpath);

%running commands on terminal
system('cd /media/naditya/data2/knee_mri/dhruv/raytransform/pyirt-1.0/pyirt');
system(strcat('python run_irt.py A/',strcat(name,('wsOverlayed.png'))));

%running MSLT over the IRT results
irt_path=strcat('/media/naditya/data2/knee_mri/dhruv/raytransform/pyirt-1.0/pyirt/',strcat(name,'wsOverlayedirt.png'));
final=main_processed(irt_path);

%saving the final result
final_path=('/media/naditya/data2/knee_mri/dhruv/Project/A');
final_name=strcat(name,'result.png');
full_path=fullfile(final_path,final_name);
inwrite(final,full_path);







