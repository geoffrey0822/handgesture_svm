function y=imgPreprocessing(raw)

    [maskk,~]=segmentImageGray(raw);
    raw=combineWithMask(raw,maskk);

    colorSpace=makecform('srgb2lab');
    h1=fspecial('gaussian',[15 15],10);
    filters={h1};
    smoothFilter=fspecial('gaussian',[9 9],9);

    ty=applycform(raw,colorSpace);
        %% Workable Setting
    mask=segmentationRange(ty,[0 133 120],[255 255 255]);
%%  Region Extracted
    guide=imfilter(raw,smoothFilter,'conv');
    mask2=imfilter(mask,filters{1},'conv');
    mask3=imguidedfilter(mask2,guide,'NeighborhoodSize',[3 3]);
    segment=combineWithMask(ty,mask3);
    %% Workable Setting
    mask=imfilter(segmentationRange(segment,[0 80 130],[255 255 255]),smoothFilter,'conv');

%     segment=combineWithMask(raw,mask);
%     segment2=combineWithMask(raw,mask); 

%     BW=edge(rgb2gray(segment2),'Canny',.02);
%     BWShape=rangefilt(mask2);

%% Original
      regionMask=bwareafilt(mask,1);
      regionImg=combineWithMask(raw,regionMask);
%       regionEdge=bitand(BW,regionMask);
%       BW=regionEdge;
%       segment=regionImg;
%       y=overlayMask(regionImg,regionEdge);
      y=regionImg;
end