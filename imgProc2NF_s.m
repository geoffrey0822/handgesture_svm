function [y,BW,segment,BWShape]=imgProc2(raw,filters,smoothFilter,colorSpace,edgeTheshold)
%%
% [area,BW]=graphCutImage(raw);
% segment=im2double(raw);
% segment(:,:,1)=segment(:,:,1).*area;
% segment(:,:,2)=segment(:,:,2).*area;
% segment(:,:,3)=segment(:,:,3).*area;
% y=overlayMask(segment,BW);
% return;
%%
%     ty=imfilter(applycform(raw,colorSpace),smoothFilter,'conv');
%     ty=applycform(raw,colorSpace);
%     ty=lab2uint16(rgb2lab(raw));
%     mask=segmentationRange(ty,[0 0 1],[0 0 2]);
        %% Workable Setting
    mask=segmentationRange(raw,[0 133 120],[255 255 255]);
    mask=im2bw(raw,0);
%%

    %     mask=segmentationRange(ty,[0 135 90],[255 220 255]);
%     mask=segmentationRange(ty,[0 135 90],[255 220 255]);
%     mask=imfilter(mask,smoothFilter,'conv');
%     mask=imfilter(mask,smoothFilter,'conv');
%%  Region Extracted
%     guide=imfilter(raw,smoothFilter,'conv');
%     mask2=imfilter(mask,filters{1},'conv');
%     mask3=imguidedfilter(mask2,guide,'NeighborhoodSize',[3 3]);
%     mask1=wiener2(mask,[15 15]);
%%  Enhancement Step
%     segment=combineWithMask(ty,mask3);
%     mask=imfilter(segmentationRange(segment,[0 120 80],[200 221 255]),smoothFilter,'conv');
%     mask=imfilter(segmentationRange(segment,[0 0 0],[0 0 0]),smoothFilter,'conv');
    %% Workable Setting
%     mask=imfilter(segmentationRange(segment,[0 80 130],[255 255 255]),smoothFilter,'conv');
    %%
%     mask=imguidedfilter(mask,mask1,'NeighborhoodSize',[3 3]);
%     segment=combineWithMask(raw,mask);
%     segment2=combineWithMask(raw,mask); % original is mask2
segment=raw;
segment2=raw;
    %%
%     BW=edge(rgb2gray(segment2),'Prewitt',.03);
    BW=edge(rgb2gray(segment2),'Canny',edgeTheshold);
%     BWShape=rangefilt(mask2);
%     BW=rangefilt(mask2);
%     BW=imgProc(mask2,filters);
%     [B,L]=bwboundaries(BW);

%% Original
%     y=overlayMask(segment,BW);
%     y=overlayMask(y,BWShape);
    
%     y=overlayMask(segment2,BW);
%     y=overlayMask(segment2,bitxor(BW,bwperim(mask,8)));
%       regionMask=bwareafilt(mask,1);
      regionMask=mask;
%       regionMask=bwareafilt(mask,2);
%       regionImg=combineWithMask(raw,mask);
      regionImg=raw;
      regionEdge=bitand(BW,regionMask);
      BW=regionEdge;
      segment=regionImg;
      y=overlayMask(regionImg,regionEdge);
    
%     y=imfill(BW);
end