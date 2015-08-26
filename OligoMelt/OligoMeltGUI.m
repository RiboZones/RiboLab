function varargout = OligoMeltGUI(varargin)
%OLIGOMELTGUI M-file for OligoMeltGUI.fig
%      OLIGOMELTGUI, by itself, creates a new OLIGOMELTGUI or raises the existing
%      singleton*.
%
%      H = OLIGOMELTGUI returns the handle to a new OLIGOMELTGUI or the handle to
%      the existing singleton*.
%
%      OLIGOMELTGUI('Property','Value',...) creates a new OLIGOMELTGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to OligoMeltGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      OLIGOMELTGUI('CALLBACK') and OLIGOMELTGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in OLIGOMELTGUI.M with the given input
%      arguments.
%
%      *See OLIGOMELTGUI Options on GUIDE's Tools menu.  Choose "OLIGOMELTGUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OligoMeltGUI

% Last Modified by GUIDE v2.5 16-Jul-2010 17:50:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OligoMeltGUI_OpeningFcn, ...
    'gui_OutputFcn',  @OligoMeltGUI_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before OligoMeltGUI is made visible.
function OligoMeltGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for OligoMeltGUI
handles.output = hObject;
% instructions=sprintf(['The input is an Excel or CSV file. The file consists of sets of the',...
%     ' following: \n 1) A simple name ',...
%     '\n 2) Temperature data \n 3) Absorbance data \n e.g. \n ',...
%     'Drug1_up               Drug2_up\n25.0     0.123          25.0     0.128',...
%     '\n25.2     0.124          25.2     0.130']);
% set(handles.instructions,'String',instructions)
guidata(hObject, handles);

OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
mp = get(0, 'MonitorPositions');
ms=mp(end,:);
FigPos(3)=0.90*ms(3);
FigPos(4)=0.86*ms(4);
FigPos(1:2) = [0.05*ms(3)+ms(1),0.07*ms(4)+ms(2)];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);


% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen


% 
% FigPos=get(0,'DefaultFigurePosition');
% OldUnits = get(hObject, 'Units');
% set(hObject, 'Units', 'pixels');
% OldPos = get(hObject,'Position');
% FigWidth = OldPos(3);
% FigHeight = OldPos(4);
% if isempty(gcbf)
%     ScreenUnits=get(0,'Units');
%     set(0,'Units','pixels');
%     ScreenSize=get(0,'ScreenSize');
%     set(0,'Units',ScreenUnits);
% 
%     FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
%     FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
% else
%     GCBFOldUnits = get(gcbf,'Units');
%     set(gcbf,'Units','pixels');
%     GCBFPos = get(gcbf,'Position');
%     set(gcbf,'Units',GCBFOldUnits);
%     FigPos(1:2) = [GCBFPos(3)*.05+GCBFPos(1),GCBFPos(4)*.05+GCBFPos(2)];
% end
% FigPos(3:4)=0.9*GCBFPos(3:4);
% set(hObject, 'Position', FigPos);
% set(hObject, 'Units', OldUnits);

% --- Outputs from this function are returned to the command line.
function varargout = OligoMeltGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

handles.instructions=Instructions(hObject);
guidata(hObject, handles);
varargout{1} = handles.output;

% --- Executes when user attempts to close MainWindow.
function MainWindow_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MainWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ishandle(handles.instructions)
    delete(handles.instructions);
end
delete(hObject);


% --- Executes when MainWindow is resized.
function MainWindow_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to MainWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in datasetpopup.
function datasetpopup_Callback(hObject, eventdata, handles)
% hObject    handle to datasetpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns datasetpopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from datasetpopup

if isa(get(handles.output,'UserData'),'char');
    file=get(handles.output,'UserData');
else
    obj=get(handles.output,'UserData');
    file=obj.File;
end
FullRange=OligoMelt(file,get(hObject,'Value'));
FullRange(1)=floor(FullRange(1));
FullRange(2)=ceil(FullRange(2));

CurrentMinMax=[num2str(get(handles.LowerWindowL,'String')),num2str(get(handles.UpperWindowU,'String'))];

if CurrentMinMax(1) < FullRange(1)
    LowerWindow=[FullRange(1) FullRange(1)+10];
    set(handles.LowerWindowL,'String',num2str(LowerWindow(1)));
    set(handles.LowerWindowU,'String',num2str(LowerWindow(2)));
end

if CurrentMinMax(2) > FullRange(2)
    set(handles.UpperWindowU,'String',num2str(FullRange(2)));
    if str2double(get(handles.UpperWindowL,'String')) >= FullRange(2)-1
        set(handles.UpperWindowL,'String',num2str(FullRange(2)-10))
    end
end
UpdateResults(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function datasetpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function LowerWindowL_Callback(hObject, eventdata, handles)
% hObject    handle to LowerWindowL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LowerWindowL as text
%        str2double(get(hObject,'String')) returns contents of LowerWindowL
%        as a double

interval=str2double(get(handles.LowerWindowU,'String'))...
    -str2double(get(handles.LowerWindowL,'String'));
if interval < 1
    ErrorBoxGUI('Title','Warning','string',['This warning is to prevent',...
        ' MATLAB errors, due to automatic operation. To prevent it from',...
        ' happening again, be careful in the order that you change ranges.'])
    return
end
UpdateResults(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function LowerWindowL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowerWindowL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function LowerWindowU_Callback(hObject, eventdata, handles)
% hObject    handle to LowerWindowU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LowerWindowU as text
%        str2double(get(hObject,'String')) returns contents of LowerWindowU
%        as a double


interval=str2double(get(handles.LowerWindowU,'String'))...
    -str2double(get(handles.LowerWindowL,'String'));
if interval < 1
    ErrorBoxGUI('Title','Warning','string',['This warning is to prevent',...
        ' MATLAB errors, due to automatic operation. To prevent it from',...
        ' happening again, be careful in the order that you change ranges.'])
    return
end
UpdateResults(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LowerWindowU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowerWindowU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function UpperWindowL_Callback(hObject, eventdata, handles)
% hObject    handle to UpperWindowL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UpperWindowL as text
%        str2double(get(hObject,'String')) returns contents of UpperWindowL as a double


interval=str2double(get(handles.UpperWindowU,'String'))...
    -str2double(get(handles.UpperWindowL,'String'));
if interval < 1
    ErrorBoxGUI('Title','Warning','string',['This warning is to prevent',...
        ' MATLAB errors, due to automatic operation. To prevent it from',...
        ' happening again, be careful in the order that you change ranges.'])
    return
end
UpdateResults(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function UpperWindowL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UpperWindowL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function UpperWindowU_Callback(hObject, eventdata, handles)
% hObject    handle to UpperWindowU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UpperWindowU as text
%        str2double(get(hObject,'String')) returns contents of UpperWindowU as a double


interval=str2double(get(handles.UpperWindowU,'String'))...
    -str2double(get(handles.UpperWindowL,'String'));
if interval < 1
    ErrorBoxGUI('Title','Warning','string',['This warning is to prevent',...
        ' MATLAB errors, due to automatic operation. To prevent it from',...
        ' happening again, be careful in the order that you change ranges.'])
    return
end
UpdateResults(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function UpperWindowU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UpperWindowU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AnalysisRangeL_Callback(hObject, eventdata, handles)
% hObject    handle to AnalysisRangeL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalysisRangeL as text
%        str2double(get(hObject,'String')) returns contents of AnalysisRangeL as a double


interval=str2double(get(handles.AnalysisRangeU,'String'))...
    -str2double(get(handles.AnalysisRangeL,'String'));
if interval < 1
    ErrorBoxGUI('Title','Warning','string',['This warning is to prevent',...
        ' MATLAB errors, due to automatic operation. To prevent it from',...
        ' happening again, be careful in the order that you change ranges.'])
    return
end
UpdateResults(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function AnalysisRangeL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalysisRangeL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AnalysisRangeU_Callback(hObject, eventdata, handles)
% hObject    handle to AnalysisRangeU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalysisRangeU as text
%        str2double(get(hObject,'String')) returns contents of AnalysisRangeU as a double

interval=str2double(get(handles.AnalysisRangeU,'String'))...
    -str2double(get(handles.AnalysisRangeL,'String'));
if interval < 1
    ErrorBoxGUI('Title','Warning','string',['This warning is to prevent',...
        ' MATLAB errors, due to automatic operation. To prevent it from',...
        ' happening again, be careful in the order that you change ranges.'])
    return
end
UpdateResults(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function AnalysisRangeU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalysisRangeU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SmoothCheck.
function SmoothCheck_Callback(hObject, eventdata, handles)
% hObject    handle to SmoothCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SmoothCheck

% --- Executes during object creation, after setting all properties.
function MainWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in modePanel.
function modePanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in modePanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

axes(handles.ResultsAxes)
obj=get(handles.output,'UserData');
if eventdata.NewValue==handles.residualMode
    obj.theta.PlotResiduals(get(handles.methodPopup,'Value')-1,1)
end
if eventdata.NewValue==handles.DataMode
    if get(handles.methodPopup,'Value')
        obj.theta.VantHoffPlot(1)
    end
    if get(handles.methodPopup,'Value')-1
        obj.theta.NonlinearAnalysisPlot(1)
    end
end
set(handles.ResultsAxes,'ButtonDownFcn',@(hObject,eventdata)OligoMeltGUI('ResultsAxes_ButtonDownFcn',hObject,eventdata,guidata(hObject)))

% --- Executes on selection change in methodPopup.
function methodPopup_Callback(hObject, eventdata, handles)
% hObject    handle to methodPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns methodPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from methodPopup

axes(handles.ResultsAxes)
obj=get(handles.output,'UserData');
if get(hObject,'Value')==1
    if get(handles.DataMode,'Value')
        obj.theta.VantHoffPlot(1)
    else
        obj.theta.PlotResiduals(0,1)
    end
    type='linear';
end
if get(hObject,'Value')==2
   if get(handles.DataMode,'Value')
        obj.theta.NonlinearAnalysisPlot(1)
    else
        obj.theta.PlotResiduals(1,1)
   end
   type='nonlinear';
end
UpdateDisplay(obj,handles,type)
set(handles.ResultsAxes,'ButtonDownFcn',@(hObject,eventdata)OligoMeltGUI('ResultsAxes_ButtonDownFcn',hObject,eventdata,guidata(hObject)))

% --- Executes during object creation, after setting all properties.
function methodPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methodPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function instructions_Callback(hObject, eventdata, handles)
% hObject    handle to instructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Instructions(handles.MainWindow);


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=AboutOligoMelt();


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function view_Callback(hObject, eventdata, handles)
% hObject    handle to view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function viewallfigures_Callback(hObject, eventdata, handles)
% hObject    handle to viewallfigures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.Plot();
obj.theta.VantHoffFitPlot();
obj.theta.ExponentialFitPlot();
obj.theta.VantHoffPlot();
obj.theta.NonlinearAnalysisPlot();
obj.theta.PlotResiduals(0)
obj.theta.PlotResiduals(1)

% --------------------------------------------------------------------
function fileopen_Callback(hObject, eventdata, handles)
% hObject    handle to fileopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
if ~isempty(obj) && isa(obj,'char')
    file=obj;
elseif ~isempty(obj) && ~isa(obj,'char')
    file=obj.File;
else
    file='.\';
end

warning off    
[FileName,PathName] = uigetfile({'*.xls;*.xlsx;*.xlsb;*.xlsm;*.csv',...
    'Supported Files';'*.*','All files'},'Select the Excel or CSV File',...
    file);
warning on
if ~isequal(FileName,0) && ~isequal(PathName,0)
    try
        DataSetNames=OligoMelt(strcat(PathName,FileName));
        set(handles.datasetpopup,'String',DataSetNames)
        set(handles.datasetpopup,'Value',1)
        Settings.DataSetIndex=get(handles.datasetpopup,'Value');
        [~, ~] = OligoMelt(strcat(PathName,FileName),...
            get(handles.datasetpopup,'Value'));
    catch
        set(handles.datasetpopup,'String','Reload Input')
        ErrorBoxGUI('title','User Error','string',...
            'The Input is not in the proper format. Please fix it and try again.')
        return
    end
    FullRange=OligoMelt(strcat(PathName,FileName),get(handles.datasetpopup,'Value'));
    FullRange(1)=floor(FullRange(1));
    FullRange(2)=ceil(FullRange(2));
    set(handles.AnalysisRangeL,'String',num2str(FullRange(1)))
    set(handles.AnalysisRangeU,'String',num2str(FullRange(2)))    
    Windows={[FullRange(1) FullRange(1)+10], ...
        [FullRange(2)-10 FullRange(2)]};
    set(handles.LowerWindowL,'String',num2str(Windows{1}(1)))
    set(handles.LowerWindowU,'String',num2str(Windows{1}(2)))
    set(handles.UpperWindowL,'String',num2str(Windows{2}(1)))
    set(handles.UpperWindowU,'String',num2str(Windows{2}(2)))
    set(handles.settingsPanel,'Visible','on')    
    file=strcat(PathName,FileName);
    Settings.DataSetIndex=get(handles.datasetpopup,'Value');
    Settings.AnalysisRange=FullRange;
    Settings.Windows=Windows;
    set(handles.output,'UserData',file)  
    UpdateResults(hObject, eventdata, handles)
    if ~isempty(obj)
        set(handles.AnalysisRangeL,'String',num2str(floor(obj.AnalysisRange(1))))
        set(handles.AnalysisRangeU,'String',num2str(ceil(obj.AnalysisRange(2))))
    end
    set(handles.baselinePanel,'Visible','on')
    set(handles.resultsPanel,'Visible','on')
    set(handles.StatisticsPanel,'Visible','on')
    set(handles.VantHoffFit,'Visible','on')
    set(handles.ExponentialFit,'Visible','on')    
    set(handles.datasetpopup,'Visible','on')
    set(handles.datasettext,'Visible','on')
    set(handles.dg37,'Visible','on')
    set(handles.signtext,'Visible','on')
    set(handles.context,'Visible','on')

end    

% --------------------------------------------------------------------
function savefile_Callback(hObject, eventdata, handles)
% hObject    handle to savefile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
file=obj.File;
if ispc()
    slash=strfind(file,'\');
else
    slash=strfind(file,'/');
end
if ~isempty(slash)
    cd(file(1:slash(end)-1));
else
    cd(file);
end
[FileName,PathName] = uiputfile('*.txt','Choose an output file',...
    [sprintf('%c',obj.Name),'.txt']);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    obj.WriteToFile([PathName,FileName]);
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function exportobjects_Callback(hObject, eventdata, handles)
% hObject    handle to exportobjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'Checked'),'off')
    set(hObject,'Checked','on')
else
    set(hObject,'Checked','off')
end
if strcmp(get(hObject,'Checked'),'on')   
    UpdateResults(hObject, eventdata, handles)
end


% --------------------------------------------------------------------
function matlabonly_Callback(hObject, eventdata, handles)
% hObject    handle to matlabonly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function updatebaselines(Data,handles,Smoothing)

if Smoothing
    baselineL=sprintf(['The equation of the lower baseline: \ny=%0.3gx+%0.3g' ...
        ,'  R^2 : %0.3f.'], Data.BetaS{1}(2),Data.BetaS{1}(1),Data.R_squareS{1});
    baselineU=sprintf(['The equation of the upper baseline: \ny=%0.3gx+%0.3g' ...
        ,'  R^2 : %0.3f.'], Data.BetaS{2}(2),Data.BetaS{2}(1),Data.R_squareS{2});
else
    baselineL=sprintf(['The equation of the lower baseline: \ny=%0.3gx+%0.3g' ...
        ,'  R^2 : %0.3f.'], Data.Beta{1}(2),Data.Beta{1}(1),Data.R_square{1});
    baselineU=sprintf(['The equation of the upper baseline: \ny=%0.3gx+%0.3g' ...
        ,'  R^2 : %0.3f.'], Data.Beta{2}(2),Data.Beta{2}(1),Data.R_square{2});
end
set(handles.baselineL,'String',baselineL)
set(handles.baselineU,'String',baselineU)
    
function UpdateResults(hObject, eventdata, handles,auto)
% hObject    handle to gobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.everything,'Visible','off')
try
    if isa(get(handles.output,'UserData'),'char');
        file=get(handles.output,'UserData');
    else
        obj=get(handles.output,'UserData');
        file=obj.File;
    end
    switch get(handles.molecularityMenu,'Value')
        case 1
            Method='monomolecular';
        case 2
            Method='bimolecular2A';
        case 3
            Method='bimolecularAB';
        otherwise
    end
    Concentration=str2double(get(handles.concentration,'String'));
    Settings.DataSetIndex=get(handles.datasetpopup,'Value');
    Settings.Windows={[str2double(get(handles.LowerWindowL,'String')) ...
        str2double(get(handles.LowerWindowU,'String'))],...
        [str2double(get(handles.UpperWindowL,'String')) ...
        str2double(get(handles.UpperWindowU,'String'))]};
    Settings.AnalysisRange=[str2double(get(handles.AnalysisRangeL,'String')) ...
        str2double(get(handles.AnalysisRangeU,'String'))];
    if strcmp(get(handles.enablesmooth,'Checked'),'on')
        Smoothing=1;
    else
        Smoothing=0;
    end
    if strcmp(get(handles.exportobjects,'Checked'),'on')
        ExportResults=1;
    else
        ExportResults=0;
    end
    DataNames=get(handles.datasetpopup,'String');
    name=DataNames{get(handles.datasetpopup,'Value')};
    if nargin >3 && strcmp(auto,'auto')
        auto_range=true;
    else
        auto_range=false;
    end
    output=OligoMelt(file,Settings.DataSetIndex,...
            Settings.Windows,Settings.AnalysisRange,...
            'Smoothing',Smoothing,'ExportFigures',0,'Concentration',Concentration,...
            'AutoRange',auto_range,'Method',Method);
catch ME
    if strfind(ME.message,'Invalid field name')
        ErrorBoxGUI('title','Input Error','string',['Please check',...
            ' your dataset names. They cannot contain certain',...
            ' characters and they must start with a letter'])
    else
        ErrorBoxGUI('title','Unknown Error','string',['This error is most likely',...
            ' due to improper settings. Please double check them for sanity.']);
    end
    return
end
obj=findobj(output,'Name',name);
updatebaselines(obj.curve,handles,Smoothing)
axes(handles.ThetaAxes)
obj.theta.PlotTheta(1)
%set(gca,'FontUnits','normalized')
axes(handles.AbsAxes)
obj.theta.Curve.Plot(1)
axes(handles.VantHoffFit)
obj.theta.VantHoffFitPlot(1)
axes(handles.ExponentialFit)
obj.theta.ExponentialFitPlot(1)
axes(handles.ResultsAxes)
if get(handles.methodPopup,'Value')==1
    if get(handles.DataMode,'Value')
        obj.theta.VantHoffPlot(1)
    else
        obj.theta.PlotResiduals(0,1)
    end
    type='linear';
end
if get(handles.methodPopup,'Value')==2
   if get(handles.DataMode,'Value')
        obj.theta.NonlinearAnalysisPlot(1)
    else
        obj.theta.PlotResiduals(1,1)
   end
   type='nonlinear';
end
UpdateDisplay(obj,handles,type)

set(handles.output,'UserData',obj)
if Smoothing
    TmData=sprintf('%0.1f',obj.theta.TmS);
else
    TmData=sprintf('%0.1f',obj.theta.Tm);
end
set(handles.TmData,'String',TmData)
set([gca; findall(gca,'type','axes')] ,'Hittest', 'off');
set(handles.ResultsAxes,'Hittest','on')
set(handles.ResultsAxes,'ButtonDownFcn',@(hObject,eventdata)OligoMeltGUI('ResultsAxes_ButtonDownFcn',hObject,eventdata,guidata(hObject)))
set(handles.ExponentialFit,'ButtonDownFcn',@(hObject,eventdata)OligoMeltGUI('ExponentialFit_ButtonDownFcn',hObject,eventdata,guidata(hObject)))
set(handles.VantHoffFit,'ButtonDownFcn',@(hObject,eventdata)OligoMeltGUI('VantHoffFit_ButtonDownFcn',hObject,eventdata,guidata(hObject)))
set(handles.ThetaAxes,'ButtonDownFcn',@(hObject,eventdata)OligoMeltGUI('ThetaAxes_ButtonDownFcn',hObject,eventdata,guidata(hObject)))
set(handles.AbsAxes,'ButtonDownFcn',@(hObject,eventdata)OligoMeltGUI('AbsAxes_ButtonDownFcn',hObject,eventdata,guidata(hObject)))
%OligoMeltGUI('AbsAxes_ButtonDownFcn',hObject,eventdata,guidata(hObject))
%@(hObject,eventdata)ConAnalGUI('gobutton_Callback',hObject,eventdata,guidata(hObject))
set(handles.ResultsAxes,'ButtonDownFcn',@(hObject,eventdata)OligoMeltGUI('ResultsAxes_ButtonDownFcn',hObject,eventdata,guidata(hObject)))

try
    if ExportResults
        assignin('base',sprintf('%c',name),findobj(output,'Name',name))
    end
catch
    set(handles.exportobjects,'Checked','off')
    ErrorBoxGUI('title','User Error','string',['Invalid dataset name.',...
        ' Please rename your dataset to be a valid variable name.',...
        ' Alternatively, you may skip exporting to the MATLAB workspace,',...
        ' and just save to a text file.'])
end

function UpdateDisplay(obj,handles,type)
switch type
    case 'linear'
        deltaG=sprintf('%0.1f',obj.theta.VantHoff.Thermodynamic_Values.deltaG);
        conG=sprintf('%c %0.1f',char(177),obj.theta.VantHoff.Statistics.G_confidence);
        deltaH=sprintf('%0.1f',obj.theta.VantHoff.Thermodynamic_Values.deltaH);
        conH=sprintf('%c %0.1f',char(177),obj.theta.VantHoff.Statistics.H_confidence);
        deltaS=sprintf('%3.0f',obj.theta.VantHoff.Thermodynamic_Values.deltaS);
        conS=sprintf('%c %3.0f',char(177),obj.theta.VantHoff.Statistics.S_confidence);
        Tm=sprintf('%0.1f',obj.theta.VantHoff.Tm);
        r_square=sprintf('%0.3f',obj.theta.VantHoff.Statistics.R_squared);
        rmse=sprintf('%0.3f',obj.theta.VantHoff.Statistics.RMSE);
        
    case 'nonlinear'
        deltaG=sprintf('%0.1f',obj.theta.NonLinear.Thermodynamic_Values.deltaG);
        conG=sprintf('%c %0.1f',char(177),obj.theta.NonLinear.Statistics.G_confidence);
        deltaH=sprintf('%0.1f',obj.theta.NonLinear.Thermodynamic_Values.deltaH);
        conH=sprintf('%c %0.1f',char(177),obj.theta.NonLinear.Statistics.H_confidence);
        deltaS=sprintf('%3.0f',obj.theta.NonLinear.Thermodynamic_Values.deltaS);
        conS=sprintf('%c %3.0f',char(177),obj.theta.NonLinear.Statistics.S_confidence);
        Tm=sprintf('%0.1f',obj.theta.NonLinear.Tm);
        r_square=sprintf('%0.3f',obj.theta.NonLinear.Statistics.R_squared);
        rmse=sprintf('%0.3f',obj.theta.NonLinear.Statistics.RMSE);
end
set(handles.ValG,'String',deltaG)
set(handles.ConG,'String',conG)
set(handles.ValH,'String',deltaH)
set(handles.ConH,'String',conH)
set(handles.ValS,'String',deltaS)
set(handles.ConS,'String',conS)
if strcmp(Tm,'NaN')
    ErrorBoxGUI('title','Tm error','string',['This model is not good',...
        ' enough to predict a reasonable Tm. Try selecting better data.',...
        ' Note: Nonlinear models can not handle high temperatures. ',...
        'Try lowering the analysis range. '])
end
set(handles.TmModel,'String',Tm)
set(handles.R_square,'String',r_square)
set(handles.rmsetext,'String',rmse)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function enablesmooth_Callback(hObject, eventdata, handles)
% hObject    handle to enablesmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
    set(hObject,'Checked','on')
else
    set(hObject,'Checked','off')
end
UpdateResults(hObject, eventdata, handles)


function concentration_Callback(hObject, eventdata, handles)
% hObject    handle to concentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of concentration as text
%        str2double(get(hObject,'String')) returns contents of concentration as a double
UpdateResults(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function concentration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in molecularityMenu.
function molecularityMenu_Callback(hObject, eventdata, handles)
% hObject    handle to molecularityMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns molecularityMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from molecularityMenu
UpdateResults(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function molecularityMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to molecularityMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function OriginalData_Callback(hObject, eventdata, handles)
% hObject    handle to OriginalData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.Curve.Plot()

% --------------------------------------------------------------------
function Theta_plot_Callback(hObject, eventdata, handles)
% hObject    handle to Theta_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.PlotTheta()


% --------------------------------------------------------------------
function vanthoffitplot_Callback(hObject, eventdata, handles)
% hObject    handle to vanthoffitplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.VantHoffFitPlot();


% --------------------------------------------------------------------
function vanthoffplot_Callback(hObject, eventdata, handles)
% hObject    handle to vanthoffplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.VantHoffPlot();

% --------------------------------------------------------------------
function exponentialfitplot_Callback(hObject, eventdata, handles)
% hObject    handle to exponentialfitplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.ExponentialFitPlot();

% --------------------------------------------------------------------
function exponentialplot_Callback(hObject, eventdata, handles)
% hObject    handle to exponentialplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.NonlinearAnalysisPlot();

% --------------------------------------------------------------------
function vanthoffresidual_Callback(hObject, eventdata, handles)
% hObject    handle to vanthoffresidual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.PlotResiduals(0)

% --------------------------------------------------------------------
function exponentialresidues_Callback(hObject, eventdata, handles)
% hObject    handle to exponentialresidues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.PlotResiduals(1)


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('boo')

% --------------------------------------------------------------------
function savestate_Callback(hObject, eventdata, handles)
% hObject    handle to savestate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
file=obj.File;
if ispc()
    slash=strfind(file,'\');
else
    slash=strfind(file,'/');    
end
if ~isempty(slash) 
    cd(file(1:slash(end)-1));
else
    cd(file);
end
[FileName,PathName] = uiputfile('*.omss','Save to...',...
    [sprintf('%c',obj.Name),'.omss']);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    OMSS=OligoMeltSaveState(handles);
    OMSS.OMSSbasic(handles);
    OMSS.OMSSadvanced(handles);
    save([PathName,FileName],'OMSS','-v6')
end


% --------------------------------------------------------------------
function restorestate_Callback(hObject, eventdata, handles)
% hObject    handle to restorestate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    obj=get(handles.output,'UserData');
    file=obj.File;
    if ispc()
        slash=strfind(file,'\');
    else
        slash=strfind(file,'/');
    end
    if ~isempty(slash)
        cd(file(1:slash(end)-1));
    else
        cd(file);
    end   
catch
    obj.Name='default';
    file='default';
end
[FileName,PathName] = uigetfile('*.omss','Restore from...',...
    [sprintf('%c',obj.Name),'.omss']);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    load([PathName,FileName],'OMSS','-MAT');
    if ~exist(OMSS.File,'file')
        [FileName2,PathName2] = uigetfile({'*.xls;*.xlsx;*.xlsb;*.xlsm;*.csv',...
            'Supported Files';'*.*','All files'},['File Not Found: Select',...
            'the Excel or CSV File'],file);
        if ~isequal(FileName2,0) && ~isequal(PathName2,0)
            OMSS.File=[PathName2,FileName2];
        end
    end
    OMSS.OMSSrestore(handles);
    obj=get(handles.output,'UserData');
    try
        DataSetNames=OligoMelt(obj.File);
        set(handles.datasetpopup,'String',DataSetNames)
        Settings.DataSetIndex=get(handles.datasetpopup,'Value');
        [~, ~] = OligoMelt(obj.File,get(handles.datasetpopup,'Value'));
    catch
        set(handles.datasetpopup,'String','Reload Input')
        ErrorBoxGUI('title','User Error','string',...
            'The Input is not in the proper format. Please fix it and try again.')
        return
    end
    
    Windows=obj.Windows;
    set(handles.LowerWindowL,'String',num2str(Windows{1}(1)))
    set(handles.LowerWindowU,'String',num2str(Windows{1}(2)))
    set(handles.UpperWindowL,'String',num2str(Windows{2}(1)))
    set(handles.UpperWindowU,'String',num2str(Windows{2}(2)))
    set(handles.AnalysisRangeL,'String',obj.AnalysisRange(1))
    set(handles.AnalysisRangeU,'String',obj.AnalysisRange(2))   
    set(handles.settingsPanel,'Visible','on')    
    file=obj.File;
    Settings.DataSetIndex=get(handles.datasetpopup,'Value');
    Settings.AnalysisRange=obj.AnalysisRange;
    Settings.Windows=Windows;
    UpdateResults(hObject, eventdata, handles)
    set(handles.baselinePanel,'Visible','on')
    set(handles.resultsPanel,'Visible','on')
    set(handles.StatisticsPanel,'Visible','on')
    set(handles.VantHoffFit,'Visible','on')
    set(handles.ExponentialFit,'Visible','on')    
    set(handles.datasetpopup,'Visible','on')
    set(handles.datasettext,'Visible','on')
    set(handles.dg37,'Visible','on')
    set(handles.signtext,'Visible','on')
    set(handles.context,'Visible','on')
end    


% --- Executes during object creation, after setting all properties.
function ResultsAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResultsAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ResultsAxes

function LBRld_Callback(hObject, eventdata, handles)
% hObject    handle to LBRld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in LBRlu.

set(handles.LowerWindowL,'String',num2str(str2double(get(handles.LowerWindowL,'String'))-1))
UpdateResults(hObject, eventdata, handles)


function LBRlu_Callback(hObject, eventdata, handles)
% hObject    handle to LBRlu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.LowerWindowL,'String',num2str(str2double(get(handles.LowerWindowL,'String'))+1))
UpdateResults(hObject, eventdata, handles)

% --- Executes on button press in LBRud.
function LBRud_Callback(hObject, eventdata, handles)
% hObject    handle to LBRud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.LowerWindowU,'String',num2str(str2double(get(handles.LowerWindowU,'String'))-1))
UpdateResults(hObject, eventdata, handles)

% --- Executes on button press in LBRuu.
function LBRuu_Callback(hObject, eventdata, handles)
% hObject    handle to LBRuu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.LowerWindowU,'String',num2str(str2double(get(handles.LowerWindowU,'String'))+1))
UpdateResults(hObject, eventdata, handles)


% --- Executes on button press in UBRld.
function UBRld_Callback(hObject, eventdata, handles)
% hObject    handle to UBRld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.UpperWindowL,'String',num2str(str2double(get(handles.UpperWindowL,'String'))-1))
UpdateResults(hObject, eventdata, handles)

% --- Executes on button press in UBRlu.
function UBRlu_Callback(hObject, eventdata, handles)
% hObject    handle to UBRlu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.UpperWindowL,'String',num2str(str2double(get(handles.UpperWindowL,'String'))+1))
UpdateResults(hObject, eventdata, handles)

% --- Executes on button press in UBRud.
function UBRud_Callback(hObject, eventdata, handles)
% hObject    handle to UBRud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.UpperWindowU,'String',num2str(str2double(get(handles.UpperWindowU,'String'))-1))
UpdateResults(hObject, eventdata, handles)

% --- Executes on button press in UBRuu.
function UBRuu_Callback(hObject, eventdata, handles)
% hObject    handle to UBRuu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.UpperWindowU,'String',num2str(str2double(get(handles.UpperWindowU,'String'))+1))
UpdateResults(hObject, eventdata, handles)


% --- Executes on button press in ARld.
function ARld_Callback(hObject, eventdata, handles)
% hObject    handle to ARld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.AnalysisRangeL,'String',num2str(str2double(get(handles.AnalysisRangeL,'String'))-1))
UpdateResults(hObject, eventdata, handles)


% --- Executes on button press in ARlu.
function ARlu_Callback(hObject, eventdata, handles)
% hObject    handle to ARlu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.AnalysisRangeL,'String',num2str(str2double(get(handles.AnalysisRangeL,'String'))+1))
UpdateResults(hObject, eventdata, handles)

% --- Executes on button press in ARud.
function ARud_Callback(hObject, eventdata, handles)
% hObject    handle to ARud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.AnalysisRangeU,'String',num2str(str2double(get(handles.AnalysisRangeU,'String'))-1))
UpdateResults(hObject, eventdata, handles)

% --- Executes on button press in ARuu.
function ARuu_Callback(hObject, eventdata, handles)
% hObject    handle to ARuu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.AnalysisRangeU,'String',num2str(str2double(get(handles.AnalysisRangeU,'String'))+1))
UpdateResults(hObject, eventdata, handles)


% --- Executes on mouse press over axes background.
function ThetaAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ThetaAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.PlotTheta()

% --- Executes on mouse press over axes background.
function VantHoffFit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to VantHoffFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.VantHoffFitPlot();

% --- Executes on mouse press over axes background.
function ExponentialFit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ExponentialFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
obj.theta.ExponentialFitPlot();


% --- Executes on mouse press over axes background.
function AbsAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to AbsAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
obj=get(handles.output,'UserData');
obj.theta.Curve.Plot()


% --- Executes on mouse press over axes background.
function ResultsAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ResultsAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');

%disp('Please don''t press this button again.')
if get(handles.DataMode,'Value')
    if get(handles.methodPopup,'Value')==1
        obj.theta.VantHoffPlot();
    else
        obj.theta.NonlinearAnalysisPlot();
    end
else
    if get(handles.methodPopup,'Value')==1
        obj.theta.PlotResiduals(0)
    else
        obj.theta.PlotResiduals(1)
    end
end


 
