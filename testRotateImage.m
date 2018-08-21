close all;
h1=fspecial('gaussian',[15 15],10);
m_sfilter=fspecial('gaussian',[9 9],9);
m_filter={h1};
m_cform=makecform('srgb2lab');

input=imread('./poses/hand3/images/resized/pose1/vout_06132016195510_1.jpg');
outputs=rotateResample(input);
% [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
for i=1:size(outputs,2)
    figure;
    img=imgProc2(outputs{i},m_filter,m_sfilter,m_cform);
    imshow(img);
end
% imshow(outputs);