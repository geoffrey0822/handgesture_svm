clear all;
close all;
img=imread('./poses/hand2/images/resized/pose3/vout_06132016195325_893.jpg');
output=CFeatureExtraction(img);
imshow(output.image);
figure;
imshow(output.edges);