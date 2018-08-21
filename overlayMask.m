function y=overlayMask(x,mask)

BW2=bwperim(mask,18);
red=x(:,:,1);
green=x(:,:,2);
blue=x(:,:,3);
red(BW2)=255;
green(BW2)=255;
blue(BW2)=255;
y=cat(3,red,green,blue);

end