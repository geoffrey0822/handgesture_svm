function [feature,rfeat]=extract_gaborFeature(x,N)
x=rgb2gray(x);
x=im2uint8(x);
% img=loadimg('./dataset7/geoffrey/P000_L00_FRONT/0.png',N);
stage=4;
orientation=6;
freq=[0.05 0.4 2 4];
j=sqrt(-1);

for s=1:stage,
    for n=1:orientation,
        [magR,freqR]=gabor_o(N,[s n],freq,[stage orientation],0);
        F=fft2(magR+j*freqR);
        F(1,1)=0;
        GW(N*(s-1)+1:N*s,N*(n-1)+1:N*n)=F;
    end;
end;

w=N/9;
h=N/9;

w_mid=N/2;
h_mid=N/2;

A=zeros(stage*orientation*2,h*w);
for hx=1:h
    for wx=1:w
%         [1 hx wx]
        fx=(wx-1)*w_mid+1;
        tx=(wx-1)*w_mid+N;
        fy=(hx-1)*h_mid+1;
        ty=(hx-1)*h_mid+N;
%         disp(sprintf('%d,%d,%d,%d',fx,tx,fy,ty));
%         disp(size(img));
        imgf=x(fy:ty,fx:tx);
        F=Fea_Gabor_brodatz(imgf,GW,N,stage,orientation,N);
        A(:,(hx-1)*w+wx)=[F(:,1); F(:,2)];
    end
end
rfeat=A;
A=reshape(A,1,numel(A));
feature=A;