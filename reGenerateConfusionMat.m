function reGenerateConfusionMat()

close all;


filename='overall'
datafile=strcat('./exp/confuse/',filename,'.mat');
expFile=strcat('./exp/confuse/',filename,'_regen.png');
data=load(datafile);

targetTotal=sum(data.plabels,2);
% targetTotal=circshift(targetTotal,-1); % For weighted sum

disp(targetTotal);

cm=data.confusionM;
dim=size(cm,1);
cm=circshift(cm,[-1 -1]);
cmP=getPercentageMatrix(cm,targetTotal);

% disp(data);
% disp(targetTotal.');
disp('---------------------------');
disp(cm);
disp('---------------------------');
disp(cmP);

clim=[0 100];
imagesc(cmP,clim);
colorbar;

% textStr=strcat(num2str(cm(:)),num2str(cmP(:),'\n%.2f%%'));
% textStr=strtrim(cellstr(textStr));
% textStr(dim*dim)=cellstr(sprintf('%d\n%.2f%%',cm(dim,dim),cmP(dim,dim)));
textStr=getCellString(cm,cmP);
disp(size(textStr));

[x,y]=meshgrid(1:dim);
hStr=text(x(:),y(:),textStr(:),...
    'HorizontalAlignment','center');
midValue=mean(get(gca,'CLim'));
textColors=repmat(cmP(:)<midValue,1,3);

set(hStr,{'Color'},num2cell(textColors,2));

axisLabel={'Pose 1' 'Pose 2' 'Pose 3' 'Pose 4' 'Pose 5' 'Pose 6' 'Pose7' 'Negative'};
set(gca,'XTick',1:8,...
    'XTickLabel',axisLabel,...
    'XTick',1:8,...
    'YTickLabel',axisLabel);

xlabel('Output');
ylabel('Target');
title('Confusion Matrix');


saveas(gcf,expFile);

end

function cellStr=getCellString(cm,cmp)

dim=size(cm,2);
cellStr={};
for r=1:dim
    for c=1:dim
        cellStr{(r-1)*dim+c}=sprintf('%d\n%.2f%%',cm(c,r),cmp(c,r));
    end
end

end

function cmP=getPercentageMatrix(cm,classTotal)

cmP=cm;
dim=size(cm,1);
for r=1:dim
    cmP(r,:)=100*(cmP(r,:)./classTotal(r));
end

end