function autoTest_exp_sw()

clear all;
close all;
fclose('all');

txtExportFolder='./ResultSet/';

% % % % resultSetName={
% % % %                '1c_front'
% % % %                '1c_left'
% % % %                '1c_right'
% % % %                '2c_front'
% % % %                '2c_left'
% % % %                '2c_right'
% % % %                '3c_front'
% % % %                '3c_left'
% % % %                '3c_right'
% % % %                '4c_front'
% % % %                '4c_left'
% % % %                '4c_right'
% % % %                '5c_front'
% % % %                '5c_left'
% % % %                '5c_right'
% % % %                '6c_front'
% % % %                '6c_left'
% % % %                '6c_right'};
% % % % 
% % % % trainConf={
% % % %            './conf/dumpTest/setting_1c_front.conf'
% % % %            './conf/dumpTest/setting_1c_left.conf'
% % % %            './conf/dumpTest/setting_1c_right.conf'
% % % %            './conf/dumpTest/setting_2c_front.conf'
% % % %            './conf/dumpTest/setting_2c_left.conf'
% % % %            './conf/dumpTest/setting_2c_right.conf'
% % % %            './conf/dumpTest/setting_3c_front.conf'
% % % %            './conf/dumpTest/setting_3c_left.conf'
% % % %            './conf/dumpTest/setting_3c_right.conf'
% % % %            './conf/dumpTest/setting_4c_front.conf'
% % % %            './conf/dumpTest/setting_4c_left.conf'
% % % %            './conf/dumpTest/setting_4c_right.conf'
% % % %            './conf/dumpTest/setting_5c_front.conf'
% % % %            './conf/dumpTest/setting_5c_left.conf'
% % % %            './conf/dumpTest/setting_5c_right.conf'
% % % %            './conf/dumpTest/setting_6c_front.conf'
% % % %            './conf/dumpTest/setting_6c_left.conf'
% % % %            './conf/dumpTest/setting_6c_right.conf'};
% % % %        
% % % % testConf={
% % % %     './conf/31102016/test_1c_front.conf'
% % % %     './conf/31102016/test_1c_left.conf'
% % % %     './conf/31102016/test_1c_right.conf'
% % % %     './conf/31102016/test_2c_front.conf'
% % % %     './conf/31102016/test_2c_left.conf'
% % % %     './conf/31102016/test_2c_right.conf'
% % % %     './conf/31102016/test_3c_front.conf'
% % % %     './conf/31102016/test_3c_left.conf'
% % % %     './conf/31102016/test_3c_right.conf'
% % % %     './conf/31102016/test_4c_front.conf'
% % % %     './conf/31102016/test_4c_left.conf'
% % % %     './conf/31102016/test_4c_right.conf'
% % % %     './conf/31102016/test_5c_front.conf'
% % % %     './conf/31102016/test_5c_left.conf'
% % % %     './conf/31102016/test_5c_right.conf'
% % % %     './conf/31102016/test_6c_front.conf'
% % % %     './conf/31102016/test_6c_left.conf'
% % % %     './conf/31102016/test_6c_right.conf'};

resultSetName={
               '1c_front'
               '1c_left'
               '1c_right'
               '2c_front'
               '2c_left'
               '2c_right'
               '3c_front'
               '3c_left'
               '3c_right'};

trainConf={
           './conf/dumpTest3/setting_1c_front.conf'
           './conf/dumpTest3/setting_1c_left.conf'
           './conf/dumpTest3/setting_1c_right.conf'
           './conf/dumpTest3/setting_2c_front.conf'
           './conf/dumpTest3/setting_2c_left.conf'
           './conf/dumpTest3/setting_2c_right.conf'
           './conf/dumpTest3/setting_3c_front.conf'
           './conf/dumpTest3/setting_3c_left.conf'
           './conf/dumpTest3/setting_3c_right.conf'};
       
testConf={
    './conf/dumpTest3/test/test_1c_front.conf'
    './conf/dumpTest3/test/test_1c_left.conf'
    './conf/dumpTest3/test/test_1c_right.conf'
    './conf/dumpTest3/test/test_2c_front.conf'
    './conf/dumpTest3/test/test_2c_left.conf'
    './conf/dumpTest3/test/test_2c_right.conf'
    './conf/dumpTest3/test/test_3c_front.conf'
    './conf/dumpTest3/test/test_3c_left.conf'
    './conf/dumpTest3/test/test_3c_right.conf'};

% % % % % % % % resultSetName={
% % % % % % % %                '5c_front'
% % % % % % % %                '5c_left'
% % % % % % % %                '5c_right'
% % % % % % % %                '6c_front'
% % % % % % % %                '6c_left'
% % % % % % % %                '6c_right'};
% % % % % % % % 
% % % % % % % % trainConf={
% % % % % % % %            './conf/dumpTest/setting_5c_front.conf'
% % % % % % % %            './conf/dumpTest/setting_5c_left.conf'
% % % % % % % %            './conf/dumpTest/setting_5c_right.conf'
% % % % % % % %            './conf/dumpTest/setting_6c_front.conf'
% % % % % % % %            './conf/dumpTest/setting_6c_left.conf'
% % % % % % % %            './conf/dumpTest/setting_6c_right.conf'};
% % % % % % % %        
% % % % % % % % testConf={
% % % % % % % %     './conf/31102016/test_5c_front.conf'
% % % % % % % %     './conf/31102016/test_5c_left.conf'
% % % % % % % %     './conf/31102016/test_5c_right.conf'
% % % % % % % %     './conf/31102016/test_6c_front.conf'
% % % % % % % %     './conf/31102016/test_6c_left.conf'
% % % % % % % %     './conf/31102016/test_6c_right.conf'};
% % % % % % % % 
% % % % % % % % testGroup=[1 2 3
% % % % % % % %            4 5 6
% % % % % % % %            7 8 9];

% % % % % % % % testGroup=[1 2 3
% % % % % % % %            4 5 6
% % % % % % % %            7 8 9
% % % % % % % %            10 11 12
% % % % % % % %            13 14 15
% % % % % % % %            16 17 18];
% % % % % % % % resultSetGroupName={'raymond' 'kc' 'geoffrey' 's1' 's2' 's3'};
testGroup=[1 2 3
           4 5 6
           7 8 9];
resultSetGroupName={'raymond' 'kc' 'geoffrey'};
testClasses={-1 1 2 3 4 5 6 7};
vals=1:numel(testClasses);
classMap=containers.Map(testClasses,vals);
disp(vals);

initParams();
testSet=1;
nRandomTest=10;
generateRandomOpts(nRandomTest);
id=1;

if ~exist('./exp');
    mkdir('./exp');
    mkdir('./exp/feature');
    mkdir('./exp/svm');
end

if ~exist('./exp/confuse')
    mkdir('./exp/confuse');
end

if ~exist('./exp/results')
    mkdir('./exp/results');
end

if ~exist('./exp/scores');
    mkdir('./exp/scores');
end


for testG=1:size(testGroup,1)
    grp=testGroup(testG,:);
    confuseFile=strcat('./exp/confuse/',resultSetGroupName{testG},'.mat');
    confuseImgFile=strcat('./exp/confuse/',resultSetGroupName{testG},'.png');
    scoreFile=strcat('./exp/scores/',resultSetGroupName{testG},'.mat');
    
    svmFiles={};
    grpI=[];
    for j=1:numel(grp)
        featFile=strcat('./exp/feature/',resultSetName{grp(j)},'.mat');
        svmFile=strcat('./exp/svm/',resultSetName{grp(j)},'.mat');
        svmFiles={svmFiles{:} svmFile};
        grpI(j)=j;
    end
    
    [classes,pclasses,pfiles]=getGroupFiles(testConf,grp);
    [gSVM1,gSVM2]=getGroupSVM(svmFiles,grpI);
    
    testGroupSVM(gSVM1,gSVM2,testClasses,pclasses,pfiles,scoreFile);
    computeConfusionMatrix(confuseFile,confuseImgFile,testClasses,classMap);
end

% for testSet=1:size(trainConf,1)
%     featFile=strcat('./exp/feature/',resultSetName{testSet},'.mat');
%     svmFile=strcat('./exp/svm/',resultSetName{testSet},'.mat');
%     confuseFile=strcat('./exp/confuse/',resultSetName{testSet},'.mat');
%     confuseImgFile=strcat('./exp/confuse/',resultSetName{testSet},'.png');
%     
%     if ~exist(featFile)
%         [edgeLabels,edges,hogLabels,hogVec]=extractTrainSample(trainConf{testSet});
%         save(featFile,'edgeLabels','edges','hogLabels','hogVec');
%     else
%         loadFeatureVector(featFile);
%     end
%     
%     outputDir=strcat('./exp/results/',resultSetName{testSet});
%     if ~exist(outputDir)
%         mkdir(outputDir);
%     end
%     
%     resultFile=strcat(txtExportFolder,'result_',resultSetName{testSet},'_',num2str(id),'.txt');
%     randomizeParams(id);
%     
%     [svm1,svm2]=trainMySVM(svmFile);
%     testSVM(resultFile,testConf{testSet},outputDir);
%     
%     computeConfusionMatrix(confuseFile,confuseImgFile);
%     
% end
% 
% 
computeOverallConfusionMatrix('./exp/confuse/overall.mat','./exp/confuse/overall.png',testClasses,classMap);
fclose('all');

end


function loadFeatureVector(file)
global m_svmLabels m_svmVector m_svmVector2 m_svmLabels2;

S=load(file);
m_svmLabels2=S.edgeLabels;
m_svmVector2=S.edges;
m_svmLabels=S.hogLabels;
m_svmVector=S.hogVec;
        
end

function generateRandomOpts(nRandom)

global m_ropts;

m_ropts.GapTolerance=0.136740;
m_ropts.BoxConstraint=4.999214;
m_ropts.OutlierFraction=0.879765;
m_ropts.KernelOffset=0.973884;
m_ropts.KernelScale=4.801856;

end

function initParams()

    global dataset h1 h2 h2t hc hct tmpDir svm svm2 m_ssvm m_ssvm2...
    positives negatives detector capDir rawImg...
    m_showAsRaw m_filter m_sfilter m_cform m_sampleStarted...
    m_svmVector m_svmLabels m_svmVector2 m_svmLabels2 m_classNames  ...
    m_cellSize m_blockSize m_blockOverlap m_sampleSize surfregion surfSize m_opts all_target all_observed;

    all_target=[];
    all_observed=[];

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

function [gSVM1,gSVM2]=getGroupSVM(files,grp)
    gSVM1={};
    gSVM2={};
    for i=1:numel(grp)
        [tmp1,tmp2]=trainMySVM(files{grp(i)});
        gSVM1={gSVM1{:} tmp1};
        gSVM2={gSVM2{:} tmp2};
    end
end

function [o_svm1,o_svm2]=trainMySVM(file)
    global svm svm2 m_svmLabels m_svmVector m_svmLabels2 m_svmVector2...
    tmpDir m_cform m_sfilter m_filter m_ssvm m_ssvm2 m_classNames;
    o_svm1=[];
    o_svm2=[];
    if ~exist(file)
        m_ssvm=fitcecoc(m_svmVector,m_svmLabels,'Learners',svm,...
        'Coding','allpairs','Options',statset('UseParallel',0),...
        'Prior','empirical');
        m_ssvm2=fitcecoc(m_svmVector2,m_svmLabels2,'Learners',svm,...
        'Coding','allpairs','Options',statset('UseParallel',0),...
        'Prior','empirical');
        save(file,'m_ssvm','m_ssvm2');
    else
        data=load(file);
        m_ssvm=data.m_ssvm;
        m_ssvm2=data.m_ssvm2;
    end
    o_svm1=m_ssvm;
    o_svm2=m_ssvm2;
%     disp('Classicifier was trained.');
end

function [allClasses,pclass,pfiles]=getGroupFiles(configs,grp)
    pclass={};
    pfiles={};
    allClasses={};
    n=1;
    m=1;
    maxSizes=[];
    for i=1:numel(grp)
        [labels,folders,names]=loadSetting(configs{grp(i)});
        n=1;
        tpclass={};
        tpfiles={};
        if isempty(maxSizes)
            maxSizes=zeros(1,numel(labels));
        end
        for j=1:numel(labels)
            [files,folder]=getDirInfos(folders{j});
            allClasses{m}=str2num(cell2mat(labels{j}));
            m=m+1;
            ipclass={};
            ipfiles={};
            if maxSizes(j)<numel(files)
                maxSizes(j)=numel(files);
            end
            for k=1:numel(files)
                ipclass{k}=str2num(cell2mat(labels{j}));
                ipfiles{k}=files{k};
                n=n+1;
            end
            tpclass{j}=ipclass;
            tpfiles{j}=ipfiles;
        end
        pclass{i}=tpclass;
        pfiles{i}=tpfiles;
    end
    allClasses=unique(cell2mat(allClasses));
%     disp(maxSizes);
%     disp(pclass{1});
%     disp(pclass{2});
%     disp(pclass{3});
    %% Normalize the size for each pose in views
  for i=1:numel(grp)
      for j=1:numel(maxSizes)
          isize=numel(pclass{i}{j});
          for k=isize:maxSizes(j)
              if k>isize
                  pclass{i}{j}{k}=pclass{i}{j}{1};
                  pfiles{i}{j}{k}='';
              end
          end
      end
  end
%   disp('-----------------------------------------------');
%   disp(pclass{1});
%   disp(pclass{2});
%   disp(pclass{3});
    
end

function result=testGroupSVM(gsvm1,gsvm2,classes,pclasses,pfiles,scoreFile)

global m_cform m_sfilter m_filter ...
    m_cellSize m_blockSize m_blockOverlap predictLabels observedLabels all_predicts all_observes;

nTest=size(pclasses{1},2);
nTestClass=size(pclasses{1},2);
nGrp=numel(pclasses);
nClass=numel(classes);
stats=zeros(1,numel(classes));

result=containers.Map(classes,stats);

predictLabels=[];
observedLabels=[];

all_p={};
h=waitbar(0,'Testing for classes...');
percent=0;

totalSize=0;
dataSizes=zeros(1,nTestClass);
for i=1:nTestClass
    totalSize=totalSize+numel(pclasses{1}{i});
    dataSizes(i)=numel(pclasses{1}{i});
end

disp(dataSizes);

ts=1/totalSize;
d=1;
orig_scores={};
scores={};
targetClasses=[];
idx=1;
for i=1:nTestClass
    for k=1:dataSizes(i)
        expected=int32(pclasses{1}{i}{k});
        showMsg=strcat('Testing [',num2str(d),'/',num2str(totalSize),']');
        if percent>1
            percent=0;
        end
        p=[];
        emptyFrames=ones(1,nGrp);
        defScore=[];
        for j=1:nGrp
            if isempty(pfiles{j}{i}{k})
                if(j==1)
                    score=ones(1,nClass)*-1;
                end
                p(j,:)=score;
                emptyFrames(j)=0;
                continue;
            end
            sample=imread(pfiles{j}{i}{k});
            sample=imresize(sample,[200 200]);
            [output,score,img]=detection4_sum(sample,{gsvm1{j} gsvm2{j}},m_filter,m_sfilter,m_cform,...
                m_cellSize,m_blockSize,m_blockOverlap);
            p(j,:)=score;
            defScore=score;
        end
        dist=norm(emptyFrames);
        if dist==0
            disp('empty frames');
            continue;
        elseif dist~=1
            for j=1:nGrp
                if emptyFrames(j)==0
                    p(j,:)=defScore;
                end
            end
        end
%         pw=p;
        p=p.';
        orig_scores{idx}=p;
        pw=computeWeightedSumScores(p);
        scores{idx}=pw;
        [bestScore,bestIdx]=max(pw);
        targetClasses(idx)=expected;
        outputClass=int32(cell2mat(classes(bestIdx)));
        percent=percent+ts;
        waitbar(percent,h,showMsg);
        all_p{i}=p;
        d=d+1;
        predictLabels=[predictLabels expected];
        observedLabels=[observedLabels outputClass];
        
        idx=idx+1;
% % % % % % % % % %         for j=1:nGrp
% % % % % % % % % %             %% Keep the same number of frame
% % % % % % % % % %             if isempty(pfiles{j,i})
% % % % % % % % % %                 continue;
% % % % % % % % % %             end
% % % % % % % % % %             predictLabels=[predictLabels expected];
% % % % % % % % % %             observedLabels=[observedLabels outputClass];
% % % % % % % % % %         end
    end
end

all_predicts=[all_predicts predictLabels];
all_observes=[all_observes observedLabels];

close(h);

save(scoreFile,'orig_scores','scores','targetClasses');

% % % % % % % % % % % % % % % % % % % % % % % % % for i=1:nTest
% % % % % % % % % % % % % % % % % % % % % % % % %     p=[];
% % % % % % % % % % % % % % % % % % % % % % % % %     ts=1/nTest;
% % % % % % % % % % % % % % % % % % % % % % % % %     if percent>1
% % % % % % % % % % % % % % % % % % % % % % % % %         percent=0;
% % % % % % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % % % % % %     expected=int32(pclasses{1,i});
% % % % % % % % % % % % % % % % % % % % % % % % %     showMsg=strcat('Testing [',num2str(i),'/',num2str(nTest),']');
% % % % % % % % % % % % % % % % % % % % % % % % %     for j=1:nGrp
% % % % % % % % % % % % % % % % % % % % % % % % %         if isempty(pfiles{j})
% % % % % % % % % % % % % % % % % % % % % % % % %             score=zeros(1,nClass);
% % % % % % % % % % % % % % % % % % % % % % % % %             p(j,:)=score;
% % % % % % % % % % % % % % % % % % % % % % % % %             continue;
% % % % % % % % % % % % % % % % % % % % % % % % %         end
% % % % % % % % % % % % % % % % % % % % % % % % %         sample=imread(pfiles{j});
% % % % % % % % % % % % % % % % % % % % % % % % %         sample=imresize(sample,[200 200]);
% % % % % % % % % % % % % % % % % % % % % % % % %         [output,score,img]=detection4(sample,{gsvm1{j} gsvm2{j}},m_filter,m_sfilter,m_cform,...
% % % % % % % % % % % % % % % % % % % % % % % % %             m_cellSize,m_blockSize,m_blockOverlap);
% % % % % % % % % % % % % % % % % % % % % % % % %         p(j,:)=score;
% % % % % % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % % % % % %     p=p.';
% % % % % % % % % % % % % % % % % % % % % % % % %     pw=computeWeightedSumScores(p);
% % % % % % % % % % % % % % % % % % % % % % % % %     [bestScore,bestIdx]=max(pw);
% % % % % % % % % % % % % % % % % % % % % % % % %     outputClass=int32(cell2mat(classes(bestIdx)));
% % % % % % % % % % % % % % % % % % % % % % % % %     percent=percent+ts;
% % % % % % % % % % % % % % % % % % % % % % % % %     waitbar(percent,h,showMsg);
% % % % % % % % % % % % % % % % % % % % % % % % %     all_p{i}=p;
% % % % % % % % % % % % % % % % % % % % % % % % %     for j=1:nGrp
% % % % % % % % % % % % % % % % % % % % % % % % %         %% Keep the same number of frame
% % % % % % % % % % % % % % % % % % % % % % % % %         if isempty(pfiles{j,i})
% % % % % % % % % % % % % % % % % % % % % % % % %             continue;
% % % % % % % % % % % % % % % % % % % % % % % % %         end
% % % % % % % % % % % % % % % % % % % % % % % % %         predictLabels=[predictLabels expected];
% % % % % % % % % % % % % % % % % % % % % % % % %         observedLabels=[observedLabels outputClass];
% % % % % % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % % % % % % % % % %     result(output)=map(output)+1;
% % % % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % %     all_predicts=[all_predicts predictLabels];
% % % % % % % % % % % % % % % % % % % % % % % % %     all_observes=[all_observes observedLabels];
% % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % close(h);
% % % % % % % % % % % % % % % % % % % % % % % % % % disp(all_p);


end




function computeConfusionMatrix(outFile,figFile,classes,classMap)
global predictLabels observedLabels;

try
    nSample=size(observedLabels,2);
    nClass=size(classes,2);
    plabels=zeros(nClass,nSample);
    olabels=zeros(nClass,nSample);
    for n=1:nSample
        oid=observedLabels(n);
        pid=predictLabels(n);
        olabels(classMap(oid),n)=1;
        plabels(classMap(pid),n)=1;
    end

catch
    whos('observedLabels');
    whos('predictLabels');
end

% disp(olabels);

confusionM=confusionmat(predictLabels,observedLabels);
save(outFile,'confusionM','plabels','olabels','predictLabels','observedLabels');
disp(confusionM);


plotconfusion(plabels,olabels);
saveas(gcf,figFile);
end

function computeOverallConfusionMatrix(outFile,figFile,classes,classMap)
global all_predicts all_observes;

nSample=size(all_observes,2);
nClass=size(classes,2);
plabels=zeros(nClass,nSample);
olabels=zeros(nClass,nSample);
for n=1:nSample
    oid=all_observes(n);
    pid=all_predicts(n);
%     whos('oid');
%     whos('pid');
    olabels(classMap(oid),n)=1;
    plabels(classMap(pid),n)=1;
end

% disp(olabels);

confusionM=confusionmat(all_predicts,all_observes);
save(outFile,'confusionM','plabels','olabels','all_predicts','all_observes');
disp(confusionM);


plotconfusion(plabels,olabels);
saveas(gcf,figFile);
end