function y=slidingProcess(img,fparams,func,procSize,slideStep)
    imageSize=size(img);
    pos_x=1;
    pos_y=1;
    while(pos_x-1+procSize(2)<imageSize(2))
        while(pos_y-1+procSize(1)<imageSize(1))
            y=func(img,fparams,[pos_y pos_x],procSize);
            pos_y=pos_y-1+slideStep(1);
        end
        pos_x=pos_x-1+slideStep(2);
    end
end