function y=detection(src,learner,filters,smoothFilter,colorSpace,detectWin,...
    detectSlideStep,detectionOverlap,cellSize,blockSize,blockOverlap,showAsRaw)
    [fImg,edge,color]=imgProc2(src,filters,smoothFilter,colorSpace);
%     [features,cutPoint]=getFeatureVector(color,edge,cellSize,blockSize,blockOverlap);
%     blockPerDetection=floor(((size(detectWin)./cellSize)-blockSize)./(blockSize-blockOverlap) + 1);
%     N = prod([blockPerDetection, blockSize, 9]);
%   
    ax=1;
    ay=1;
    owSize=size(edge,2);
    ohSize=size(edge,1);
    wSize=size(detectWin,2);
    hSize=size(detectWin,1);
    features=[];
    dataColor=[];
    dataEdge=[];
    outImg=fImg;
    if(showAsRaw)
        outImg=src;
    end
    for iy=0:detectSlideStep(1)-1
        ax=0;
        ay=iy*detectionOverlap(1)+1;
        if ay+hSize>ohSize
            ay=ohSize-hSize;
        end
        for ix=0:detectSlideStep(2)-1
            ax=ix*detectionOverlap(2)+1;
            if ax+wSize>owSize
                ax=owSize-wSize;
            end
            dataColor=color(ay:ay+hSize-1,ax:ax+wSize-1,1:3);
            dataEdge=edge(ay:ay+hSize-1,ax:ax+wSize-1,1:1);
            features=getFeatureVector(dataColor,dataEdge,cellSize,blockSize,blockOverlap);
            [class,score]=predict(learner,features,'BinaryLoss','binodeviance','PosteriorMethod','gp');
%             disp(score);
            if(class==1)
%                 if abs(score(2))<=.45
                    outImg=insertShape(outImg,'Rectangle',[ax ay wSize hSize],'Color',[0 255 0],...
                        'LineWidth',2);
%                 end
            elseif class==2
%                 if abs(score(3))<=.45
                    outImg=insertShape(outImg,'Rectangle',[ax ay wSize hSize],'Color',[255 255 0],...
                        'LineWidth',2);
%                 end
            elseif class==3
%                 if abs(score(4))<=.45
                    outImg=insertShape(outImg,'Rectangle',[ax ay wSize hSize],'Color',[0 255 255],...
                        'LineWidth',2);
%                 end
            elseif class==4
%                 if abs(score(5))<=.45
                    outImg=insertShape(outImg,'Rectangle',[ax ay wSize hSize],'Color',[255 0 0],...
                        'LineWidth',2);
%                 end
            elseif class==5
%                 if abs(score(6))<=.45
                    outImg=insertShape(outImg,'Rectangle',[ax ay wSize hSize],'Color',[255 255 255],...
                        'LineWidth',2);
%                 end
            end
        end
    end
    
    y=outImg;
end