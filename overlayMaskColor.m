function y=overlayMaskColor(x,mask,r,g,b)

BW2=bwperim(mask,18);
red=x(:,:,1);
green=x(:,:,2);
blue=x(:,:,3);
red(BW2)=r;
green(BW2)=g;
blue(BW2)=b;
y=cat(3,red,green,blue);

end