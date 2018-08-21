function exportCSVFromMat()

getOverall();
return;

data=load('exp/scores/geoffrey.mat');
nData=size(data.orig_scores,2);
nCol=size(data.orig_scores{1},1);
M=[];
rr=1;
for r=1:nData
    for v=1:3
        mm=data.orig_scores{r}(:,v);
        row=mm.';
        drow=[data.targetClasses(r) v row];
        M(rr,:)=drow;
        rr=rr+1;
    end
end
csvwrite('exp/scores/geoffrey.csv',M);

end

function getOverall()
dataFiles={
    'exp/scores/raymond.mat'
    'exp/scores/kc.mat'
    'exp/scores/geoffrey.mat'
    'exp/scores/s1.mat'
    'exp/scores/s2.mat'
    'exp/scores/s3.mat'
    };
M=[];
c=1;
for i=1:size(dataFiles,1)
    data=load(dataFiles{i});
    nData=size(data.orig_scores,2);
    nCol=size(data.orig_scores{1},1);
    for r=1:nData
        for v=1:3
            row=data.orig_scores{r}(:,v).';
            drow=[data.targetClasses(r) v row];
            M(c,:)=drow;
            c=c+1;
        end
    end
end

csvwrite('./exp/scores/overall.csv',M);
save('./exp/scores/overall.mat','M');

end