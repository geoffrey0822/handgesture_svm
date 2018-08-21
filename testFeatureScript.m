clear all;
close all;
img=imread('./poses/hand1/images/resized/pose1/vout_06132016193539_8.jpg');
[areas,vis]=getCustomFeature(rgb2gray(img));
figure;
% imshow(img);
% hold on;
% plot(areas,'showPixelList',true,'showEllipses',false);
imshow(vis);