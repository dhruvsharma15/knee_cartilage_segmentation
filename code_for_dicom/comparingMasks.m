%function metric=comparingMasks(grndTruth,mask)
grndTruth=imread('E:\summers_2016\Project\masks\10142454mask.png');
grndTruth=grndTruth>0;
mask=imread('E:\summers_2016\Project\masks\10142454mask2.png');
mask=mask>0;
h=grndTruth - mask;
fp=(h==-1);
fp=sum(fp);
fp=sum(fp);
fp=fp(:,:,1);

fn=(h==1);
fn=sum(fn);
fn=sum(fn);
fn=fn(:,:,1);

grndTruth=sum(grndTruth);
grndTruth=sum(grndTruth);
totalPixels=grndTruth(:,:,1);


metric=(fp+fn)/totalPixels;
display(metric);
