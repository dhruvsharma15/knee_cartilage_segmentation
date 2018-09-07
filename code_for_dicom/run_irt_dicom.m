file='../../knee_data/03370000/coronal/10116413';
[path, name, ext]=fileparts(file);
img=dicomread(file);

%apply water shed segmentation
ws_path=seg_ws(file);

%overlay ws_mask over original dcm
new_dcm=maskOverDCM(file,ws_path);

new_png=dcm2png(new_dcm);

png_path='../../../raytransform/pyirt-1.0/pyirt/D/';
imwrite(new_png,fullfile(png_path,sprintf(strcat(name,('wsOverlayed.png')))));
%running commands on terminal
command=strcat('cd ../../../raytransform/pyirt-1.0/pyirt/D/irt ; ',strcat(' python run_irt.py -p params1.csv ../',strcat(name,('wsOverlayed.png'))));
system(command)

irt_result=fullfile('../../../raytransform/pyirt-1.0/pyirt/',strcat(name,('wsOverlayedirt.png')));
figure
imshow(imread(irt_result));title('irt')

irt_binary=irtBinarize(irt_result);
figure
imshow(irt_binary);title('binary irt')