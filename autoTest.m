function autoTest()

clear all;
close all;
fclose('all');

txtExportFolder='./ResultSet/';

resultSetName={'3c_front'
			   '3c_left'
			   '3c_right'};

trainConf={
           './conf/dumpTest/setting_3c_front.conf'
           './conf/dumpTest/setting_3c_left.conf'
           './conf/dumpTest/setting_3c_right.conf'};
       
testConf={'./conf/13102016/test_3c_front.conf'
		  './conf/13102016/test_3c_left.conf'
          './conf/13102016/test_3c_right.conf'};

initParams();
testSet=1;
nRandomTest=10;
generateRandomOpts(nRandomTest);
id=1;

for testSet=1:size(trainConf,1)
    [edgeLabels,edges,hogLabels,hogVec]=extractTrainSample(trainConf{testSet});
    
    for id=1:nRandomTest
        resultFile=strcat(txtExportFolder,'result_',resultSetName{testSet},'_',num2str(id),'.txt');
        randomizeParams(id);
        trainMySVM();
        testSVM(resultFile,testConf{testSet});
    end
end

end

function generateRandomOpts(nRandom)

global m_ropts;

m_ropts.GapTolerance=rand(nRandom,1)*1e-1*5;
m_ropts.BoxConstraint=1+rand(nRandom,1)*9;
m_ropts.OutlierFraction=rand(nRandom,1);
m_ropts.KernelOffset=rand(nRandom,1);
m_ropts.KernelScale=1+rand(nRandom,1)*4;

end

function initParams()

    global dataset h1 h2 h2t hc hct tmpDir svm svm2 m_ssvm m_ssvm2...
    positives negatives detector capDir rawImg...
    m_showAsRaw m_filter m_sfilter m_cform m_sampleStarted...
    m_svmVector m_svmLabels m_svmVector2 m_svmLabels2 m_classNames  ...
    m_cellSize m_blockSize m_blockOverlap m_sampleSize surfregion surfSize m_opts;

    m_opts.GapTolerance=1e-2;
    m_opts.BoxConstraint=4;
    m_opts.OutlierFraction=1e-1;
    m_opts.KernelOffset=1e-4;
    m_opts.KernelScale=3;
    
    m_classNames={};
    m_sampleSize=[200 200];
    m_cellSize=[16 16];
    m_blockSize=[4 4];
    m_blockOverlap=ceil(m_blockSize/2);
    
    svm=templateSVM('Standardize',0,'KernelFunction','rbf',...
    'GapTolerance',m_opts.GapTolerance,'BoxConstraint',m_opts.BoxConstraint,'OutlierFraction',m_opts.OutlierFraction,...
    'KernelOffset',m_opts.KernelOffset,'KernelScale',m_opts.KernelScale,...
    'DeltaGradientTolerance',1e-8,'IterationLimit',1e4,...
    'KKTTolerance',1e-8,'Nu',.1);

    svm2=templateSVM('Standardize',0,'KernelFunction','rbf',...
    'GapTolerance',m_opts.GapTolerance,'BoxConstraint',m_opts.BoxConstraint,'OutlierFraction',m_opts.OutlierFraction,...
    'KernelOffset',m_opts.KernelOffset,'KernelScale',m_opts.KernelScale,...
    'DeltaGradientTolerance',1e-8,'IterationLimit',1e4,...
    'KKTTolerance',1e-8,'Nu',.1);

    m_showAsRaw=0;
    m_sampleStarted=0;
    dataset=[];
    positives=[];
    negatives=[];
    rawImg=[];
    tmpDir='./tmp';
    capDir='./captured';
    h1=fspecial('gaussian',[15 15],10);
    m_sfilter=fspecial('gaussian',[9 9],9);
    h2=fspecial('log',[9 9],.2);
    h2t=transpose(h2);
    hc=fspecial('log',[5 5],0.9);
    detector=[];
    m_filter={h1};
    m_cform=makecform('srgb2lab');
    m_ssvm=[];
    m_ssvm2=[];
    m_svmVector=[];
    m_svmLabels=[];
    m_svmVector2=[];
    m_svmLabels2=[];

end

function randomizeParams(idx)
    
    global dataset h1 h2 h2t hc hct tmpDir svm svm2 m_ssvm m_ssvm2...
    positives negatives detector capDir rawImg...
    m_showAsRaw m_filter m_sfilter m_cform m_sampleStarted...
    m_svmVector m_svmLabels m_svmVector2 m_svmLabels2 m_classNames  ...
    m_cellSize m_blockSize m_blockOverlap m_sampleSize surfregion surfSize m_opts m_ropts;

    m_opts.GapTolerance=m_ropts.GapTolerance(idx);
    m_opts.BoxConstraint=m_ropts.BoxConstraint(idx);
    m_opts.OutlierFraction=m_ropts.OutlierFraction(idx);
    m_opts.KernelOffset=m_ropts.KernelOffset(idx);
    m_opts.KernelScale=m_ropts.KernelScale(idx);
    
    m_classNames={};
    m_sampleSize=[200 200];
    m_cellSize=[16 16];
    m_blockSize=[4 4];
    m_blockOverlap=ceil(m_blockSize/2);
    svm=templateSVM('Standardize',0,'KernelFunction','rbf',...
    'GapTolerance',m_opts.GapTolerance,'BoxConstraint',m_opts.BoxConstraint,'OutlierFraction',m_opts.OutlierFraction,...
    'KernelOffset',m_opts.KernelOffset,'KernelScale',m_opts.KernelScale,...
    'DeltaGradientTolerance',1e-8,'IterationLimit',1e4,...
    'KKTTolerance',1e-8,'Nu',.1);

    svm2=templateSVM('Standardize',0,'KernelFunction','rbf',...
    'GapTolerance',m_opts.GapTolerance,'BoxConstraint',m_opts.BoxConstraint,'OutlierFraction',m_opts.OutlierFraction,...
    'KernelOffset',m_opts.KernelOffset,'KernelScale',m_opts.KernelScale,...
    'DeltaGradientTolerance',1e-8,'IterationLimit',1e4,...
    'KKTTolerance',1e-8,'Nu',.1);


    

end

function [edgeLabel,edges,hogLabel,hogVec]=extractTrainSample(file)

global m_svmLabels m_svmVector m_svmVector2 m_svmLabels2 m_classNames m_cform m_sfilter m_filter ...
    m_cellSize m_blockSize m_blockOverlap;

fname=file;
[labels,folders,names]=loadSetting(fname);

edgeLabel=[];
edges=[];
hogLabel=[];
hogVec=[];

for a=1:size(labels,2)
    
        [files,folder]=getDirInfos(folders{a});
        className='n';
        h=waitbar(0,'Importing for classes...');
        ts=1/size(files,2);
        percent=0;
        m=1;
        loadingMsg=strcat('Importing for ',names{a},'...');
        while(m<=size(files,2))
            sample=imread(files{m});
            sample=imresize(sample,[200 200]);
            if str2num(char(labels{a}))==-1
                [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
            else
                [sample,shape,rgb]=imgProc2NF(sample,m_filter,m_sfilter,m_cform);
            end
            [feature,~,featColor,featShape]=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
            hogVec=[hogVec;featColor];
            edges=[edges;featShape];
            edgeLabel=[edgeLabel str2num(char(labels{a}))];
            hogLabel=[hogLabel str2num(char(labels{a}))];
            
            m_classNames{end+1}={names{a}};
            m=m+1;
            percent=percent+ts;
            waitbar(percent,h,loadingMsg);
        end
        disp('Samples are added');

        waitbar(1,h,strcat(names{a},' are imported...'));

        close(h);
end
    
    m_svmLabels=hogLabel;
    m_svmLabels2=edgeLabel;
    m_svmVector=hogVec;
    m_svmVector2=edges;

end

function trainMySVM()
    global svm svm2 m_svmLabels m_svmVector m_svmLabels2 m_svmVector2...
    tmpDir m_cform m_sfilter m_filter m_ssvm m_ssvm2 m_classNames;
    if(size(m_svmLabels,1)==0||size(m_svmVector,1)==0)
        msgbox('Please add the samples for training.');
        disp(m_svmLabels);
        return;
    end
    m_ssvm=fitcecoc(m_svmVector,m_svmLabels,'Learners',svm,...
    'Coding','allpairs','Options',statset('UseParallel',0),...
    'Prior','empirical');
    m_ssvm2=fitcecoc(m_svmVector2,m_svmLabels2,'Learners',svm,...
    'Coding','allpairs','Options',statset('UseParallel',0),...
    'Prior','empirical');
    disp('Classicifier was trained.');
end

function testSVM(exportFile,fname)

global m_opts svm m_svmLabels m_svmVector tmpDir m_cform m_sfilter m_filter m_ssvm m_classNames ...
    m_cellSize m_blockSize m_blockOverlap m_ssvm2;

[labels,folders,names]=loadSetting(fname);
disp(m_opts);
fileId=fopen(exportFile,'wt');

fprintf(fileId,'--------SVM Parms------------\r\n');
fprintf(fileId,'BoxConstraint:%f\r\n',m_opts.BoxConstraint);
fprintf(fileId,'GapTolerance:%f\r\n',m_opts.GapTolerance);
fprintf(fileId,'OutlierFraction:%f\r\n',m_opts.OutlierFraction);
fprintf(fileId,'KernelScale:%f\r\n',m_opts.KernelScale);
fprintf(fileId,'KernelOffset:%f\r\n',m_opts.KernelOffset);
fprintf(fileId,'--------SVM Parms End---------\r\n');

keys={-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14};
valueSet=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
target='';
total=0;
map=containers.Map(keys,valueSet);
k=1;
for i=1:size(labels,2)
    msg='';
    labelName=names{i};
    
    [files,folder]=getDirInfos(folders{i});
    h=waitbar(0,'Importing for classes...');
    ts=1/size(files,2);
    percent=0;
    
    msg=strcat(msg,sprintf('Reconize result for %s:\n',names{i}));
    m=1;
%     folderName=sprintf('./result/%s',names{i});
%     disp(folderName);
    showMsg=sprintf('testing on %s',names{i});
    disp(showMsg);
    disp(size(files,2))
    while(m<=size(files,2))
        sample=imread(files{m});
        sample=imresize(sample,[200 200]);
        [output,score,img]=detection4(sample,{m_ssvm m_ssvm2},m_filter,m_sfilter,m_cform,...
            m_cellSize,m_blockSize,m_blockOverlap);
        
%         imwrite(img,strcat(folderName,'/res',num2str(k),'.jpg'));
        
        map(output)=map(output)+1;
        m=m+1;
        k=k+1;
        total=total+1;
        percent=percent+ts;
        waitbar(percent,h,showMsg);
    end
    target=labels{i};
    if((i<size(labels,2)&&~strcmp(target,labels{i+1}))||i+1>size(labels,2))
        %% Log the result for 1 class
        fprintf(fileId,'Testing Result for %s:\r\n',names{i});
        if total==0
            total=1;
        end
        for ki=1:size(keys,2)
            fprintf(fileId,'%d=%d(%.2f)\r\n',keys{ki},map(keys{ki}),map(keys{ki})*100/total);
        end
        fprintf(fileId,'-----------------------------------\r\n');
        %% Reset the variables
        total=0;
        k=1;
        valueSet=zeros(1,size(keys,2));  
        map=containers.Map(keys,valueSet);
    end
    
    close(h);
    
end

fclose(fileId);
fclose('all');

disp('Result is exported');
end