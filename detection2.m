function y=detection2(src,learners,filters,smoothFilter,colorSpace,detectWin,...
    detectSlideStep,detectionOverlap,cellSize,blockSize,blockOverlap,showAsRaw)
    [fImg,edge,color]=imgProc2(src,filters,smoothFilter,colorSpace);
%     [features,cutPoint]=getFeatureVector(color,edge,cellSize,blockSize,blockOverlap);
%     blockPerDetection=floor(((size(detectWin)./cellSize)-blockSize)./(blockSize-blockOverlap) + 1);
%     N = prod([blockPerDetection, blockSize, 9]);
%   
    ax=1;
    ay=1;
    lnSize=size(learners,2);
    owSize=size(edge,2);
    ohSize=size(edge,1);
    wSize=size(detectWin,2);
    hSize=size(detectWin,1);
    features=[];
    dataColor=[];
    dataEdge=[];
    outImg=fImg;
    learner=[];
    if(showAsRaw)
        outImg=src;
    end
    partialMatched=false;
    message='';
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
            partialMatched=false;
            dataColor=color(ay:ay+hSize-1,ax:ax+wSize-1,1:3);
            dataEdge=edge(ay:ay+hSize-1,ax:ax+wSize-1,1:1);
            [features,~,featColor,featShape]=getFeatureVector(dataColor,dataEdge,cellSize,blockSize,blockOverlap);
            featuresArr=[featColor;featShape];
            class=-1;
            for i=1:lnSize
                learner=learners{i};
                [tclass,score]=predict(learner,featuresArr(i,:),'BinaryLoss','binodeviance','PosteriorMethod','gp');
                if(tclass~=-1)
                    if(class==-1)
                        class=tclass;
                    elseif(class~=tclass)
                        if(class~=-1)
                            partialMatched=true;
                            if(i==1)
                                message='Color Matched';
                            else
                                message='Shape Matched';
                            end
                        end
                        class=-1;
                    end
                else
                    break;
                end
            end
%             disp(score);
            if(class==1)
%                 if abs(score(2))<=.45
                    outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 1',...
                        'TextBoxOpacity',0.9,'Color',[0 255 0]);
%                 end
            elseif class==2
%                 if abs(score(3))<=.45
                    outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 2',...
                        'TextBoxOpacity',0.9,'Color',[255 255 0]);
%                 end
            elseif class==3
%                 if abs(score(4))<=.45
                    outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 3',...
                        'TextBoxOpacity',0.9,'Color',[0 255 255]);
%                 end
            elseif class==4
%                 if abs(score(5))<=.45
                    outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 4',...
                        'TextBoxOpacity',0.9,'Color',[255 0 255]);
%                 end
            elseif class==5
%                 if abs(score(6))<=.45
                    outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 5',...
                        'TextBoxOpacity',0.9,'Color',[255 255 255]);
%                 end
            elseif partialMatched==true
                outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 5',...
                        'TextBoxOpacity',0.9,'Color',[255,0,0]);
            end
        end
    end
    
    y=outImg;
end