function varargout = SSrenumber(varargin)
% SSRENUMBER M-file for SSrenumber.fig
%      SSRENUMBER, by itself, creates a new SSRENUMBER or raises the existing
%      singleton*.
%
%      H = SSRENUMBER returns the handle to a new SSRENUMBER or the handle to
%      the existing singleton*.
%
%      SSRENUMBER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SSRENUMBER.M with the given input arguments.
%
%      SSRENUMBER('Property','Value',...) creates a new SSRENUMBER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SSrenumber_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SSrenumber_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SSrenumber

% Last Modified by GUIDE v2.5 14-May-2012 15:16:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SSrenumber_OpeningFcn, ...
                   'gui_OutputFcn',  @SSrenumber_OutputFcn, ...
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


% --- Executes just before SSrenumber is made visible.
function SSrenumber_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SSrenumber (see VARARGIN)

% Choose default command line output for SSrenumber
handles.output = hObject;
handles.cutoff=Inf;
handles.HasChangedA=1;
handles.HasChangedB=1;
handles.chainAprev=1;
handles.chainBprev=1;
SSUD=SSrenumberUserData();
set(handles.output,'UserData',SSUD)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SSrenumber wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SSrenumber_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% obj=get(handles.output,'UserData');
% 
% varargout{1} = obj.Map;
varargout{1} = hObject;

% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_pdbA_Callback(hObject, eventdata, handles)
% hObject    handle to load_pdbA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');

[FileName,PathName] = uigetfile({'*.pdb';'*.*'},'Select the PDB File',obj.pdbA_file);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    if ~strcmp(obj.pdbA_file,fullfile(PathName,FileName))
        obj.pdbA_file=fullfile(PathName,FileName);
        [pathstr, name] = fileparts(obj.pdbA_file);
        ID=fullfile(pathstr,name);
        h=PleaseWait();
        if exist([ID,'.mat'],'file') == 2
            load([ID,'.mat'])
        else
            pdb=importdata(obj.pdbA_file);
            save([ID,'.mat'],'pdb','-v6')
        end
        chains=sort(unique([pdb.Model.Atom.chainID]));
        chainIDs=cell(1,length(chains));
        for i=1:length(chains)
            chainIDs{i}=chains(i);
        end
        obj.pdbA=pdb;
        set(handles.pdbA_file_text,'String',name);
        set(handles.ChainID_A,'String',chainIDs);
        delete(h)
        handles.HasChangedA=1;
        guidata(hObject, handles);
        set(handles.output,'UserData',obj)
        if ~isempty(obj.pdbB)
            set(handles.buttonAB,'Enable','on')
            set(handles.buttonBA,'Enable','on')
        end
    end
end


% --------------------------------------------------------------------
function load_pdbB_Callback(hObject, eventdata, handles)
% hObject    handle to load_pdbB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');

[FileName,PathName] = uigetfile({'*.pdb';'*.*'},'Select the PDB File',obj.pdbB_file);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    if ~strcmp(obj.pdbB_file,fullfile(PathName,FileName))
        obj.pdbB_file=fullfile(PathName,FileName);
        [pathstr, name] = fileparts(obj.pdbB_file);
        ID=fullfile(pathstr,name);
        h=PleaseWait();
        if exist([ID,'.mat'],'file') == 2
            load([ID,'.mat'])
        else
            pdb=importdata(obj.pdbB_file);
            save([ID,'.mat'],'pdb','-v6')
        end
        chains=sort(unique([pdb.Model.Atom.chainID]));
        chainIDs=cell(1,length(chains));
        for i=1:length(chains)
            chainIDs{i}=chains(i);
        end
        obj.pdbB=pdb;
        set(handles.pdbB_file_text,'String',name);
        set(handles.ChainID_B,'String',chainIDs);
       
        handles.HasChangedB=1;
        guidata(hObject, handles);
        set(handles.output,'UserData',obj)
        if ~isempty(obj.pdbA)
            set(handles.buttonAB,'Enable','on')
            set(handles.buttonBA,'Enable','on')
        end
        delete(h)
    end
end


function ChainID_A_Callback(hObject, eventdata, handles)
% hObject    handle to ChainID_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.chainAprev~=get(hObject,'Value')
    handles.HasChangedA=1;
    handles.chainAprev=get(hObject,'Value');
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function ChainID_A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChainID_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ChainID_B_Callback(hObject, eventdata, handles)
% hObject    handle to ChainID_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.chainBprev~=get(hObject,'Value')
    handles.HasChangedB=1;
    handles.chainBprev=get(hObject,'Value');
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ChainID_B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChainID_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonAB.
function buttonAB_Callback(hObject, eventdata, handles)
% hObject    handle to buttonAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
h=PleaseWait();
if handles.HasChangedA
    obj.FAM_A=FullAtomModel('A');
    obj.FAM_A.PopulateFAM(obj.pdbA);
    chainsA = cellstr(get(handles.ChainID_A,'String'));
    obj.chain_A=Chain(obj.FAM_A.Name,chainsA{get(handles.ChainID_A,'Value')});
    obj.chain_A.CreateChain(obj.FAM_A,chainsA{get(handles.ChainID_A,'Value')});
    obj.pa_A=PseudoAtoms('A');
    obj.pa_A.CenterOfMass(obj.chain_A.residues,'Base only');
    handles.HasChangedA=0;    
    guidata(hObject, handles);
end
if handles.HasChangedB
    obj.FAM_B=FullAtomModel('B');
    obj.FAM_B.PopulateFAM(obj.pdbB);
    chainsB = cellstr(get(handles.ChainID_B,'String'));
    obj.chain_B=Chain(obj.FAM_B.Name,chainsB{get(handles.ChainID_B,'Value')});
    obj.chain_B.CreateChain(obj.FAM_B,chainsB{get(handles.ChainID_B,'Value')});
    obj.pa_B=PseudoAtoms('B');
    obj.pa_B.CenterOfMass(obj.chain_B.residues,'Base only');
    handles.HasChangedB=0;    
    guidata(hObject, handles);
end

if handles.cutoff==Inf
    NN=nearestneighbour(cell2mat(obj.pa_A.Position')',cell2mat(obj.pa_B.Position')');
else
    NN=nearestneighbour(cell2mat(obj.pa_A.Position')',cell2mat(obj.pa_B.Position')',...
        'r',handles.cutoff,'num', 1);
end
ResA=obj.chain_A.residues.ResidueNumber(logical(NN));
ResB=obj.chain_B.residues.ResidueNumber(NN(logical(NN)));
obj.Map=[ResA,ResB];
delete(h)
status=sprintf('A --> B\nB --> B');
set(handles.status_text,'String',status)
set(handles.output,'UserData',obj)


% --- Executes on button press in buttonBA.
function buttonBA_Callback(hObject, eventdata, handles)
% hObject    handle to buttonBA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
h=PleaseWait();
if handles.HasChangedA
    obj.FAM_A=FullAtomModel('A');
    obj.FAM_A.PopulateFAM(obj.pdbA);
    chainsA = cellstr(get(handles.ChainID_A,'String'));
    obj.chain_A=Chain(obj.FAM_A.Name,chainsA{get(handles.ChainID_A,'Value')});
    obj.chain_A.CreateChain(obj.FAM_A,chainsA{get(handles.ChainID_A,'Value')});
    obj.pa_A=PseudoAtoms('A');
    obj.pa_A.CenterOfMass(obj.chain_A.residues,'Base only');
    handles.HasChangedA=0;    
    guidata(hObject, handles);
end
if handles.HasChangedB
    obj.FAM_B=FullAtomModel('B');
    obj.FAM_B.PopulateFAM(obj.pdbB);
    chainsB = cellstr(get(handles.ChainID_B,'String'));
    obj.chain_B=Chain(obj.FAM_B.Name,chainsB{get(handles.ChainID_B,'Value')});
    obj.chain_B.CreateChain(obj.FAM_B,chainsB{get(handles.ChainID_B,'Value')});
    obj.pa_B=PseudoAtoms('B');
    obj.pa_B.CenterOfMass(obj.chain_B.residues,'Base only');
    handles.HasChangedB=0;    
    guidata(hObject, handles);
end

if handles.cutoff==Inf
    NN=nearestneighbour(cell2mat(obj.pa_B.Position')',cell2mat(obj.pa_A.Position')');
else
    NN=nearestneighbour(cell2mat(obj.pa_B.Position')',cell2mat(obj.pa_A.Position')',...
        'r',handles.cutoff,'num', 1);
end
ResB=obj.chain_B.residues.ResidueNumber(logical(NN));
ResA=obj.chain_A.residues.ResidueNumber(NN(logical(NN)));
obj.Map=[ResA,ResB];
delete(h)
status=sprintf('A --> A\nB --> A');
set(handles.status_text,'String',status)
set(handles.output,'UserData',obj)

% --- Executes on button press in OK_button.
function OK_button_Callback(hObject, eventdata, handles)
% hObject    handle to OK_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume
obj=get(handles.output,'UserData');
assignin('base','SS_obj',obj);

% --------------------------------------------------------------------
function cutoff_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cutoff_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cutoff=inputdlg({'Enter max distance to search'},'Max distance (A)',...
    1,{num2str(handles.cutoff)});
if ~isempty(cutoff)
    handles.cutoff=str2double(cutoff{1});
    guidata(hObject, handles);
    set(handles.cutoff_text,'String',cutoff{1})
end
