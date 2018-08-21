function [class,score,outImg]=detection3_rt2(src,learners,filters,smoothFilter,colorSpace,...
    cellSize,blockSize,blockOverlap,detectWin,...
    detectSlideStep,detectionOverlap,showAsRaw)
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
%     disp(size(src));
%     wSize=size(src,2);
%     hSize=size(src,1);
    wSize=size(detectWin,2);
    hSize=size(detectWin,1);
    features=[];
    dataColor=[];
    dataEdge=[];
    outImg=fImg;
    learner=[];
    
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
            message='';
%             dataColor=color;
%             dataEdge=edge;
            dataColor=color(ay:ay+hSize-1,ax:ax+wSize-1,1:3);
            dataEdge=edge(ay:ay+hSize-1,ax:ax+wSize-1,1:1);
            score=0;
            [features,~,featColor,featShape]=getFeatureVector(dataColor,dataEdge,cellSize,blockSize,blockOverlap,src);
%             featuresArr={featColor;featShape};
            featv=[featColor featShape];
            class=-1;
            labelName='';
            
            learner=learners{1};
            [tclass,score]=predict(learner,featv,'BinaryLoss','binodeviance','PosteriorMethod','gp');
            class=tclass;
                
            if(class~=-1)
                labelName=sprintf('pose %d',class);
            end
            if(class~=-1)
                outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 1',...
                    'TextBoxOpacity',0.9,'Color',[0 255 0]);
                outImg=insertText(outImg,[1 1],labelName,'BoxColor',[0 255 0]);
            elseif partialMatched==true
                outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'Confused',...
                    'TextBoxOpacity',0.9,'Color',[255,0,0]);
                outImg=insertText(outImg,[1 1],'Confused','BoxColor',[255 0 0]);
            end
        end
    end
    
    
end