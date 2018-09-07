%function metric=comparingMasks(grndTruth,mask)
grndTruth=imread('mask.png');
mask=imread('mask2.png');
h=grndTruth - mask;
fp=(h==-1);
fp=sum(fp);
fp=sum(fp);
fp=fp(:,:,1);

fn=(h==1);
fn=sum(fn);
fn=sum(fn);
fn=fn(:,:,1);

info=imageinfo(mask);
ht=info.Height;
wd=info.Width;
totalPixels=ht*wd;

metric=(fp+fn)/totalPixels;
display(metric);
