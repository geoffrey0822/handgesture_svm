function y=intensityNormalize(x,u)
%     tx=rgb2ycbcr(x);
    y=lab2uint8(rgb2lab(x));
%     y(:,:,1)=tx(:,:,1);
%     y(:,:,2)=tx(:,:,2);
%     y(:,:,3)=tx(:,:,3);
%     y(:,:,1)=histeq(tx(:,:,1));
%     y(:,:,2)=histeq(tx(:,:,2));
%     y(:,:,3)=histeq(tx(:,:,3));
%     y=histeq(x,imhist(u));
end