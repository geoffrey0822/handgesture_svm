function y=combineWithMask(x,mask)
    y=im2double(x);
     y(:,:,1)=y(:,:,1).*mask;
     y(:,:,2)=y(:,:,2).*mask;
     y(:,:,3)=y(:,:,3).*mask;
     y=im2uint8(y);
end