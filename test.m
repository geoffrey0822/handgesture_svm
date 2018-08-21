clear('cam');
cam=webcam(1);
%preview(cam);
 for idx=1:100
     image=snapshot(cam);
     imshow(image);
 end
clear('cam');