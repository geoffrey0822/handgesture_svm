function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 25-Oct-2016 17:05:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;
% Integrated with webcam or kinect
%axes(handles.CameraView);
%kinectDeviceInfo=imaqhwinfo('kinect');
%disp(kinectDeviceInfo);

% Update handles structure
handles.m_cam=0;

global m_isStarted dataset h1 h2 h2t hc hct tmpDir svm svm2 m_ssvm m_ssvm2...
    positives negatives detector capDir rawImg...
    m_showAsRaw m_filter m_sfilter m_cform m_sampleStarted...
    m_svmVector m_svmLabels m_svmVector2 m_svmLabels2 m_classNames m_camIndex ...
    m_cellSize m_blockSize m_blockOverlap m_sampleSize surfregion surfSize;

surfregion=[];
surfSize=0;
m_classNames={};
m_sampleSize=[200 200];
m_cellSize=[16 16];
m_blockSize=[4 4];
m_blockOverlap=ceil(m_blockSize/2);

% % svm=templateSVM('Standardize',0,'KernelFunction','linear',...
% %     'GapTolerance',1e-2,'BoxConstraint',1,'OutlierFraction',.1,...
% %     'KernelOffset',1e-4,'KernelScale',1,...
% %     'DeltaGradientTolerance',1e-8,'IterationLimit',1e1,...
% %     'KKTTolerance',1e-8,'Nu',.1);
% % 
% % svm2=templateSVM('Standardize',0,'KernelFunction','linear',...
% %     'GapTolerance',1e-2,'BoxConstraint',1,'OutlierFraction',.1,...
% %     'KernelOffset',1e-4,'KernelScale',1,...
% %     'DeltaGradientTolerance',1e-8,'IterationLimit',1e1,...
% %     'KKTTolerance',1e-8,'Nu',.1);


svm=templateSVM('Standardize',0,'KernelFunction','rbf',...
    'GapTolerance',1e-2,'BoxConstraint',4,'OutlierFraction',.1,...
    'KernelOffset',1e-4,'KernelScale',3,...
    'DeltaGradientTolerance',1e-8,'IterationLimit',1e4,...
    'KKTTolerance',1e-8,'Nu',.1);

svm2=templateSVM('Standardize',0,'KernelFunction','rbf',...
    'GapTolerance',1e-2,'BoxConstraint',4,'OutlierFraction',.1,...
    'KernelOffset',1e-4,'KernelScale',3,...
    'DeltaGradientTolerance',1e-8,'IterationLimit',1e4,...
    'KKTTolerance',1e-8,'Nu',.1);

m_camIndex=1;

m_showAsRaw=0;
m_isStarted=0;
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
% h2=[-1 0 1
%     -4 1 4
%     -1 0 1];
% h2=h2/1.4;
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

if(~exist(tmpDir,'dir'))
    mkdir(tmpDir);
end
fileattrib(tmpDir,'+w');
addpath(tmpDir);

if(~exist(capDir,'dir'))
    mkdir(capDir);
end
fileattrib(capDir,'+w');
addpath(capDir);

% load('datasetSVM_New2.mat');

% load('datasetHand1_3_MultipleSVM_light1.mat');

guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Initial At Begin
result=dir(fullfile('./','*.xml'));
xmls={result(~[result.isdir]).name};
set(handles.lstExistedDetector,'String',xmls);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_isStarted h1 h2 h2t hc hct detector...
    rawImg m_showAsRaw m_filter m_sfilter...
    m_cform m_camIndex m_ssvm m_ssvm2 ...
    m_cellSize m_blockSize m_blockOverlap;
txt='Yes';
m_isStarted=~m_isStarted;
mask=[];
tmpImg=[];
green=zeros(480,640,3);
green(:,:,2)=1;
% detectionWin=zeros(200,200);
detectionWin=zeros(300,300);
detectionOverlap=size(detectionWin)/1;
slideX=fix(640/detectionOverlap(2));
slideY=fix(480/detectionOverlap(1));
detectionSlide=[slideY slideX];

if(m_isStarted==0)
    handles=rmfield(handles,'m_cam');
    guidata(hObject, handles);
    txt='No';
else
    handles.m_cam=webcam(m_camIndex);
%     handles.m_cam=webcam(m_camIndex,'WhiteBalanceMode','manual','BacklightCompensation',1);
    if(m_camIndex==2)
        disp('usb Cam');
        handles.m_cam.ExposureMode='manual';
        handles.m_cam.Exposure=-10;
        handles.m_cam.WhiteBalance=6500;
    else
        
%         handles.m_cam.WhiteBalance=6000;
    end
%     handles.m_cam.Resolution='640x480';
      handles.m_cam.Resolution='1280x1024';
%     handles.m_cam.Brightness=0;
% %     handles.m_cam.Hue=10;
%     handles.m_cam.Saturation=40;
%     handles.m_cam.WhiteBalance=5000;
%     handles.m_cam.WhiteBalance=6000;
    guidata(hObject, handles);
    %h3=fspecial('laplacian',0.9);
    ind=0;
    axes(handles.CameraView);
    rawImg=[];
    while(true)
        if(m_isStarted==0)
            handles=rmfield(handles,'m_cam');
            guidata(hObject, handles);
            break;
        end
        %image=gpuArray(snapshot(handles.m_cam));
        image=snapshot(handles.m_cam);
        image=imresize(image,[480 640]);
        
        % Filtering
%         if(~isempty(rawImg))
%             image=intensityNormalize(image,rawImg);
%         end
        rawImg=image;
        
%         mask=segmentationRange(applycform(image,m_cform),[0 130 80],[256 190 210]);
%         img=combineWithMask(rawImg,mask);
%         BW=imgProc(img,m_filter);
%         img=imgProc(image,m_filter);
%         img=applycform(img,m_cform);

        if(get(handles.chkDetection,'Value') && ~isempty(m_ssvm))
%             img=detection(image,m_ssvm,m_filter,m_sfilter,m_cform,detectionWin,...
%                 detectionSlide,detectionOverlap,m_cellSize,m_blockSize,m_blockOverlap,m_showAsRaw);
%             img=detection2(image,{m_ssvm m_ssvm2},m_filter,m_sfilter,m_cform,detectionWin,...
%                 detectionSlide,detectionOverlap,m_cellSize,m_blockSize,m_blockOverlap,m_showAsRaw);
            img=detection3_rt(image,{m_ssvm m_ssvm2},m_filter,m_sfilter,m_cform,...
            m_cellSize,m_blockSize,m_blockOverlap,detectionWin,...
                detectionSlide,detectionOverlap,m_showAsRaw);
        else
            img=imgProc2(image,m_filter,m_sfilter,m_cform);
%             img=image;
            if(m_showAsRaw)
                img=image;
            end
        end
        %% Display Image
        imshow(img);
        %%
        %hold on;
        %plot(hogVisual);
        pause(0.001);
        ind=1;
%         break;
    end
end
% msgbox(txt);


% --- Executes on button press in btnLoadImgs.
function btnLoadImgs_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadImgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lstImages,'value',[]);
folder=uigetdir('./');
[files,folder]=getDirInfos(folder);
%disp(files);
set(handles.lstImages,'String',files);

% --- Executes on button press in btnTrain.
function btnTrain_Callback(hObject, eventdata, handles)
% hObject    handle to btnTrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global positives negatives;
trainCascadeObjectDetector('handDetector.xml',positives,negatives,...
    'NumCascadeStages',10,'FalseAlarmRate',0.5,'FeatureType','Haar');


function txtLabel_Callback(hObject, eventdata, handles)
% hObject    handle to txtLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLabel as text
%        str2double(get(hObject,'String')) returns contents of txtLabel as a double


% --- Executes during object creation, after setting all properties.
function txtLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on btnTrain and none of its controls.
function btnTrain_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to btnTrain (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on btnLoadImgs and none of its controls.
function btnLoadImgs_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to btnLoadImgs (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in lstImages.
function lstImages_Callback(hObject, eventdata, handles)
% hObject    handle to lstImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lstImages contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstImages
global m_filter m_isStarted m_cform m_sfilter m_cellSize m_blockSize m_blockOverlap;
file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');
if(size(selected,2)==1)
    sample=imread(file{selected});
    [sample,shape,segment]=imgProc2(sample,m_filter,m_sfilter,m_cform);
    
    maxAmp=2^20;
    shapeAmp=2^16;
    %[featVect,visual]=getFeatures(sample);
    
    %axes(handles.axesGraph);
    %plot(featVect);
    if(m_isStarted)
        axes(handles.axesPreview);
    else
        axes(handles.CameraView);
    end
    imshow(sample);
    
    axes(handles.axesGraph);
    HsR=fft2(segment(:,:,1));
    HsR=fftshift(HsR);
    HsR=abs(HsR)/maxAmp;
    
    HsG=fft2(segment(:,:,2));
    HsG=fftshift(HsG);
    HsG=abs(HsG)/maxAmp;
    
    HsB=fft2(segment(:,:,3));
    HsB=fftshift(HsB);
    HsB=abs(HsB)/maxAmp;
    
    HsS=fft2(shape);
    HsS=fftshift(HsS);
    HsS=abs(HsS)/shapeAmp;
    
    Hs=[HsR/maxAmp HsG/maxAmp HsB/maxAmp HsS/shapeAmp];
    Hs1d=Hs(:)';
    signals=getFeatureVector(segment,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
%     L=size(signals,2);
%     Px=0:1:L-1;
%     plot(Px,signals);
    
    
%     plot(Px,vec(1,:));
%     ylim([0 1]);
end

% --- Executes during object creation, after setting all properties.
function lstImages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnPositive.
function btnPositive_Callback(hObject, eventdata, handles)
% hObject    handle to btnPositive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_filter positives tmpDir m_cform m_sfilter;
file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');
i=size(positives,1);

hh=waitbar(0,'Importing for positives...');
ts=1/size(selected,2);
percent=0;
if(size(selected,2)==1)
    sample=imread(file{selected});
    sample=imgProc2(sample,m_filter,m_sfilter,m_cform);
    outName=strcat(tmpDir,'/fp',datestr(now,'mmddyyyyHHMMSS'),'_',int2str(i),'.jpg');
    imwrite(sample,outName);
    [w,h,dim]=size(sample);
    vec=struct('imageFilename',outName,'objectBoundingBoxes',[1 1 h w]);
    positives=[positives;vec];
    disp('Positive is added');
else
    m=1;
    while(m<=size(selected,2))
        sample=imread(file{m});
        sample=imgProc2(sample,m_filter,m_sfilter,m_cform);
        outName=strcat(tmpDir,'/fp',datestr(now,'mmddyyyyHHMMSS'),'_',int2str(i),'.jpg');
        imwrite(sample,outName);
        %[featVect,visual]=getFeatures(sample);
        [w,h,dim]=size(sample);
        vec=struct('imageFilename',outName,'objectBoundingBoxes',[1 1 h w]);
        positives=[positives;vec];
        m=m+1;
        i=i+1;
        percent=percent+ts;
        waitbar(percent,hh,'Importing for positives...');
    end
    disp('Positives are added');
end
waitbar(1,hh,'Negatives are imported...');
close(hh);

% --- Executes on button press in btnNegative.
function btnNegative_Callback(hObject, eventdata, handles)
% hObject    handle to btnNegative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_filter negatives tmpDir m_cform m_sfilter;
file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');
i=size(negatives,1)+1;
h=waitbar(0,'Importing for negatives...');
ts=1/size(selected,2);
percent=0;
if(size(selected,2)==1)
    sample=imread(file{selected});
    sample=imgProc2(sample,m_filter,m_sfilter,m_cform);
    outName=strcat(tmpDir,'/fn',datestr(now,'mmddyyyyHHMMSS'),'_',int2str(i),'.jpg');
    imwrite(sample,outName);
    negatives{i,1}=outName;
    disp('Negative is added');
else
    m=1;
    
    while(m<=size(selected,2))
        sample=imread(file{m});
        sample=imgProc2(sample,m_filter,m_sfilter,m_cform);
        outName=strcat(tmpDir,'/fn',datestr(now,'mmddyyyyHHMMSS'),'_',int2str(i),'.jpg');
        imwrite(sample,outName);
        negatives{i,1}=outName;
        m=m+1;
        i=i+1;
        percent=percent+ts
        waitbar(percent,h,'Importing for negatives...');
    end
    disp('Negatives are added');
end
waitbar(1,h,'Negatives are imported...');
close(h);


% --- Executes on button press in btnCombineImg.
function btnCombineImg_Callback(hObject, eventdata, handles)
% hObject    handle to btnCombineImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_filter tmpDir;
file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');
outName=strcat(tmpDir,'/c_.jpg');
merged=[];
if(size(selected,2)>1)
    m=1;
    k=1;
    while(m<=size(selected,2))
        sample=imread(file{m});
        [h,w,dim]=size(sample);
        %sample=imgProc(sample,{h1});
        n=1;
        while(n<=h)
            merged(k,:)=sample(n,:)
            n=n+1;
            k=k+1;
        end
        m=m+1;
    end
    imwrite(merged,outName);
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global detector;
file=get(handles.lstExistedDetector,'string');
idx=get(handles.lstExistedDetector,'value');
detector=vision.CascadeObjectDetector(file{idx});
detector.MergeThreshold=25;
%detector=vision.CascadeObjectDetector('FrontalFaceLBP');

% --- Executes on button press in chkDetection.
function chkDetection_Callback(hObject, eventdata, handles)
% hObject    handle to chkDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkDetection


% --- Executes on selection change in lstExistedDetector.
function lstExistedDetector_Callback(hObject, eventdata, handles)
% hObject    handle to lstExistedDetector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lstExistedDetector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstExistedDetector


% --- Executes during object creation, after setting all properties.
function lstExistedDetector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstExistedDetector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnCapture.
function btnCapture_Callback(hObject, eventdata, handles)
% hObject    handle to btnCapture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global capDir rawImg;
%img=getimage(handles.CameraView);
img=rawImg;
imwrite(img,strcat(capDir,'/',datestr(now,'mmddyyyyHHMMSS'),'.jpg'));


% --- Executes on button press in btnVideo2Img.
function btnVideo2Img_Callback(hObject, eventdata, handles)
% hObject    handle to btnVideo2Img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global capDir m_filter m_sfilter;

%% ROI Setting
roiStr=inputdlg('Enter ROI:','ROI for all frames',1,{'0 0 200 200'});
roi=0;
if(~isempty(roiStr))
   roi=str2num(roiStr{1}); 
end
%%

[file,path]=uigetfile('./*.avi');
folder=uigetdir('./');
set(handles.btnVideo2Img,'enable','off');
withFilter=questdlg('Apply Filter for Images?','Apply Filter for Images');

h=waitbar(0,'Exporting...');
if isequal(file,0)
   disp('User selected Cancel')
else
   filename=fullfile(path, file);
   v=VideoReader(filename);
   i=1;
   percent=i;
   while hasFrame(v)
       image=readFrame(v);
       if(strcmp(withFilter,'Yes'))
           image=imgProc2(image,m_filter,m_sfilter,m_cform);
       end
       outputName=strcat(folder,'/vout_',datestr(now,'mmddyyyyHHMMSS'),'_',int2str(i),'.jpg');
       if(roi~=0)
           image=imcrop(image,roi);
       end
       imwrite(image,outputName);
       i=i+1;
       percent=percent+.01;
       if percent>=1
           percent=.05;
       end
       waitbar(percent,h,'Exporting...');
   end
end
waitbar(1,h,'Exported');
set(handles.btnVideo2Img,'enable','on');
close(h);


% --- Executes on button press in chkRaw.
function chkRaw_Callback(hObject, eventdata, handles)
% hObject    handle to chkRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkRaw
global m_showAsRaw;
m_showAsRaw=get(handles.chkRaw,'value');


% --- Executes on button press in btnSampleStop.
function btnSampleStop_Callback(hObject, eventdata, handles)
% hObject    handle to btnSampleStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_sampleStarted;
if(m_sampleStarted)
    m_sampleStarted=0;
    handles=rmfield(handles,'m_cam');
    guidata(hObject, handles);
else
    m_sampleStarted=1;
    handles.m_cam=webcam(1);
    handles.m_cam.Resolution='640x480';
    guidata(hObject, handles);
    axes(handles.axesSampleColor);
    while(m_sampleStarted)
        image=snapshot(handles.m_cam);
        img=imcrop(image,[160,120,100,100]);
        imshow(img);
        pause(0.001);
    end
    handles=rmfield(handles,'m_cam');
    guidata(hObject, handles);
end


% --- Executes on button press in btnTrainSVM.
function btnTrainSVM_Callback(hObject, eventdata, handles)
% hObject    handle to btnTrainSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global svm m_svmLabels m_svmVector tmpDir m_cform m_sfilter m_filter m_ssvm m_classNames;
if(size(m_svmLabels,1)==0||size(m_svmVector,1)==0)
    msgbox('Please add the samples for training.');
    return;
end
% m_ssvm=fitcecoc(m_svmVector,m_svmLabels,'Learners',svm,...
%     'ClassNames',m_classNames);
set(handles.btnTrainSVM,'enable','off');
% _cvPartition=cvpartition();
m_ssvm=fitcecoc(m_svmVector,m_svmLabels,'Learners',svm,...
    'Coding','allpairs','Options',statset('UseParallel',0),...
    'Prior','empirical');
msgbox('Classicifier was trained.');
set(handles.btnTrainSVM,'enable','on');

% --- Executes on button press in btnTrainCNN.
function btnTrainCNN_Callback(hObject, eventdata, handles)
% hObject    handle to btnTrainCNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
src=imread('Shadow1.jpg');
[y,edge]=graphCutImage(src);
rgb=im2double(src);
rgb(:,:,1)=rgb(:,:,1).*y;
rgb(:,:,2)=rgb(:,:,2).*y;
rgb(:,:,3)=rgb(:,:,3).*y;
imshow(rgb);
figure;
imshow(edge);


% --- Executes on button press in chkDetectSVM.
function chkDetectSVM_Callback(hObject, eventdata, handles)
% hObject    handle to chkDetectSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkDetectSVM


% --- Executes on button press in chkDetectCNN.
function chkDetectCNN_Callback(hObject, eventdata, handles)
% hObject    handle to chkDetectCNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkDetectCNN


% --- Executes on button press in btnPositiveSVM.
function btnPositiveSVM_Callback(hObject, eventdata, handles)
% hObject    handle to btnPositiveSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_svmLabels m_svmVector m_classNames tmpDir m_cform m_sfilter m_filter ...
    m_cellSize m_blockSize m_blockOverlap;
file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');

labelInput=inputdlg({'Label for positive data:','Class Name:'});
if size(labelInput,1)==0
    msgbox('Label cannot be empty');
    return;
end
className=labelInput{2};
labelInput=str2num(labelInput{1});

h=waitbar(0,'Importing for positives...');
ts=1/size(selected,2);
percent=0;
nData=size(m_svmLabels,1); % 1 class for 1 row
i=nData+1;
if(size(selected,2)==1)
    sample=imread(file{selected});
    [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
    feature=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
    m_svmVector=[m_svmVector;feature];
    m_svmLabels=[m_svmLabels labelInput];
    m_classNames{end+1}={className};
    disp('Positive is added');
else
    m=1;
    while(m<=size(selected,2))
        sample=imread(file{m});
        [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
        feature=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
        m_svmVector=[m_svmVector;feature];
        m_svmLabels=[m_svmLabels labelInput];
        m_classNames{end+1}={className};
        m=m+1;
        percent=percent+ts;
        waitbar(percent,h,'Importing for positives...');
    end
    disp('Positves are added');
end
waitbar(1,h,'Positives are imported...');
close(h);


% --- Executes on button press in btnNegativeSVM.
function btnNegativeSVM_Callback(hObject, eventdata, handles)
% hObject    handle to btnNegativeSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_svmLabels m_svmVector m_classNames tmpDir m_cform m_sfilter m_filter ...
    m_cellSize m_blockSize m_blockOverlap;
file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');

labelInput=inputdlg({'Label for negative data:','Class Name:'});
if size(labelInput,1)==0
    msgbox('Label cannot be empty');
    return;
end
className=labelInput{2};
labelInput=str2num(labelInput{1});
h=waitbar(0,'Importing for negatives...');
ts=1/size(selected,2);
percent=0;
nData=size(m_svmLabels,1); % 1 class for 1 row
i=nData+1;
if(size(selected,2)==1)
    sample=imread(file{selected});
    [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
    feature=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
    m_svmVector=[m_svmVector;feature];
    m_svmLabels=[m_svmLabels -labelInput];
    m_classNames{end+1}={className};
    disp('Negatives is added');
else
    m=1;
    while(m<=size(selected,2))
        sample=imread(file{m});
        [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
        feature=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
        m_svmVector=[m_svmVector;feature];
        m_svmLabels=[m_svmLabels -labelInput];
        m_classNames{end+1}={className};
        m=m+1;
        percent=percent+ts;
        waitbar(percent,h,'Importing for negatives...');
    end
    disp('Negatives are added');
end
waitbar(1,h,'Negatives are imported...');
close(h);


% --- Executes on button press in btnTestSVM.
function btnTestSVM_Callback(hObject, eventdata, handles)
% hObject    handle to btnTestSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global svm m_svmLabels m_svmVector tmpDir m_cform m_sfilter m_filter m_ssvm m_classNames ...
    m_cellSize m_blockSize m_blockOverlap;
if(isempty(m_ssvm))
    msgbox('Please Train a SVM first');
    return;
end
set(handles.btnTestSVM,'enable','off');
[file,path]=uigetfile('./*.*');
filename=fullfile(path, file);
testData=imread(filename);
[testData,shape,rgb]=imgProc2(testData,m_filter,m_sfilter,m_cform);
feature=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,testData);
[output,score]=predict(m_ssvm,feature);
figure('Name','file');
imshow(testData);
msgbox(['Score Matched:' num2str(score) ' Label:' num2str(output)]);
set(handles.btnTestSVM,'enable','on');


% --- Executes on button press in btnSVMTestRange.
function btnSVMTestRange_Callback(hObject, eventdata, handles)
% hObject    handle to btnSVMTestRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global svm m_svmLabels m_svmVector tmpDir m_cform m_sfilter m_filter m_ssvm m_classNames ...
    m_cellSize m_blockSize m_blockOverlap m_ssvm2;
if(isempty(m_ssvm))
    msgbox('Please Train a SVM first');
    return;
end
set(handles.btnTestSVM,'enable','off');

file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');

resultLabels=[];
h=waitbar(0,'Importing for negatives...');
percent=0;
ts=1/size(selected,2);

statStr='';
if(size(selected,2)==1)
    sample=imread(file{selected});
%     [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
%     feature=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap);
%     [output,score]=predict(m_ssvm,feature);
    [output,score,img]=detection3(sample,{m_ssvm m_ssvm2},m_filter,m_sfilter,m_cform,...
        m_cellSize,m_blockSize,m_blockOverlap);
%     resultLabels=[resultLabels output];
    figure('Name',file{selected});
    imshow(img);
%     msgbox(num2str(score));
else
    m=1;
    keys=m_ssvm.ClassNames';
    values=zeros(1,size(keys,2));
    disp(size(keys));
    disp(size(values));
    map=containers.Map(keys,values);
    while(m<=size(selected,2))
        sample=imread(file{m});
%         [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
%         feature=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap);
%         [output,score]=predict(m_ssvm,feature,...
%             'BinaryLoss','binodeviance','PosteriorMethod','gp');
        [output,score,img]=detection3(sample,{m_ssvm m_ssvm2},m_filter,m_sfilter,m_cform,...
            m_cellSize,m_blockSize,m_blockOverlap);
        %resultLabels=[resultLabels output];
%         figure('Name',file{m});
%         imshow(img);
        imwrite(img,strcat('./result/res',num2str(m),'.jpg'));
        map(output)=map(output)+1;
        m=m+1;
        percent=percent+ts;
        waitbar(percent,h,'testing...');
    end
    total=m-1;
    for i=1:size(keys,2)
        count=map(keys(i));
        statStr=[statStr num2str(keys(i)) ':' num2str(count) '(' ...
            num2str(count*100/total,'%.2f') '%)' 10];
    end
end
waitbar(1,h,'All Testing Data are predicted...');
close(h);

% figure;
% imshow(testData);
% msgbox(['Label:' 10 num2str(resultLabels) 10 'Result Statistics:' 10 statStr]);
msgbox(['Result Statistics:' 10 statStr]);
set(handles.btnTestSVM,'enable','on');


% --- Executes on button press in btnResizeImage.
function btnResizeImage_Callback(hObject, eventdata, handles)
% hObject    handle to btnResizeImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_svmLabels m_svmVector m_classNames tmpDir m_cform m_sfilter m_filter ...
    m_cellSize m_blockSize m_blockOverlap m_sampleSize;
file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');

labelInput=inputdlg({'Output Size[H W]:'});

outputSize=str2num(labelInput{:});

folder=uigetdir('./');
% outputName=strcat(folder,'/vout_',datestr(now,'mmddyyyyHHMMSS'),'_',int2str(i),'.jpg');
h=waitbar(0,'Resizing images...');
ts=1/size(selected,2);
percent=0;
nData=size(m_svmLabels,1); % 1 class for 1 row
i=nData+1;
if(size(selected,2)==1)
    sample=imread(file{selected});
    sample=imresize(sample,m_sampleSize);
    outputName=strcat(folder,'/vout_',datestr(now,'mmddyyyyHHMMSS'),'_',int2str(i),'.jpg');
    imwrite(sample,outputName);
else
    m=1;
    while(m<=size(selected,2))
        sample=imread(file{m});
        sample=imresize(sample,[outputSize(1) outputSize(2)]);
        outputName=strcat(folder,'/vout_',datestr(now,'mmddyyyyHHMMSS'),'_',int2str(m),'.jpg');
        imwrite(sample,outputName);
        m=m+1;
        percent=percent+ts;
        waitbar(percent,h,'Resizing images...');
    end
end
waitbar(1,h,'Images are resized...');
close(h);


% --- Executes on button press in btnSwitchCam.
function btnSwitchCam_Callback(hObject, eventdata, handles)
% hObject    handle to btnSwitchCam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_isStarted h1 h2 h2t hc hct detector...
    rawImg m_showAsRaw m_filter m_sfilter...
    m_cform m_camIndex m_ssvm ...
    m_cellSize m_blockSize m_blockOverlap m_sampleSize;
txt='Yes';
m_isStarted=~m_isStarted;
mask=[];
tmpImg=[];
green=zeros(480,640,3);
green(:,:,2)=1;
detectionWin=zeros(m_sampleSize(2),m_sampleSize(1));
detectionOverlap=size(detectionWin)/1;
slideX=fix(640/detectionOverlap(2));
slideY=fix(480/detectionOverlap(1));
detectionSlide=[slideY slideX];

if(m_camIndex==1)
    m_camIndex=2;
else
    m_camIndex=1;
end

if(m_isStarted==0)
    handles=rmfield(handles,'m_cam');
    guidata(hObject, handles);
    txt='No';
else
    handles.m_cam=webcam(m_camIndex);
%     handles.m_cam=webcam(m_camIndex,'WhiteBalanceMode','manual','BacklightCompensation',1);
    if(m_camIndex==2)
        disp('usb Cam');
        handles.m_cam.ExposureMode='manual';
        handles.m_cam.Exposure=0;
        handles.m_cam.WhiteBalance=6500;
    else
        
    end
    handles.m_cam.Resolution='640x480';
    guidata(hObject, handles);
    axes(handles.CameraView);
    rawImg=[];
    while(true)
        if(m_isStarted==0)
            handles=rmfield(handles,'m_cam');
            guidata(hObject, handles);
            break;
        end
        image=snapshot(handles.m_cam);
        rawImg=image;
        
        if(get(handles.chkDetection,'Value') && ~isempty(m_ssvm))
            img=detection(image,m_ssvm,m_filter,m_sfilter,m_cform,detectionWin,...
                detectionSlide,detectionOverlap,m_cellSize,m_blockSize,m_blockOverlap,m_showAsRaw);
        else
            img=imgProc2(image,m_filter,m_sfilter,m_cform);
            if(m_showAsRaw)
                img=image;
            end
        end
        %% Display Image
        imshow(img);
        %%
        pause(0.001);
        ind=1;
    end
end


% --- Executes on button press in btnSamBigImage.
function btnSamBigImage_Callback(hObject, eventdata, handles)
% hObject    handle to btnSamBigImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global capDir m_filter m_sfilter m_sampleSize;
[file,path]=uigetfile('./*.avi');
folder=uigetdir('./');
set(handles.btnVideo2Img,'enable','off');
withFilter=questdlg('Apply Filter for Images?','Apply Filter for Images');
h=waitbar(0,'Exporting...');
if isequal(file,0)
   disp('User selected Cancel')
else
   filename=fullfile(path, file);
   v=VideoReader(filename);
   i=1;
   percent=i;
   n=0;
   while hasFrame(v)
       image=readFrame(v);
       if(strcmp(withFilter,'Yes'))
           image=imgProc2(image,m_filter,m_sfilter,m_cform);
       end
       samples=ImageSlideSampling(image,[m_sampleSize(1);m_sampleSize(2)],...
           [m_sampleSize(1);m_sampleSize(2)]);
       n=size(samples,2);
       for nc=1:n
           outputName=strcat(folder,'/vout_',datestr(now,'mmddyyyyHHMMSS'),'_',int2str(i),...
               '_',int2str(nc),'.jpg');
           imwrite(samples{nc},outputName);
       end
       i=i+1;
       percent=percent+.01;
       if percent>=1
           percent=.05;
       end
       waitbar(percent,h,'Exporting...');
   end
end
waitbar(1,h,'Exported');
set(handles.btnVideo2Img,'enable','on');
close(h);


% --- Executes on button press in btnTrainSVMS.
function btnTrainSVMS_Callback(hObject, eventdata, handles)
% hObject    handle to btnTrainSVMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global svm svm2 m_svmLabels m_svmVector m_svmLabels2 m_svmVector2...
    tmpDir m_cform m_sfilter m_filter m_ssvm m_ssvm2 m_classNames;
if(size(m_svmLabels,1)==0||size(m_svmVector,1)==0)
    msgbox('Please add the samples for training.');
    return;
end
% m_ssvm=fitcecoc(m_svmVector,m_svmLabels,'Learners',svm,...
%     'ClassNames',m_classNames);
set(handles.btnTrainSVM,'enable','off');
% _cvPartition=cvpartition();
m_ssvm=fitcecoc(m_svmVector,m_svmLabels,'Learners',svm,...
    'Coding','allpairs','Options',statset('UseParallel',0),...
    'Prior','empirical');
m_ssvm2=fitcecoc(m_svmVector2,m_svmLabels2,'Learners',svm,...
    'Coding','allpairs','Options',statset('UseParallel',0),...
    'Prior','empirical');

% save('./TrainedSVMs/02102016/test1.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test2.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test3.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test4.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test5.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test6.mat','m_ssvm','m_ssvm2');

% save('./TrainedSVMs/02102016/test1b.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test2b.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test3b.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test4b.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test5b.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test6b.mat','m_ssvm','m_ssvm2');

% save('./TrainedSVMs/02102016/test1c.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test2c.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test3c.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test4c.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test5c.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test6c.mat','m_ssvm','m_ssvm2');

% save('./TrainedSVMs/02102016/test1c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test2c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test3c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test4c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test5c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test6c_front.mat','m_ssvm','m_ssvm2');

% save('./TrainedSVMs/02102016/test1c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test2c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test3c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test4c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test5c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test6c_left.mat','m_ssvm','m_ssvm2');

% save('./TrainedSVMs/02102016/test1c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test2c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test3c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test4c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test5c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/02102016/test6c_right.mat','m_ssvm','m_ssvm2');

% save('./TrainedSVMs/13102016/test1c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test2c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test3c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test4c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test5c_front.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test6c_front.mat','m_ssvm','m_ssvm2');

% save('./TrainedSVMs/13102016/test1c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test2c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test3c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test4c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test5c_left.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test6c_left.mat','m_ssvm','m_ssvm2');

% save('./TrainedSVMs/13102016/test1c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test2c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test3c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test4c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test5c_right.mat','m_ssvm','m_ssvm2');
% save('./TrainedSVMs/13102016/test6c_right.mat','m_ssvm','m_ssvm2');

% save('./TrainedSVMs/02102016/test4c_front_self.mat','m_ssvm','m_ssvm2');

msgbox('Classicifier was trained.');
set(handles.btnTrainSVM,'enable','on');


% --- Executes on button press in btnPositivesNVector.
function btnPositivesNVector_Callback(hObject, eventdata, handles)
% hObject    handle to btnPositivesNVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_svmLabels m_svmVector m_svmLabels2 m_svmVector2 m_classNames tmpDir m_cform m_sfilter m_filter ...
    m_cellSize m_blockSize m_blockOverlap;
file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');

labelInput=inputdlg({'Label for positive data:','Class Name:'});
if size(labelInput,1)==0
    msgbox('Label cannot be empty');
    return;
end
className=labelInput{2};
labelInput=str2num(labelInput{1});

h=waitbar(0,'Importing for positives...');
ts=1/size(selected,2);
percent=0;
nData=size(m_svmLabels,1); % 1 class for 1 row
i=nData+1;
if(size(selected,2)==1)
    sample=imread(file{selected});
    
    rSamples=rotateResample(sample);
    for i=1:size(rSamples,2);
        sample=rSamples{i};
        
        [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
        [feature,~,featColor,featShape]=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
        m_svmVector=[m_svmVector;featColor];
        m_svmVector2=[m_svmVector2;featShape];
        m_svmLabels=[m_svmLabels labelInput];
        m_svmLabels2=[m_svmLabels2 labelInput];
        m_classNames{end+1}={className};
    
    end
    
    disp('Positive is added');
else
    m=1;
    while(m<=size(selected,2))
        sample=imread(file{m});
        
        rSamples=rotateResample(sample);
        for i=1:size(rSamples,2);
            sample=rSamples{i};
        
            [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
            [feature,~,featColor,featShape]=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
            m_svmVector=[m_svmVector;featColor];
            m_svmVector2=[m_svmVector2;featShape];
            m_svmLabels=[m_svmLabels labelInput];
            m_svmLabels2=[m_svmLabels2 labelInput];
            m_classNames{end+1}={className};
        
        end
        
        m=m+1;
        percent=percent+ts;
        waitbar(percent,h,'Importing for positives...');
    end
    disp('Positves are added');
end
waitbar(1,h,'Positives are imported...');
close(h);

% --- Executes on button press in btnNegativesNVector.
function btnNegativesNVector_Callback(hObject, eventdata, handles)
% hObject    handle to btnNegativesNVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_svmLabels m_svmVector m_svmVector2 m_svmLabels2 m_classNames tmpDir m_cform m_sfilter m_filter ...
    m_cellSize m_blockSize m_blockOverlap;
file=get(handles.lstImages,'string');
selected=get(handles.lstImages,'value');

% labelInput=inputdlg({'Label for negative data:','Class Name:'});
% if size(labelInput,1)==0
%     msgbox('Label cannot be empty');
%     return;
% end
% className=labelInput{2};
% labelInput=str2num(labelInput{1});
className='n';
h=waitbar(0,'Importing for negatives...');
ts=1/size(selected,2);
percent=0;
nData=size(m_svmLabels,1); % 1 class for 1 row
i=nData+1;
if(size(selected,2)==1)
    sample=imread(file{selected});
    [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
    [feature,~,featColor,featShape]=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
    m_svmVector=[m_svmVector;featColor];
    m_svmVector2=[m_svmVector2;featShape];
    m_svmLabels=[m_svmLabels -1];
    m_svmLabels2=[m_svmLabels2 -1];
    m_classNames{end+1}={className};
    disp('Negatives is added');
else
    m=1;
    while(m<=size(selected,2))
        sample=imread(file{m});
        [sample,shape,rgb]=imgProc2(sample,m_filter,m_sfilter,m_cform);
        [feature,~,featColor,featShape]=getFeatureVector(rgb,shape,m_cellSize,m_blockSize,m_blockOverlap,sample);
        m_svmVector=[m_svmVector;featColor];
        m_svmVector2=[m_svmVector2;featShape];
        m_svmLabels=[m_svmLabels -1];
        m_svmLabels2=[m_svmLabels2 -1];
        m_classNames{end+1}={className};
        m=m+1;
        percent=percent+ts;
        waitbar(percent,h,'Importing for negatives...');
    end
    disp('Negatives are added');
end
waitbar(1,h,'Negatives are imported...');
close(h);


% --- Executes on button press in btnExportResult.
function btnExportResult_Callback(hObject, eventdata, handles)
% hObject    handle to btnExportResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xAxis=-1:1:4;
% result_pose1=[
%     43.56 33.85 36.28
%     0 0 0
%     37.6 56.59 60.41
%     13.32 4.42 .81
%     0.07 0.07 .52
%     5.45 5.08 1.99
%     ];
% result_pose2=[
%     48.71 49.89 35.54
%     0 0 0
%     2.35 3.16 8.61
%     31.20 38.41 53.79
%     7.51 2.87 0.66
%     10.23 5.67 1.4
% ];
% 
% result_pose3=[
%     49.45 45.99 42.83
%     0 0 0
%     7.36 8.61 1.18
%     19.13 7.43 9.42
%     5.67 26.05 38.85
%     18.40 11.92 7.73
% ];
% result_pose4=[
%     15.97 19.13 15.89
%     0 0 0
%     0.59 3.68 0.07
%     2.58 0.96 0.59
%     0 0 0.15
%     80.87 76.23 83.30
% ];

result_pose1=[
    33.85 36.28
    0 0
    56.59 60.41
    4.42 .81
    0.07 .52
    5.08 1.99
    ];
result_pose2=[
    49.89 35.54
    0 0
    3.16 8.61
    38.41 53.79
    2.87 0.66
    5.67 1.4
];

result_pose3=[
    45.99 42.83
    0 0
    8.61 1.18
    7.43 9.42
    26.05 38.85
    11.92 7.73
];
result_pose4=[
    19.13 15.89
    0 0
    3.68 0.07
    0.96 0.59
    0 0.15
    76.23 83.30
];

figure;
subplot(2,2,1);
bar(xAxis,result_pose1);
title('Pose 1 Prediction');
legend('2 Sets for train(Geoffrey set for test)','2 Sets for train(KC set for test)');

subplot(2,2,2);
bar(xAxis,result_pose2);
title('Pose 2 Prediction');
legend('2 Sets for train(Geoffrey set for test)','2 Sets for train(KC set for test)');

subplot(2,2,3);
bar(xAxis,result_pose3);
title('Pose 3 Prediction');
legend('2 Sets for train(Geoffrey set for test)','2 Sets for train(KC set for test)');

subplot(2,2,4);
bar(xAxis,result_pose4);
title('Pose 4 Prediction');
legend('2 Sets for train(Geoffrey set for test)','2 Sets for train(KC set for test)');


% --- Executes on button press in btnParamResult.
function btnParamResult_Callback(hObject, eventdata, handles)
% hObject    handle to btnParamResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xAxis=-1:1:4;

result_pose1=[
    36.28 59.97 31.71
    0 0 0
    60.41 32.16 62.03
    .81 2.8 1.47
    .52 4.56 3.31
    1.99 0.52 1.47
    ];
result_pose2=[
    35.54 37.67 30.68
    0 0 0
    8.61 7.06 12.95
    53.79 54.45 55.19
    0.66 0.66 0.07
    1.4 0.15 1.10
];

result_pose3=[
    42.83 50.18 41.57
    0 0 0
    1.18 0 0.15
    9.42 16.26 17.29
    38.85 32.97 35.03
    7.73 0.59 5.96
];
result_pose4=[
    15.89 42.9 24.06
    0 0 0
    0.07 .44 0.44
    0.59 1.55 1.03
    0.15 1.18 0.59
    83.30 53.94 73.88
];

figure;
subplot(2,2,1);
bar(xAxis,result_pose1);
title('Pose 1 Prediction on KC Set');
legend('param 1','param 2','param 3');

subplot(2,2,2);
bar(xAxis,result_pose2);
title('Pose 2 Prediction on KC Set');
legend('param 1','param 2','param 3');

subplot(2,2,3);
bar(xAxis,result_pose3);
title('Pose 3 Prediction on KC Set');
legend('param 1','param 2','param 3');

subplot(2,2,4);
bar(xAxis,result_pose4);
title('Pose 4 Prediction on KC Set');
legend('param 1','param 2','param 3');


% --- Executes on button press in btnLoadSetting.
function btnLoadSetting_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_svmLabels m_svmVector m_svmVector2 m_svmLabels2 m_classNames tmpDir m_cform m_sfilter m_filter ...
    m_cellSize m_blockSize m_blockOverlap;
% fname='./setting.conf';
% fname='./setting2.conf';
% fname='./setting3.conf';
% fname='./setting4.conf';

%% for new poses
% fname='./conf/setting_newpose1.conf';
% fname='./conf/setting_newpose2.conf';
% fname='./conf/setting_newpose3.conf';

% fname='./conf/setting_newpose1_noarm.conf';
% fname='./conf/setting_newpose2_noarm.conf';
% fname='./conf/setting_newpose3_noarm.conf';

% fname='./conf/setting_newpose1_dataset3.conf';
% fname='./conf/setting_newpose2_dataset3.conf';
% fname='./conf/setting_newpose3_dataset3.conf';

% fname='./conf/setting_newpose1_dataset3_ex.conf';
% fname='./conf/setting_newpose2_dataset3_ex.conf';
% fname='./conf/setting_newpose3_dataset3_ex.conf';

% fname='./conf/setting_newpose1_dataset4_ex.conf';
% fname='./conf/setting_newpose2_dataset4_ex.conf';
% fname='./conf/setting_newpose3_dataset4_ex.conf';

% fname='./conf/setting4realtimeTest.conf';

% fname='./conf/02102016/setting_1.conf';
% fname='./conf/02102016/setting_2.conf';
% fname='./conf/02102016/setting_3.conf';
% fname='./conf/02102016/setting_4.conf';
% fname='./conf/02102016/setting_5.conf';
% fname='./conf/02102016/setting_6.conf';

% fname='./conf/02102016/setting_1b.conf';
% fname='./conf/02102016/setting_2b.conf';
% fname='./conf/02102016/setting_3b.conf';
% fname='./conf/02102016/setting_4b.conf';
% fname='./conf/02102016/setting_5b.conf';
% fname='./conf/02102016/setting_6b.conf';

% fname='./conf/02102016/setting_1c.conf';
% fname='./conf/02102016/setting_2c.conf';
% fname='./conf/02102016/setting_3c.conf';
% fname='./conf/02102016/setting_4c.conf';
% fname='./conf/02102016/setting_5c.conf';
% fname='./conf/02102016/setting_6c.conf';

% fname='./conf/02102016/setting_1c_front.conf';
% fname='./conf/02102016/setting_2c_front.conf';
% fname='./conf/02102016/setting_3c_front.conf';
% fname='./conf/02102016/setting_4c_front.conf';
% fname='./conf/02102016/setting_5c_front.conf';
% fname='./conf/02102016/setting_6c_front.conf';

% fname='./conf/02102016/setting_1c_left.conf';
% fname='./conf/02102016/setting_2c_left.conf';
% fname='./conf/02102016/setting_3c_left.conf';
% fname='./conf/02102016/setting_4c_left.conf';
% fname='./conf/02102016/setting_5c_left.conf';
% fname='./conf/02102016/setting_6c_left.conf';

% fname='./conf/02102016/setting_1c_right.conf';
% fname='./conf/02102016/setting_2c_right.conf';
% fname='./conf/02102016/setting_3c_right.conf';
% fname='./conf/02102016/setting_4c_right.conf';
% fname='./conf/02102016/setting_5c_right.conf';
% fname='./conf/02102016/setting_6c_right.conf';

% fname='./conf/13102016/setting_1c_front.conf';
% fname='./conf/13102016/setting_2c_front.conf';
% fname='./conf/13102016/setting_3c_front.conf';
% fname='./conf/13102016/setting_4c_front.conf';
% fname='./conf/13102016/setting_5c_front.conf';
% fname='./conf/13102016/setting_6c_front.conf';

% fname='./conf/13102016/setting_1c_left.conf';
% fname='./conf/13102016/setting_2c_left.conf';
% fname='./conf/13102016/setting_3c_left.conf';
% fname='./conf/13102016/setting_4c_left.conf';
% fname='./conf/13102016/setting_5c_left.conf';
% fname='./conf/13102016/setting_6c_left.conf';

% fname='./conf/13102016/setting_1c_right.conf';
% fname='./conf/13102016/setting_2c_right.conf';
% fname='./conf/13102016/setting_3c_right.conf';
% fname='./conf/13102016/setting_4c_right.conf';
% fname='./conf/13102016/setting_5c_right.conf';
% fname='./conf/13102016/setting_6c_right.conf';

% fname='./conf/13102016/setting_3c_front_noNeg.conf';
% fname='./conf/13102016/setting_3c_left_noNeg.conf';
% fname='./conf/13102016/setting_3c_right_noNeg.conf';

% fname='./conf/02102016/setting_4c_front_self.conf';

[confFile,confPath]=uigetfile('./conf/13102016/*.conf');
fname=strcat(confPath,confFile);

[labels,folders,names]=loadSetting(fname);

for a=1:size(labels,2)
    
    [files,folder]=getDirInfos(folders{a});
    className='n';
    h=waitbar(0,'Importing for classes...');
    ts=1/size(files,2);
    percent=0;
    nData=size(m_svmLabels,1); % 1 class for 1 row
    i=nData+1;
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
        m_svmVector=[m_svmVector;featColor];
        m_svmVector2=[m_svmVector2;featShape];

%         m_svmVector=[m_svmVector;[featColor featShape]];

        m_svmLabels=[m_svmLabels str2num(char(labels{a}))];
        m_svmLabels2=[m_svmLabels2 str2num(char(labels{a}))];
        m_classNames{end+1}={names{a}};
        m=m+1;
        percent=percent+ts;
        waitbar(percent,h,loadingMsg);
    end
    disp('Samples are added');
    
    waitbar(1,h,strcat(names{a},' are imported...'));
    
    close(h);
end
%     save('./extractedFeatureSets/02102016/setting_1.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_2.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_3.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_4.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_5.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_6.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
    
%         save('./extractedFeatureSets/02102016/setting_1b.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_2b.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_3b.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_4b.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_5b.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_6b.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');

%     save('./extractedFeatureSets/02102016/setting_1c.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_2c.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_3c.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_4c.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_5c.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_6c.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');

%     save('./extractedFeatureSets/02102016/setting_1c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_2c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_3c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_4c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_5c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_6c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');

%     save('./extractedFeatureSets/02102016/setting_1c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_2c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_3c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_4c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_5c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_6c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');

%     save('./extractedFeatureSets/02102016/setting_1c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_2c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_3c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_4c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_5c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/02102016/setting_6c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');

%     save('./extractedFeatureSets/13102016/setting_1c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_2c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_3c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_4c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_5c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_6c_front.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');

%     save('./extractedFeatureSets/13102016/setting_1c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_2c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_3c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_4c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_5c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_6c_left.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');

%     save('./extractedFeatureSets/13102016/setting_1c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_2c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_3c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_4c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_5c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');
%     save('./extractedFeatureSets/13102016/setting_6c_right.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');

%     save('./extractedFeatureSets/02102016/setting_4c_front_self.mat','m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');


[confFile,confPath]=uiputfile('./extractedFeatureSets');
outPath=strcat(confPath,confFile);
save(outPath,'m_svmVector','m_svmVector2','m_svmLabels','m_svmLabels2');

% --- Executes on button press in btnAutoTestSVM.
function btnAutoTestSVM_Callback(hObject, eventdata, handles)
% hObject    handle to btnAutoTestSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global svm m_svmLabels m_svmVector tmpDir m_cform m_sfilter m_filter m_ssvm m_classNames ...
    m_cellSize m_blockSize m_blockOverlap m_ssvm2;
if(isempty(m_ssvm))
    msgbox('Please Train a SVM first');
    return;
end
set(handles.btnTestSVM,'enable','off');

% fname='./test_hand_1.conf';
% fname='./test_hand_2.conf';
% fname='./test_hand_3.conf';

%% for new poses
% fname='./conf/test_newpose_hand1.conf';
% fname='./conf/test_newpose_hand2.conf';
% fname='./conf/test_newpose_hand3.conf';

% fname='./conf/test_newpose_hand1_noarm.conf';
% fname='./conf/test_newpose_hand2_noarm.conf';
% fname='./conf/test_newpose_hand3_noarm.conf';

% fname='./conf/test_newpose_hand1_noarm_front.conf';
% fname='./conf/test_newpose_hand1_noarm_right.conf';
% fname='./conf/test_newpose_hand1_noarm_left.conf';
% fname='./conf/test_newpose_hand2_noarm_front.conf';
% fname='./conf/test_newpose_hand2_noarm_right.conf';
% fname='./conf/test_newpose_hand2_noarm_left.conf';
% fname='./conf/test_newpose_hand3_noarm_front.conf';
% fname='./conf/test_newpose_hand3_noarm_right.conf';
% fname='./conf/test_newpose_hand3_noarm_left.conf';

% fname='./conf/test_newpose1_dataset3.conf';
% fname='./conf/test_newpose2_dataset3.conf';
% fname='./conf/test_newpose3_dataset3.conf';

% fname='./conf/test_newpose1_dataset3_ex.conf';
% fname='./conf/test_newpose2_dataset3_ex.conf';
% fname='./conf/test_newpose3_dataset3_ex.conf';

% fname='./conf/test_newpose1_dataset4_ex.conf';
% fname='./conf/test_newpose2_dataset4_ex.conf';
% fname='./conf/test_newpose3_dataset4_ex.conf';

% fname='./conf/test_newpose1_dataset3_front.conf';
% fname='./conf/test_newpose1_dataset3_left.conf';
% fname='./conf/test_newpose1_dataset3_right.conf';
% fname='./conf/test_newpose2_dataset3_front.conf';
% fname='./conf/test_newpose2_dataset3_left.conf';
% fname='./conf/test_newpose2_dataset3_right.conf';
% fname='./conf/test_newpose3_dataset3_front.conf';
% fname='./conf/test_newpose3_dataset3_left.conf';
% fname='./conf/test_newpose3_dataset3_right.conf';

% fname='./conf/test_newpose1_dataset3_front_ex.conf';
% fname='./conf/test_newpose1_dataset3_left_ex.conf';
% fname='./conf/test_newpose1_dataset3_right_ex.conf';
% fname='./conf/test_newpose2_dataset3_front_ex.conf';
% fname='./conf/test_newpose2_dataset3_left_ex.conf';
% fname='./conf/test_newpose2_dataset3_right_ex.conf';
% fname='./conf/test_newpose3_dataset3_front_ex.conf';
% fname='./conf/test_newpose3_dataset3_left_ex.conf';
% fname='./conf/test_newpose3_dataset3_right_ex.conf';

% fname='./conf/test_newpose1_dataset4_front_ex.conf';
% fname='./conf/test_newpose1_dataset4_left_ex.conf';
% fname='./conf/test_newpose1_dataset4_right_ex.conf';
% fname='./conf/test_newpose2_dataset4_front_ex.conf';
% fname='./conf/test_newpose2_dataset4_left_ex.conf';
% fname='./conf/test_newpose2_dataset4_right_ex.conf';
% fname='./conf/test_newpose3_dataset4_front_ex.conf';
% fname='./conf/test_newpose3_dataset4_left_ex.conf';
% fname='./conf/test_newpose3_dataset4_right_ex.conf';

% fname='./conf/02102016/test_1.conf';
% fname='./conf/02102016/test_2.conf';
% fname='./conf/02102016/test_3.conf';
% fname='./conf/02102016/test_4.conf';
% fname='./conf/02102016/test_5.conf';
% fname='./conf/02102016/test_6.conf';

% fname='./conf/02102016/test_1_front.conf';
% fname='./conf/02102016/test_2_front.conf';
% fname='./conf/02102016/test_3_front.conf';
% fname='./conf/02102016/test_4_front.conf';
% fname='./conf/02102016/test_5_front.conf';
% fname='./conf/02102016/test_6_front.conf';

% fname='./conf/02102016/test_1_left.conf';
% fname='./conf/02102016/test_2_left.conf';
% fname='./conf/02102016/test_3_left.conf';
% fname='./conf/02102016/test_4_left.conf';
% fname='./conf/02102016/test_5_left.conf';
% fname='./conf/02102016/test_6_left.conf';

% fname='./conf/02102016/test_1_right.conf';
% fname='./conf/02102016/test_2_right.conf';
% fname='./conf/02102016/test_3_right.conf';
% fname='./conf/02102016/test_4_right.conf';
% fname='./conf/02102016/test_5_right.conf';
% fname='./conf/02102016/test_6_right.conf';

% fname='./conf/13102016/test_1c_front.conf';
% fname='./conf/13102016/test_2c_front.conf';
% fname='./conf/13102016/test_3c_front.conf';
% fname='./conf/13102016/test_4c_front.conf';
% fname='./conf/13102016/test_5c_front.conf';
% fname='./conf/13102016/test_6c_front.conf';

% fname='./conf/13102016/test_1c_left.conf';
% fname='./conf/13102016/test_2c_left.conf';
% fname='./conf/13102016/test_3c_left.conf';
% fname='./conf/13102016/test_4c_left.conf';
% fname='./conf/13102016/test_5c_left.conf';
% fname='./conf/13102016/test_6c_left.conf';

% fname='./conf/13102016/test_1c_right.conf';
% fname='./conf/13102016/test_2c_right.conf';
% fname='./conf/13102016/test_3c_right.conf';
% fname='./conf/13102016/test_4c_right.conf';
% fname='./conf/13102016/test_5c_right.conf';
% fname='./conf/13102016/test_6c_right.conf';

[confFile,confPath]=uigetfile('./conf/13102016/*.conf');
fname=strcat(confPath,confFile);

% fname='./conf/test_newpose_wrong.conf';

[labels,folders,names]=loadSetting(fname);
fileId=fopen('Result_2.txt','wt');

keys={-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14};
valueSet=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
target='';
total=0;
map=containers.Map(keys,valueSet);
k=1;
for i=1:size(labels,2)
%     if i==1
%         target=labels{i};
%     end
    msg='';
    labelName=names{i};
    
    [files,folder]=getDirInfos(folders{i});
    h=waitbar(0,'Importing for classes...');
    ts=1/size(files,2);
    percent=0;
    
    msg=strcat(msg,sprintf('Reconize result for %s:\n',names{i}));
    m=1;
%     disp(size(keys));
%     disp(size(values));
    
    folderName=sprintf('./result/%s',names{i});
    disp(folderName);
%     if(~exist(folderName,'dir'))
%         mkdir(folderName);
%     end
    showMsg=sprintf('testing on %s',names{i});
    while(m<=size(files,2))
        sample=imread(files{m});
        sample=imresize(sample,[200 200]);
%         [output,score,img]=detection3(sample,{m_ssvm m_ssvm2},m_filter,m_sfilter,m_cform,...
%             m_cellSize,m_blockSize,m_blockOverlap);
        [output,score,img]=detection4(sample,{m_ssvm m_ssvm2},m_filter,m_sfilter,m_cform,...
            m_cellSize,m_blockSize,m_blockOverlap);
        
%         [output,score,img]=detection32(sample,{m_ssvm m_ssvm2},m_filter,m_sfilter,m_cform,...
%             m_cellSize,m_blockSize,m_blockOverlap);
        
        imwrite(img,strcat(folderName,'/res',num2str(k),'.jpg'));
        
        map(output)=map(output)+1;
        m=m+1;
        k=k+1;
        total=total+1;
        percent=percent+ts;
        waitbar(percent,h,showMsg);
    end
%     total=m-1;
%     for i=1:size(keys,2)
%         count=map(keys(i));
%         statStr=[statStr num2str(keys(i)) ':' num2str(count) '(' ...
%             num2str(count*100/total,'%.2f') '%)' 10];
%     end
    target=labels{i};
    if((i<size(labels,2)&&~strcmp(target,labels{i+1}))||i+1>size(labels,2))
        %% Log the result for 1 class
        fprintf(fileId,'Testing Result for %s:\r\n',names{i});
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
msgbox('Result is generated.');

set(handles.btnTestSVM,'enable','on');


%%


% --- Executes on button press in btnValidation.
function btnValidation_Callback(hObject, eventdata, handles)
% hObject    handle to btnValidation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global svm m_svmLabels m_svmVector tmpDir m_cform m_sfilter m_filter m_ssvm m_classNames ...
    m_cellSize m_blockSize m_blockOverlap m_ssvm2;

if(isempty(m_ssvm))
    msgbox('Please Train a SVM first');
    return;
end
set(handles.btnValidation,'enable','off');

[confFile,confPath]=uigetfile('./conf/13102016/test_*.conf');
fname=strcat(confPath,confFile);

[labels,folders,names]=loadSetting(fname);
% fileId=fopen('Result_2.txt','wt');

keys={-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14};
valueSet=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

deserved=[];
approxmated=[];

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
    
    folderName=sprintf('./result/%s',names{i});
%     disp(folderName);
    showMsg=sprintf('testing on %s',names{i});
    while(m<=size(files,2))
        sample=imread(files{m});
        sample=imresize(sample,[200 200]);
        [output,score,img]=detection5(sample,{m_ssvm m_ssvm2},m_filter,m_sfilter,m_cform,...
            m_cellSize,m_blockSize,m_blockOverlap,i+1);
        
        imwrite(img,strcat(folderName,'/res',num2str(k),'.jpg'));
        
        map(output)=map(output)+1;
        m=m+1;
        k=k+1;
        total=total+1;
        
        
        deserved(total)=cell2mat(cellstr(labels{i}));
        approxmated(total)=output;
        
        percent=percent+ts;
        waitbar(percent,h,showMsg);
    end
    target=labels{i};
    
    
    close(h);
    
end
% fclose(fileId);
% msgbox('Confusion Matrix is generated.');

[confFile,confPath]=uiputfile('./RawResult/*.mat');
fname=strcat(confPath,confFile);
save(fname,'deserved','approxmated');

cMat=confusionmat(deserved,approxmated);
disp(cMat);

% h = gca;
% h.XTickLabel = [num2cell(labels); {''}];
% h.YTickLabel = [num2cell(labels); {''}];

set(handles.btnValidation,'enable','on');


% --- Executes on button press in btnConfuseM.
function btnConfuseM_Callback(hObject, eventdata, handles)
% hObject    handle to btnConfuseM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[confFile,confPath]=uigetfile('./RawResult/*.mat');
fname=strcat(confPath,confFile);
S=load(fname);
disp(S);

approxmated=S.approxmated;
deserved=S.deserved;
labels=unique(deserved);

plotconfusion(deserved,approxmated);
return;

[~,grpOOF] = ismember(approxmated,labels); 
nLabels=size(deserved,2);
n=numel(approxmated);
n=nLabels;
oofLabelMat = zeros(nLabels,n); 
disp(grpOOF);
idxLinear = sub2ind([nLabels n],grpOOF,(1:n)'); 
oofLabelMat(idxLinear) = 1; % Flags the row corresponding to the class 
[~,grpY] = ismember(Y,isLabels); 
YMat = zeros(nLabels,n); 
idxLinearY = sub2ind([nLabels n],grpY,(1:n)'); 
YMat(idxLinearY) = 1; 

figure;
plotconfusion(YMat,oofLabelMat);
