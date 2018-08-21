function [y,cutPoint,colorFeat,shapeFeat]=getFeatureVector(rgb,shape,cellSize,blockSize,blockOverlap,src)
%% HOG Feature
    w=size(shape,2);
    h=size(shape,1);
    
    [featRGB,~]=extractHOGFeatures(rgb,'CellSize',cellSize,...
        'BlockSize',blockSize,'NumBins',9);
%     [featRGB,~]=extractLBPFeatures(rgb2gray(rgb),'CellSize',cellSize,...
%         'BlockSize',blockSize,'NumBins',9);
%% 29-6-2016 Commented
    [featShape,~]=extractHOGFeatures(shape,'CellSize',cellSize,...
        'BlockSize',blockSize,'NumBins',9);
%%
% featShape=getUniformSURFFeature(shape,50);
%     [featShape,~]=getCustomFeature(src);
%% Spatial Domain
% %     rPx=rgb(:,:,1)/255;
% %     gPx=rgb(:,:,2)/255;
% %     bPx=rgb(:,:,3)/255;
    
    %% Frequency Domain
% %     rS=fft2(rPx);
% %     rS=fftshift(rS);
% %     rS=abs(rS);
% %     gS=fft2(gPx);
% %     gS=fftshift(gS);
% %     gS=abs(gS);
% %     bS=fft2(bPx);
% %     bS=fftshift(bS);
% %     bS=abs(bS);
% %     shapeS=fft2(shape);
% %     shapeS=fftshift(shapeS);
% %     shapeS=abs(shapeS);
    
    %% Convert to Vector
    y={featRGB featShape};
%     disp(size(featRGB,2));
%     disp(size(featShape,2));
    cutPoint=size(featRGB,2);
    colorFeat=featRGB;
    shapeFeat=featShape;
%     blockPerImg=floor(((size(shape)./cellSize)-blockSize)./(blockSize-blockOverlap) + 1);
%     N = prod([blockPerImg, blockSize, 9]);
%     disp(N);
%     y=[rPx(:)' gPx(:)' bPx(:)' shape(:)'];
%     y=[rS(:)' gS(:)' bS(:)' shapeS(:)'];
    
end