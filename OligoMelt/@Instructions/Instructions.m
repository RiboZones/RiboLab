function varargout = Instructions(varargin)
% INSTRUCTIONS M-file for Instructions.fig
%      INSTRUCTIONS by itself, creates a new INSTRUCTIONS or raises the
%      existing singleton*.
%
%      H = INSTRUCTIONS returns the handle to a new INSTRUCTIONS or the handle to
%      the existing singleton*.
%
%      INSTRUCTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INSTRUCTIONS.M with the given input arguments.
%
%      INSTRUCTIONS('Property','Value',...) creates a new INSTRUCTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Instructions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Instructions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Instructions

% Last Modified by GUIDE v2.5 08-Jul-2010 16:27:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Instructions_OpeningFcn, ...
                   'gui_OutputFcn',  @Instructions_OutputFcn, ...
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

% --- Executes just before Instructions is made visible.
function Instructions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Instructions (see VARARGIN)

% Choose default command line output for Instructions

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    gcbf=varargin{1};
%     for index = 1:2:(nargin-3),
%         if nargin-3==index, break, end
%         switch lower(varargin{index})
%          case 'title'
%           set(hObject, 'Name', varargin{index+1});
%          case 'string'
%           set(handles.text1, 'String', varargin{index+1});
%         end
%     end
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
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [GCBFPos(3)*.05+GCBFPos(1),GCBFPos(4)*.05+GCBFPos(2)];
end
FigPos(3:4)=0.9*GCBFPos(3:4);
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);


% --- Outputs from this function are returned to the command line.
function varargout = Instructions_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = hObject;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(hObject);


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
