function varargout = ErrorBoxGUI(varargin)
% ERRORBOXGUI M-file for ErrorBoxGUI.fig
%      ERRORBOXGUI by itself, creates a new ERRORBOXGUI or raises the
%      existing singleton*.
%
%      H = ERRORBOXGUI returns the handle to a new ERRORBOXGUI or the handle to
%      the existing singleton*.
%
%      ERRORBOXGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERRORBOXGUI.M with the given input arguments.
%
%      ERRORBOXGUI('Property','Value',...) creates a new ERRORBOXGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ErrorBoxGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ErrorBoxGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ErrorBoxGUI

% Last Modified by GUIDE v2.5 12-Jul-2010 15:30:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ErrorBoxGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ErrorBoxGUI_OutputFcn, ...
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

% --- Executes just before ErrorBoxGUI is made visible.
function ErrorBoxGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ErrorBoxGUI (see VARARGIN)

% Choose default command line output for ErrorBoxGUI
handles.output = 'Yes';

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
            case 'title'
                set(hObject, 'Name', varargin{index+1});
            case 'string'
                set(handles.errortext, 'String', varargin{index+1});
            case 'gcbfpos'
                GCBFPos=varargin{index+1};
                handles.gcbf=GCBFPos;
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    if ~exist('GCBFPos','var')
        GCBFOldUnits = get(gcbf,'Units');
        set(gcbf,'Units','pixels');
        GCBFPos = get(gcbf,'Position');
        set(gcbf,'Units',GCBFOldUnits);
    end
    FigPos(1:2) = [(GCBFPos(3)-FigWidth)*rand(), (GCBFPos(4)-FigHeight)*rand()];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);
handles.gcbf=GCBFPos;  
guidata(hObject, handles);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat

IconData=errorIconData;
errorIconMap(256,:) = get(handles.figure1, 'Color');
IconCMap=errorIconMap;

Img=image(IconData, 'Parent', handles.axes1);
set(handles.figure1, 'Colormap', IconCMap);

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       , ...
    'XLim'   , get(Img,'XData'), ...
    'YLim'   , get(Img,'YData')  ...
    );

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes ErrorBoxGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ErrorBoxGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiwait(hObject);
end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject,'CurrentKey'),'c')
    uiresume(handles.figure1);
end    



% Check for "enter" or "escape"
% if isequal(get(hObject,'CurrentKey'),'escape')
%     % User said no by hitting escape
%     handles.output = 'No';
%     
%     % Update handles structure
%     guidata(hObject, handles);
%     
%     uiresume(handles.figure1);
% end    
%     
% if isequal(get(hObject,'CurrentKey'),'return')
%     uiresume(handles.figure1);
% end    


% --- Executes on button press in OKbutton.
function OKbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OKbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GCBFPos=handles.gcbf;
ErrorBoxGUI('title','User Error','string',['Please do not hit OK buttons',...
    'without reading the dialog box.'],'gcbfpos',GCBFPos)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
