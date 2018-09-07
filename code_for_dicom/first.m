function varargout = first(varargin)
% FIRST MATLAB code for first.fig
%      FIRST, by itself, creates a new FIRST or raises the existing
%      singleton*.
%
%      H = FIRST returns the handle to a new FIRST or the handle to
%      the existing singleton*.
%
%      FIRST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRST.M with the given input arguments.
%
%      FIRST('Property','Value',...) creates a new FIRST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before first_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to first_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help first

% Last Modified by GUIDE v2.5 30-Jun-2016 17:09:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @first_OpeningFcn, ...
                   'gui_OutputFcn',  @first_OutputFcn, ...
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


% --- Executes just before first is made visible.
function first_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to first (see VARARGIN)

% Choose default command line output for first
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes first wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = first_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in browseimage.
function browseimage_Callback(hObject, eventdata, handles)
% hObject    handle to browseimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
global fn;
[fn,pn] = uigetfile ('*.*', 'E:\summers_2016\Project\knee_data');
complete= strcat(pn,fn);
%set(handles.axes1, 'string', complete);
img = dicomread(complete);
up=80;
down=80;
left=80;
right=80;


I=img(up:size(img,1)-down,left:size(img,2)-right);
axes(handles.axes1)
imshow(I, []);

%imfreehand;
% h1 = impoint;
% wait(h1);
% pos1 = h1.getPosition();
% 
% h2 = impoint;
% wait(h2);
% pos2 =h2.getPosition();


set(handles.mark_Cartilage,'Enable','on')

guidata (hObject, handles);



% --- Executes on button press in mark_Cartilage.
function mark_Cartilage_Callback(hObject, eventdata, handles)
% hObject    handle to mark_Cartilage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img2;
img2=repmat(uint8(0), [160 160]);
[x,y]=getpts(handles.axes1);
pts=[x,y];
len=size(pts,1);
img1=getimage(handles.axes1);
for i=1:len
    x=floor(pts(i,2));
    y=floor(pts(i,1));
    intensity=img1(x,y);
    img2(x,y)=255;
    th=30;
    for j=2:4
        if(img1(x-j,y)>intensity-th && img1(x-j,y)<intensity+th)
            img2(x-j,y)=255;
        end
        if(x+j<161 && img1(x+j,y)>intensity-th && img1(x+j,y)<intensity+th )
            img2(x+j,y)=255;
        end
        if(img1(x,y-j)>intensity-th && img1(x,y-j)<intensity+th)
            img2(x,y-j)=255;
        end
        if(y+j<161 && img1(x,y+j)>intensity-th && img1(x,y+j)<intensity+th )
            img2(x,y+j)=255;
        end
        if(img1(x-j,y-j)>intensity-th && img1(x-j,y-j)<intensity+th)
            img2(x-j,y-j)=255;
        end
        if(y+j<161 && img1(x-j,y+j)>intensity-th && img1(x-j,y+j)<intensity+th)
            img2(x-j,y+j)=255;
        end
        if(x+j<161 && img1(x+j,y-j)>intensity-th && img1(x+j,y-j)<intensity+th)
            img2(x+j,y-j)=255;
        end
        if(x+j<161 && y+j<161 && img1(x+j,y+j)>intensity-th && img1(x+j,y+j)<intensity+th)
            img2(x+j,y+j)=255;
        end
    
    img2(x-1,y)=255;
    img2(x+1,y)=255;
    img2(x,y-1)=255;
    img2(x,y+1)=255;
    img2(x-1,y-1)=255;
    img2(x-1,y+1)=255;
    img2(x+1,y-1)=255;
    img2(x+1,y+1)=255;
    end
    
end

set(handles.cont_marking,'Enable','on')
set(handles.browseimage,'Enable','off')
set(handles.done,'Enable','on')
axes(handles.axes2)
imshow(img2, []);




% --- Executes on button press in cont_marking.
function cont_marking_Callback(hObject, eventdata, handles)
% hObject    handle to cont_marking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img2;
[x,y]=getpts(handles.axes1);
pts=[x,y];
len=size(pts,1);
img1=getimage(handles.axes1);
for i=1:len
    x=floor(pts(i,2));
    y=floor(pts(i,1));
    intensity=img1(x,y);
    img2(x,y)=255;
    th=30;
    for j=2:4
        if(img1(x-j,y)>intensity-th && img1(x-j,y)<intensity+th)
            img2(x-j,y)=255;
        end
        if(x+j<161 && img1(x+j,y)>intensity-th && img1(x+j,y)<intensity+th )
            img2(x+j,y)=255;
        end
        if(img1(x,y-j)>intensity-th && img1(x,y-j)<intensity+th)
            img2(x,y-j)=255;
        end
        if(y+j<161 && img1(x,y+j)>intensity-th && img1(x,y+j)<intensity+th )
            img2(x,y+j)=255;
        end
        if(img1(x-j,y-j)>intensity-th && img1(x-j,y-j)<intensity+th)
            img2(x-j,y-j)=255;
        end
        if(y+j<161 && img1(x-j,y+j)>intensity-th && img1(x-j,y+j)<intensity+th)
            img2(x-j,y+j)=255;
        end
        if(x+j<161 && img1(x+j,y-j)>intensity-th && img1(x+j,y-j)<intensity+th)
            img2(x+j,y-j)=255;
        end
        if(x+j<161 && y+j<161 && img1(x+j,y+j)>intensity-th && img1(x+j,y+j)<intensity+th)
            img2(x+j,y+j)=255;
        end
    
    img2(x-1,y)=255;
    img2(x+1,y)=255;
    img2(x,y-1)=255;
    img2(x,y+1)=255;
    img2(x-1,y-1)=255;
    img2(x-1,y+1)=255;
    img2(x+1,y-1)=255;
    img2(x+1,y+1)=255;
    end
    
end

axes(handles.axes2)
imshow(img2, []);








% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fn;
global img2;
Resultados='E:\summers_2016\Project\masks';
baseFileName = sprintf(strcat(fn,'mask.png')); % e.g. "1.png"
fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now!
I=gray2rgb(img2);
imwrite(I, fullFileName);

set(handles.cont_marking,'Enable','off')
set(handles.browseimage,'Enable','on')
set(handles.mark_Cartilage,'Enable','off')
set(handles.done,'Enable','off')
