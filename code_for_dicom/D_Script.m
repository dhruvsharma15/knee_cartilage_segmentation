%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define folder D in the irt folder
%convert main_processed_dicom.m to a function
%define folder D in the project folder
%conver irtBinarize.m fuseMasks.m seg_ws.m to function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function D_Script(file,out_path)

file='../../knee_data/03370000/coronal/10116253';
[path,name,ext]=fileparts(file);

%read the dicom
img=dicomread(file);

%apply water shed segmentation
ws_path=seg_ws(file);

%overlay ws_mask over original dcm
new_dcm=maskOverDCM(file,ws_path);

%dcm to png conversion
new_png=dcm2png(new_dcm);

png_path='../../../raytransform/pyirt-1.0/pyirt/D/';
imwrite(new_png,fullfile(png_path,sprintf(strcat(name,('wsOverlayed.png')))));

%running commands on terminal
command=strcat('cd ../../../raytransform/pyirt-1.0/pyirt/D/irt ; ',strcat(' python run_irt.py -p params1.csv ../',strcat(name,('wsOverlayed.png'))));
system(command)
%D/',strcat(name,('wsOverlayed.png'))));
%[status, cmdout]=system('mkdir dhruv');


%binarising the irt result
irt_result=fullfile('../../../raytransform/pyirt-1.0/pyirt/',strcat(name,('wsOverlayedirt.png')));
mask1=irtBinarize(irt_result);
mask1_path='../../D';
imwrite(mask1,fullfile(mask1_path,strcat(name,('wsOverlayedirtmask.png'))));
%{
figure
hold on;
imshow(mask1);title('irt')
hold off;
%}

%overlay ws_mask over original dcm
Resultados='../../D';
%baseFileName = sprintf(strcat(name,'ws.dcm')); % e.g. "1.png"
baseFileName = sprintf(strcat(name,'wsoverlayed.dcm')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
dicomwrite(new_dcm, fullFileName);

%apply MSLT over new new_dcm
mslt_mask=main_processed_dicom(fullFileName);
Resultados='../../D';
baseFileName = sprintf(strcat(name,'wsMSLTmask.png')); % e.g. "1.png"
fullFileName2 = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
imwrite(mslt_mask, fullFileName2);

%fuse the two masks over original 
final=fuseMasks(file, mask1, mslt_mask);
Resultados='../../D/final';
baseFileName = sprintf(strcat(name,'final.png')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
%img=gray2rgb(LT*255);
%imwrite(final, fullFileName);


%fullFileName = fullfile(out_path, baseFileName);

h1=figure;
hold on;
subplot(2,3,1);imshow(img,[]);title('Original Image')
subplot(2,3,2);imshow(final);title('Final Image')
subplot(2,3,3);imshow(mask1*255);title('irt mask')
subplot(2,3,4);imshow(mslt_mask*255);title('mslt mask')
subplot(2,3,5);imshow(new_png);title('watershed result')
hold off;
saveas(h1,fullFileName);





