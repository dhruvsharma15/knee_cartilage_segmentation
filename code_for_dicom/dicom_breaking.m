
info = dicominfo('10097990');
nRows = info.Rows;
nCols = info.Columns;
nPlanes = info.SamplesPerPixel;

X=repmat(uint16(0), [nRows nCols nPlanes]);
filename = sprintf('10097990');
X(:,:,1) = dicomread(filename);

X_New=repmat(uint8(0), [nRows nCols 256]);
tic

biMat=de2bi(X,16);
lsbMat=biMat(:,1:8);
msbMat=biMat(:,9:16);

lsbMat=bi2de(lsbMat);
msbMat=bi2de(msbMat);

for j=1:nCols
    for i=1:nRows
        ind=uint32(j-1)*uint32(nRows) + uint32(i);
        for k=1:256
            if (k==msbMat(ind)+1)
                X_New(i,j,msbMat(ind)+1)=lsbMat(ind);
            end
        end
    end
end

Resultados='E:\summers_2016\Project\knee_dicom_data\16031414\10097990';
mkdir(Resultados);
for i=1:256
    baseFileName = sprintf('test_image%d.png', i); % e.g. "1.png"
    fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
    I=gray2rgb(X_New(:,:,i));
    imwrite(I, fullFileName);
end

toc


