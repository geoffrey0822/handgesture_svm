function y=imgProc(x,h)
        %y=rgb2gray(x);
        if(size(x,3)==3)
            %y=rgb2hsv(x);
            %y=rgb2lab(x);
            %y=rgb2gray(x);
            %y=rgb2ycbcr(x);
            y=x;
        else
            y=x;
        end
        i=1;
        n=size(h,2);
%         y=bfilter2(im2double(y),255,2);
        while(i<=n)
            y=imfilter(y,h{1,i},'conv');
            %y=conv2(double(y),h{1,i});
            i=i+1;
        end
        x=y;
        %y=gather(y);
        %y=edge(y,'roberts');
        
%         [~, threshold] = edge(y, 'roberts');
%         fudgeFactor = .5;
%         BWs = edge(y,'roberts', threshold * fudgeFactor);
%         se90 = strel('line', 3, 90);
%         se0 = strel('line', 3, 0);
%         BWsdil = imdilate(BWs, [se90 se0]);
%         BWdfill = imfill(BWsdil, 'holes');
%         BWnobord = imclearborder(BWdfill, 4);
%         seD = strel('diamond',1);
%         BWfinal = imerode(BWnobord,seD);
%         y = imerode(BWfinal,seD);
        %[y,map]=rgb2ind(y,65535);
        %y=roicolor(rgb2ind(y,65535),5000,5500);
        %y=segmentation(x,[100 200 0],300);
        y=rangefilt(y);
        %y=im2bw(y,.1);
        %y=im2uint8(y);
end