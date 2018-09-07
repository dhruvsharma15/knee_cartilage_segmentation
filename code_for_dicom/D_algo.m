d='../../knee_data/03370000/coronal';
files=dir(d);
files(1)=[];
files(1)=[];
out_path='../../D/final/03370000-coronal';
for count=1:length(files)
    complete=fullfile(d,files(count).name);
    D_Script(complete,out_path);
end;