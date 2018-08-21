function y=ImageSlideSampling(x,roisize,step)
mx=size(x,2);
my=size(x,1);
rx=roisize(2);
ry=roisize(1);
iy=1;
i=1;
while(iy+ry-1<=my)
    ix=1;
    while(ix+rx-1<=mx)
        y{i}=x(iy:iy+ry-1,ix:ix+rx-1,:);
        ix=ix+step(2);
    i=i+1;    
    end
    iy=iy+step(1);
end
end