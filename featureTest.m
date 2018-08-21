clear all;
close all;

img=imread('./poses/hand2/images/resized/pose3/vout_06132016195330_1170.jpg');
img2=imread('./poses/hand2/images/resized/pose3/vout_06132016195330_1175.jpg');

sample=rgb2gray(img);
sample2=rgb2gray(img2);

% feature=extractFeatures(sample,region,'Method','SURF');
% % [feature,~]=extractHOGFeatures(sample);
 feature1d=getUniformSURFFeature(sample,10);
 n=size(feature1d,2);
 disp(n);
 xAxis=1:1:n;
 imshow(img);
 figure;
 plot(feature1d);
% 
% [feature2,~]=extractFeatures(sample2,region,'Method','SURF');
% feature21d=feature2(:)';
% figure;
% imshow(img2);
% figure;
% plot(feature21d);