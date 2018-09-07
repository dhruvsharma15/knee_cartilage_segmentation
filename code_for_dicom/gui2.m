function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 09-Jul-2016 07:22:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

% Choose default command line output for gui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global d;
global files;
d = uigetdir(pwd, 'Select a folder');
files = dir(d);
files=files';
set(handles.next1,'Enable','on')
set(handles.button_pan2,'Visible','on')
set(handles.button_pan1,'Visible','off')

% --- Executes on button press in next1.
function next1_Callback(hObject, eventdata, handles)
% hObject    handle to next1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)]
set(handles.select,'Visible','on')
set(handles.start,'Visible','off')
global d;
global count;
global files;
global maxFileNum;
global selImgs;
selImgs=[];
files(1)=[];
files(1)=[];
count=1;
maxFileNum=length(files);

complete=fullfile(d,files(count).name);

img = dicomread(complete);
up=90;
down=90;
left=90;
right=90;


I=img(up:size(img,1)-down,left:size(img,2)-right);
axes(handles.imgdisp)
imshow(I, []);

set(handles.done1,'Enable','on')








% --- Executes on button press in yes.
function yes_Callback(hObject, eventdata, handles)
% hObject    handle to yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yes
global d;
global count;
global files;
global maxFileNum;
global selImgs;
maxFileNum=length(files);
if (count<maxFileNum)
    
    count=count+1;
    
    complete=fullfile(d,files(count).name);
    img = dicomread(complete);
    up=90;
    down=90;
    left=90;
    right=90;


    I=img(up:size(img,1)-down,left:size(img,2)-right);
    axes(handles.imgdisp)
    imshow(I, []);
    set(handles.yes,'Value',0)
    set(handles.no,'Value',0)
else
    set(handles.yes,'Enable','off')
    set(handles.no,'Enable','off')
    set(handles.next1,'Enable','off')
end

    


% --- Executes on button press in no.
function no_Callback(hObject, eventdata, handles)
% hObject    handle to no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of no
global d;
global count;
global files;
global maxFileNum;
global selImgs;
maxFileNum=length(files);
if (count<maxFileNum)
    flag=0;
    if(get(hObject,'Value'))
        %append(selImgs,fullfile(d,files(count).name));
        files(count)=[];
        flag=1;
    end
    if (flag==0)
        count=count+1;
    end;
    
    complete=fullfile(d,files(count).name);
    img = dicomread(complete);
    up=90;
    down=90;
    left=90;
    right=90;


    I=img(up:size(img,1)-down,left:size(img,2)-right);
    axes(handles.imgdisp)
    imshow(I, []);
    set(handles.yes,'Value',0)
    set(handles.no,'Value',0)
else
    set(handles.yes,'Enable','off')
    set(handles.no,'Enable','off')
    set(handles.next1,'Enable','off')
end


% --- Executes on button press in done1.
function done1_Callback(hObject, eventdata, handles)
% hObject    handle to done1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global files;
global d;
global count2
set(handles.start,'Visible','on')
set(handles.select,'Visible','off')
set(handles.browse,'Enable','off')
set(handles.button_pan2,'Visible','off')
set(handles.button_pan1,'Visible','on')
set(handles.segment,'Enable','on')

count2=1
complete=fullfile(d,files(count2).name);
img = dicomread(complete);
up=90;
down=90;
left=90;
right=90;

I=img(up:size(img,1)-down,left:size(img,2)-right);
imshow(I,[]);
handles.original
axes(handles.original)
imshow(I, []);


% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global d;
global files;
global count2;
set(handles.segmentPanel,'Visible','on')    
if (count2<=length(files))
    complete=fullfile(d,files(count2).name);
    D_Script(complete)
    
    if true
        %code
        handles.done1
    end
    obj=handles.mrOriginal
    I=dicomread(complete);
    axes(handles.mrOriginal)
    imshow(I, []);
    %{
    wsFolder='../../WaterShed';
    baseFileName = sprintf(strcat(files(count2).name,'ws.png')); % e.g. "1.png"
    fullFileName = fullfile(wsFolder, baseFileName);
    I2=imread(fullFileName);
    axes(handles.wsImg)
    imshow(I2, []);
    
    mask1_path='../../D';
    I3=imread(fullfile(mask1_path,strcat(files(count2).name,('wsOverlayedirtmask.png'))));
    axes(handles.irt)
    imshow(I3, []);
    
    Resultados='../../D';
    baseFileName = sprintf(strcat(files(count2).name,'wsMSLTmask.png')); % e.g. "1.png"
    fullFileName2 = fullfile(Resultados, baseFileName);
    I4=imread(fullFileName2);
    axes(handles.mslt)
    imshow(I4, []);
    
    Resultados='../../D/final';
    baseFileName = sprintf(strcat(files(count2).name,'final.png')); % e.g. "1.png"
    fullFileName = fullfile(Resultados, baseFileName);
    I5=imread(fullFileName);
    axes(handles.finalImg)
    imshow(I5, []);
    
    %}
    
    
    count2=count2+1;
else
    set(handles.segment,'Enable','off')
end
set(handles.start,'Visible','off')
%set(handles.select,'Visible','off')
set(handles.button_pan1,'Visible','off')
set(handles.button_pan3,'Visible','on')
set(handles.metric,'Enable','on')





% --- Executes on button press in metric.
function metric_Callback(hObject, eventdata, handles)
% hObject    handle to metric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.segmentPanel,'Visible','off')
set(handles.resultPanel,'Visible','on')
set(handles.next2,'Enable','on')




% --- Executes on button press in next2.
function next2_Callback(hObject, eventdata, handles)
% hObject    handle to next2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global count2;
global files;
global d;
if (count2 <= length(files))
    complete=fullfile(d,files(count2).name);
    img = dicomread(complete);
    up=90;
    down=90;
    left=90;
    right=90;
    count2=count2+1;

    I=img(up:size(img,1)-down,left:size(img,2)-right);
    axes(handles.original)
    imshow(I, []);
    set(handles.resultPanel,'Visible','off')
    set(handles.start,'Visible','on')
    set(handles.button_pan3,'Visible','off')
    set(handles.button_pan1,'Visible','on')
else
    set(handles.next2,'Enable','off')
end



% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)

% --- Executes on button press in home2.
function home2_Callback(hObject, eventdata, handles)
% hObject    handle to home2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'Visible','on')
set(handles.select,'Visible','off')
set(handles.button_pan2,'Visible','off')
set(handles.button_pan1,'Visible','on')


% --- Executes on button press in home1.
function home1_Callback(hObject, eventdata, handles)
% hObject    handle to home1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'Visible','on')
set(handles.select,'Visible','off')
set(handles.button_pan2,'Visible','off')
set(handles.button_pan1,'Visible','on')


% --- Executes on button press in gtmarking.
function gtmarking_Callback(hObject, eventdata, handles)
% hObject    handle to gtmarking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in next2.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to next2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in metric.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to metric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exit.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
