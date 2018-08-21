function varargout = RealTimeReconition(varargin)
% REALTIMERECONITION MATLAB code for RealTimeReconition.fig
%      REALTIMERECONITION, by itself, creates a new REALTIMERECONITION or raises the existing
%      singleton*.
%
%      H = REALTIMERECONITION returns the handle to a new REALTIMERECONITION or the handle to
%      the existing singleton*.
%
%      REALTIMERECONITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REALTIMERECONITION.M with the given input arguments.
%
%      REALTIMERECONITION('Property','Value',...) creates a new REALTIMERECONITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RealTimeReconition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RealTimeReconition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RealTimeReconition

% Last Modified by GUIDE v2.5 27-Sep-2016 18:14:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RealTimeReconition_OpeningFcn, ...
                   'gui_OutputFcn',  @RealTimeReconition_OutputFcn, ...
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


% --- Executes just before RealTimeReconition is made visible.
function RealTimeReconition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RealTimeReconition (see VARARGIN)

% Choose default command line output for RealTimeReconition
handles.output = hObject;
handles.m_camLeft=0;
handles.m_camRight=0;
handles.m_camFront=0;

global m_cams m_camIndex svm svm2 m_ssvm m_ssvm2...
    m_showAsRaw m_svmLabels m_svmLabels2 m_isStarted...
    h1 h2 h2t hc m_filter m_sfilter m_cform...
    m_cellSize m_blockSize m_blockOverlap m_sampleSize m_stepSize;

m_cams=webcamlist;
m_camIndex=[1 2 3]; % order in [left front right]
m_showAsRaw=0;
m_isStarted=0;

h1=fspecial('gaussian',[15 15],10);
h2=fspecial('log',[9 9],.2);
h2t=transpose(h2);
hc=fspecial('log',[5 5],0.9);
m_sfilter=fspecial('gaussian',[9 9],9);
m_filter={h1};
m_cform=makecform('srgb2lab');
m_ssvm=[];
m_ssvm2=[];
m_svmLabels=[];
m_svmLabels2=[];

m_sampleSize=[200 200];
m_cellSize=[16 16];
m_blockSize=[4 4];
m_blockOverlap=ceil(m_blockSize/2);
m_stepSize=ceil(m_sampleSize/10);

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


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RealTimeReconition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RealTimeReconition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnStart.
function btnStart_Callback(hObject, eventdata, handles)
% hObject    handle to btnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m_isStarted m_cams h1 h2 h2t hc hct detector...
    rawImg m_showAsRaw m_filter m_sfilter...
    m_cform m_camIndex m_ssvm m_ssvm2 ...
    m_cellSize m_blockSize m_blockOverlap m_sampleSize m_stepSize;

numCam=size(m_cams,1);
disp(m_cams);
if(numCam==0)
    disp('no camera is available');
    return;
end

m_isStarted=~m_isStarted;

if(m_isStarted==0)
    handles=rmfield(handles,'m_camLeft');
    if(numCam>1)
        handles=rmfield(handles,'m_camFront');
    end
    if(numCam>2)
        handles=rmfield(handles,'m_camRight');
    end
    guidata(hObject, handles);
else
    
    disp(size(m_cams));
    handles.m_camLeft=webcam(m_camIndex(1));
    handles.m_cam.Resolution='1280x720';
    axes(handles.camleft);
    if(numCam>1)
        handles.m_camFront=webcam(m_camIndex(2));
        handles.m_camFront.Resolution='1280x720';
        axes(handles.camfront);
    end
    if(numCam>2)
        handles.m_camRight=webcam(m_camIndex(3));
        handles.m_camRight.Resolution='1280x720';
        axes(handles.camright);
    end
    guidata(hObject, handles);
    
    %% Start Capturing
    rawImg=[];
    imageLeft=[];
    pimageLeft=[];
    imageRight=[];
    pimageRight=[];
    imageFront=[];
    pimageFront=[];
    
    functionParam={[],[],m_cellSize,m_blockSize,m_blockOverlap,...
        {m_ssvm}};
    
    start=clock;
    fps=0;
    while(true)
        if(m_isStarted==0)
            handles=rmfield(handles,'m_camLeft');
            if(numCam>1)
                handles=rmfield(handles,'m_camFront');
            end
            if(numCam>2)
                handles=rmfield(handles,'m_camRight');
            end
            guidata(hObject, handles);
            break;
        end
        %image=gpuArray(snapshot(handles.m_cam));
        imageLeft=snapshot(handles.m_camLeft);
        if(numCam>1)
            imageFront=snapshot(handles.m_camFront);
        end
        if(numCam>2)
            imageRight=snapshot(handles.m_camRight);
        end
        
        imageLeft=imresize(imageLeft,[480 640]);
        if(~isempty(imageFront))
            imageFront=imresize(imageFront,[480 640]);
        end
        if(~isempty(imageRight))
            imageRight=imresize(imageRight,[480 640]);
        end
        
        if(~isempty(m_ssvm))
            %%being detection
            [pimageLeft,edge,color]=imgProc2_rt(imageLeft,m_filter,m_sfilter,m_cform);
            functionParam{1}=edge;
            functionParam{2}=color;
            pimageLeft=slidingProcess(pimageLeft,functionParam,...
                @detectionProc,m_sampleSize,m_stepSize);
            
            axes(handles.camleft);
            imshow(pimageLeft);
            if(numCam>1)
                [pimageFront,edge,color]=imgProc2_rt(imageFront,m_filter,m_sfilter,m_cform);
                functionParam{1}=edge;
                functionParam{2}=color;
                pimageFront=slidingProcess(pimageFront,functionParam,...
                @detectionProc,m_sampleSize,m_stepSize);
                
                axes(handles.camfront);
                imshow(pimageFront);
            end
            if(numCam>2)
                [pimageRight,edge,color]=imgProc2_rt(imageRight,m_filter,m_sfilter,m_cform);
                functionParam{1}=edge;
                functionParam{2}=color;
                pimageRight=slidingProcess(pimageRight,functionParam,...
                @detectionProc,m_sampleSize,m_stepSize);
                
                axes(handles.camright);
                imshow(pimageRight);
            end
        else
            %%just image processing
            [pimageLeft,edge,color]=imgProc2_rt(imageLeft,m_filter,m_sfilter,m_cform);
            axes(handles.camleft);
            imshow(pimageLeft);
            if(numCam>1)
                [pimageFront,edge,color]=imgProc2_rt(imageFront,m_filter,m_sfilter,m_cform);
                axes(handles.camfront);
                imshow(pimageFront);
            end
            if(numCam>2)
                [pimageRight,edge,color]=imgProc2_rt(imageRight,m_filter,m_sfilter,m_cform);
                axes(handles.camright);
                imshow(pimageRight);
            end
        end
        
        
        current=clock;
        ts=etime(current,start);
        if ts>=1
            set(handles.txtFPS, 'String', sprintf('FPS:%d',fps));
            fps=0;
            start=current;
        else
            
            fps=fps+1;
        end
    end
end

% --- Executes on button press in btnStop.
function btnStop_Callback(hObject, eventdata, handles)
% hObject    handle to btnStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
