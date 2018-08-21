function [class,score,outImg]=detection3(src,learners,filters,smoothFilter,colorSpace,...
    cellSize,blockSize,blockOverlap,expectedLabelIdx)
    [fImg,edge,color]=imgProc2NF(src,filters,smoothFilter,colorSpace);
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
    wSize=size(src,2);
    hSize=size(src,1);
    features=[];
    dataColor=[];
    dataEdge=[];
    outImg=fImg;
    learner=[];
    partialMatched=false;
    message='';
    dataColor=color;
    dataEdge=edge;
    score=0;
    [features,~,featColor,featShape]=getFeatureVector(dataColor,dataEdge,cellSize,blockSize,blockOverlap,src);
    featuresArr={featColor;featShape};
    class=-1;
    labelName='';
    scoreStr='';
    for i=1:lnSize
        learner=learners{i};
        [tclass,score]=predict(learner,featuresArr{i},'BinaryLoss','binodeviance','PosteriorMethod','gp');
        scoreStr='';
        for j=1:size(score,2)
            if(j==expectedLabelIdx)
                scoreStr=strcat(scoreStr,num2str(j),':',num2str(score(j)),'');
                break;
            end
        end
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
    if(class~=-1)
        labelName=sprintf('pose %d[%s]',class,scoreStr);
    else
        labelName=sprintf('Negative [%s]',class,scoreStr);
    end
%     if(class==1)
%         outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 1',...
%             'TextBoxOpacity',0.9,'Color',[0 255 0]);
%         outImg=insertText(outImg,[1 1],labelName,'BoxColor',[0 255 0]);
%     elseif class==2
%         outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 2',...
%             'TextBoxOpacity',0.9,'Color',[255 255 0]);
%         outImg=insertText(outImg,[1 1],labelName,'BoxColor',[255 255 0]);
%     elseif class==3
%         outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 3',...
%             'TextBoxOpacity',0.9,'Color',[0 255 255]);
%         outImg=insertText(outImg,[1 1],labelName,'BoxColor',[0 255 255]);
%     elseif class==4
%         outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 4',...
%             'TextBoxOpacity',0.9,'Color',[255 0 255]);
%         outImg=insertText(outImg,[1 1],labelName,'BoxColor',[255 0 255]);
%     elseif class==5
%         outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 5',...
%             'TextBoxOpacity',0.9,'Color',[255 255 255]);
%         outImg=insertText(outImg,[1 1],labelName,'BoxColor',[255 255 255]);
    if(class~=-1)
        outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'pose 1',...
            'TextBoxOpacity',0.9,'Color',[0 255 0]);
        outImg=insertText(outImg,[1 1],labelName,'BoxColor',[0 255 0]);
    elseif partialMatched==true
        outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'Confused',...
            'TextBoxOpacity',0.9,'Color',[255,0,0]);
        outImg=insertText(outImg,[1 1],'Confused','BoxColor',[255 0 0]);
    else
        outImg=insertObjectAnnotation(outImg,'Rectangle',[ax ay wSize hSize],'',...
            'TextBoxOpacity',0.9,'Color',[255,0,0]);
        outImg=insertText(outImg,[1 1],labelName,'BoxColor',[255 0 0]);
    end
    
end