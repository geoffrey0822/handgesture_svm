function y=detectionProc(x,fparams,pos,bsize)
%% Load the Parameters
    edges=fparams{1};
    color=fparams{2};
    cellSize=fparams{3};
    blockSize=fparams{4};
    blockOverlap=fparams{5};
    learners=fparams{6};
    lnSize=size(learners,2);

%% Start Reconition
    px=pos(2);
    py=pos(1);
    w=bsize(2);
    h=bsize(1);
%     disp(pos);
    local_edges=edges(py:py-1+h,px:px-1+w,1:1);
    local_color=color(py:py-1+h,px:px-1+w,1:3);
    local_x=x(py:py-1+h,px:px-1+w,1:3);
    [features,~,featColor,featShape]=getFeatureVector(local_color,local_edges,...
        cellSize,blockSize,blockOverlap,local_x);
    featuresArr={featColor;featShape};
    class=-1;
    labelName='';
    partialMatched=false;
    
    learner=learners{1};
    [tclass,score]=predict(learner,[featColor featShape],'BinaryLoss','binodeviance','PosteriorMethod','gp');
    class=tclass;
    
    if(class~=-1)
        labelName=sprintf('pose %d',class);
    end
    y=x;
    if(class~=-1)
        y=insertObjectAnnotation(y,'Rectangle',[px py w h],'pose 1',...
            'TextBoxOpacity',0.9,'Color',[0 255 0]);
        y=insertText(y,[1 1],labelName,'BoxColor',[0 255 0]);
    elseif partialMatched==true
        y=insertObjectAnnotation(y,'Rectangle',[px py w h],'Confused',...
            'TextBoxOpacity',0.9,'Color',[255,0,0]);
        y=insertText(y,[1 1],'Confused','BoxColor',[255 0 0]);
    end
end