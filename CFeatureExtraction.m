function y=CFeatureExtraction(x)
img(:,:,1)=x(:,:,3);
img(:,:,2)=x(:,:,2);
img(:,:,3)=x(:,:,1);
y=CustomFeatureExtration(img,1);
end