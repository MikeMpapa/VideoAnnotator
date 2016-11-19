function varargout = AnnotationTool(varargin)
% ANNOTATIONTOOL MATLAB code for AnnotationTool.fig
%      ANNOTATIONTOOL, by itself, creates a new ANNOTATIONTOOL or raises the existing
%      singleton*.
%
%      H = ANNOTATIONTOOL returns the handle to a new ANNOTATIONTOOL or the handle to
%      the existing singleton*.
%
%      ANNOTATIONTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANNOTATIONTOOL.M with the given input arguments.
%
%      ANNOTATIONTOOL('Property','Value',...) creates a new ANNOTATIONTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AnnotationTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AnnotationTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AnnotationTool

% Last Modified by GUIDE v2.5 09-Sep-2016 15:21:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AnnotationTool_OpeningFcn, ...
                   'gui_OutputFcn',  @AnnotationTool_OutputFcn, ...
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


% --- Executes just before AnnotationTool is made visible.
function AnnotationTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AnnotationTool (see VARARGIN)

% Choose default command line output for AnnotationTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AnnotationTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AnnotationTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PlayButton.
function PlayButton_Callback(hObject, eventdata, handles)
    
    if strcmp(handles.PlayButton.String,'PLAY')
        set(handles.PlayButton, 'String','STOP');
        axes(handles.axes3);
        shuttleAvi = VideoReader(handles.LoadButton.UserData);
    else    
        im = handles.PlayButton.UserData{1};
        imshow(im{1})
        set(handles.PlayButton, 'String','PLAY');
        handles.PauseButton.UserData = 0;
        set(handles.PauseButton, 'String','PAUSE');
        set(handles.FrameNum, 'String', 'Frame: - ');
        clear all;
        handles.PlayButton.UserData = {};
        uiwait()
    end

    
     ii = 1;
     numFrames = shuttleAvi.Duration * shuttleAvi.FrameRate;
     while hasFrame(shuttleAvi) && strcmp(handles.PlayButton.String,'STOP') 

        %mov(ii) = im2frame(readFrame(shuttleAvi));
        frame = readFrame(shuttleAvi);
        ii;
        frameList{ii} = frame;
        handles.PlayButton.UserData = {frameList,numFrames,frameList,ii};
        imshow(frame);
       % pause(0.5)        
        
        if ii  <= numFrames 
            set(handles.FrameNum, 'String', ['Frame: ' num2str(ii) ' / ' num2str(numFrames)]);
        end
        AnnotateFrame (handles,ii)
        ii = ii+1;
        
       
     end
        
     

% --- Executes on button press in PauseButton.
function PauseButton_Callback(hObject, eventdata, handles)

    if handles.PauseButton.UserData == 0
        handles.PauseButton.UserData = 1;
        set(handles.PauseButton, 'String','CONTINUE');
        uiwait()
    else
        handles.PauseButton.UserData = 0;
        set(handles.PauseButton, 'String','PAUSE');
        uiresume()
    end

    
% --- Executes on button press in NextButton.
function NextButton_Callback(hObject, eventdata, handles)
     if   length(handles.PlayButton.UserData{1}) ~= length(handles.PlayButton.UserData{3})
        handles.PauseButton.UserData = 1;
        set(handles.PauseButton, 'String','CONTINUE');
        numFrames = handles.PlayButton.UserData{2};
        frameListFull = handles.PlayButton.UserData{1};
        frameListPrev = handles.PlayButton.UserData{3};
        newframeList = frameListFull(length(frameListPrev):end);
        imshow(newframeList{1})
        set(handles.FrameNum, 'String', ['Frame: ' num2str(length(frameListPrev)+1) ' / ' num2str(numFrames)]);
        frameListPrev{end+1} = newframeList{1};
        handles.PlayButton.UserData{3} = frameListPrev;
        handles.PlayButton.UserData{4} = length(frameListPrev);
        uiwait()
     end

% --- Executes on button press in PrevButton.
function PrevButton_Callback(hObject, eventdata, handles)
        handles.PauseButton.UserData = 1;
        set(handles.PauseButton, 'String','CONTINUE');
        numFrames = handles.PlayButton.UserData{2};
        frameList = handles.PlayButton.UserData{3};
        newframeList = frameList(1:end-1);
        imshow(newframeList{end});
        set(handles.FrameNum, 'String', ['Frame: ' num2str(length(newframeList)) ' / ' num2str(numFrames)]);
        handles.PlayButton.UserData{3} = newframeList;
        handles.PlayButton.UserData{4} = length(newframeList);
        uiwait()


% --- Executes on button press in SubButton.
function SubButton_Callback(hObject, eventdata, handles)
 AnnotateFrame (handles,handles.PlayButton.UserData{4})

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)

     [FileName,FilePath ]= uigetfile();
     handles.LoadButton.UserData = fullfile(FilePath, FileName);
    
     
function AnnotateFrame (handles,frameIndex)
     global annotation;
     score = zeros(6);
     check = 0 ;    
     score(1) = get(handles.checkbox1, 'Value');
     score(2) = get(handles.checkbox2, 'Value');
     score(3) = get(handles.checkbox3, 'Value');
     score(4) = get(handles.checkbox4, 'Value');
     score(5) = get(handles.checkbox5, 'Value');
     score(6) = get(handles.checkbox6, 'Value');
     while sum(score) ~= 1
     check = 1 ;    
     score(1) = get(handles.checkbox1, 'Value');
     score(2) = get(handles.checkbox2, 'Value');
     score(3) = get(handles.checkbox3, 'Value');
     score(4) = get(handles.checkbox4, 'Value');
     score(5) = get(handles.checkbox5, 'Value');
     score(6) = get(handles.checkbox6, 'Value');
     set(handles.ErrorText, 'String','CHOOSE A UNIQUE SCORE AND PRESS CONTINUE!!!');   
     handles.PauseButton.UserData = 1;
     set(handles.PauseButton, 'String','CONTINUE');
     pause(0.5)
     end
     if check == 1
        set(handles.ErrorText, 'String','');
        FrameScore = find(score == 1);
        annotation{frameIndex} = FrameScore;
        uiwait()
     end
     FrameScore = find(score == 1);
     annotation{frameIndex} = FrameScore
     handles.SaveButon.UserData = annotation;


% --- Executes on button press in SaveButon.
function SaveButon_Callback(hObject, eventdata, handles)
filename = get(handles.saveFilename2, 'String')
tmp = handles.SaveButon.UserData;
dlmwrite(filename{1},tmp)


function saveFilename2_Callback(hObject, eventdata, handles)
% hObject    handle to saveFilename2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of saveFilename2 as text
%        str2double(get(hObject,'String')) returns contents of saveFilename2 as a double


% --- Executes during object creation, after setting all properties.
function saveFilename2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saveFilename2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % Close the video file
  % Close the figure window
  close all;
  clear all;
  clc;
