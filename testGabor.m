function testGabor()
clear all;
close all;

img=imread('./dataset7/geoffrey/P005_L00_FRONT/0.png');
img2=imread('./dataset7/geoffrey/P005_L00_FRONT/2.png');

img=imresize(img,[227,227]);
img2=imresize(img2,[227,227]);

n=54;
maxDim=getN(img);
maxDim2=getN(img2);
[feat,rfeat]=extract_gaborFeature(img,n);
[feat2,rfeat2]=extract_gaborFeature(img2,n);
% disp(size(feat));
% disp(size(rfeat));
% imshow(feat);
dist=norm(feat'-feat2');
disp(dist);
figure;
imshow(rfeat);

figure;
imshow(rfeat2);
end
function n=getN(img)
n=round(sqrt(max(size(img))));
end