function output=getUniformSURFFeature(input,scale)
global surfregion surfSize;
nsize=200/scale;
if surfSize~=scale
    disp('compute surf region 2');
    surfregion=[];
    surfSize=scale;
    i=1;
    ix=1;
    iy=1;
    for y=1:nsize
        ix=1;
        for x=1:nsize
            surfregion(i,1)=ix;
            surfregion(i,2)=iy;
            i=i+1;
            ix=ix+scale;
        end
        iy=iy+scale;
    end
end
feature=extractFeatures(input,surfregion,'Method','SURF');
output=feature(:)';
end