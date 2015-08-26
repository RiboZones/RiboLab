function varargout = NewChain(varargin)
% NEWCHAIN M-file for NewChain.fig
%      NEWCHAIN, by itself, creates a new NEWCHAIN or raises the existing
%      singleton*.
%
%      H = NEWCHAIN returns the handle to a new NEWCHAIN or the handle to
%      the existing singleton*.
%
%      NEWCHAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWCHAIN.M with the given input arguments.
%
%      NEWCHAIN('Property','Value',...) creates a new NEWCHAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewChain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewChain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewChain

% Last Modified by GUIDE v2.5 28-Apr-2010 17:41:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @NewChain_OpeningFcn, ...
    'gui_OutputFcn',  @NewChain_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   '');
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before NewChain is made visible.
function NewChain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewChain (see VARARGIN)

% Choose default command line output for NewChain
handles.output = hObject;

CurrentChain=1;

if (nargin > 3)
    result=varargin{1};
    if (nargin > 4)
        CurrentChain=varargin{2};
    else
        CurrentChain=1;
    end
    result.CurrentChain=CurrentChain;
    set(handles.output,'UserData',result)
end

result=get(handles.output,'UserData');
% if isfield(result.pdb,'Sequence')
%     NameOfChains=unique({result.pdb.Sequence.ChainID});
% else
NameOfChains=unique([{result.pdb.Model.Atom.chainID},{result.pdb.Model.HeterogenAtom.chainID}]);
% end
set(handles.chainMenu,'Value',1);
set(handles.chainMenu,'String',NameOfChains)


if isfield(result,'Settings') && length(result.Settings)>=CurrentChain && isfield(result.Settings{CurrentChain},'chain')
    set(handles.chainMenu,'Value',result.Settings{CurrentChain}.chainIND);
    set(handles.CenterOfMassMenu,'Value',result.Settings{CurrentChain}.CenterOfMassMethodIND);
    set(handles.SearchMenu,'Value',result.Settings{CurrentChain}.SearchMethodIND);
    set(handles.cutoffEdit,'String',result.Settings{CurrentChain}.cutoff);
    set(handles.patternText1,'String',result.Settings{CurrentChain}.Pattern{1}{1})
    set(handles.patternText2,'String',result.Settings{CurrentChain}.Pattern{2}{1})
    
    contents = cellstr(get(handles.SearchMenu,'String'));
    switch contents{get(handles.SearchMenu,'Value')}
        case 'Identity'
            set(handles.patternText2,'Visible','off')
            set(handles.cutoffEdit,'Visible','off')
            set(handles.cutoffEdit,'String','0')
        otherwise
            set(handles.patternText2,'Visible','on')
            set(handles.cutoffEdit,'Visible','on')
    end
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NewChain wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = NewChain_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isempty(handles)
    varargout{1} = get(handles.output,'UserData');
    varargout{2} = hObject;
else
    varargout{1}='none';
    varargout{2} = hObject;
end


% --- Executes on selection change in CenterOfMassMenu.
function CenterOfMassMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CenterOfMassMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CenterOfMassMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CenterOfMassMenu


% --- Executes during object creation, after setting all properties.
function CenterOfMassMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CenterOfMassMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in chainMenu.
function chainMenu_Callback(hObject, eventdata, handles)
% hObject    handle to chainMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chainMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chainMenu


% --- Executes during object creation, after setting all properties.
function chainMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chainMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function patternText1_Callback(hObject, eventdata, handles)
% hObject    handle to patternText1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of patternText1 as text
%        str2double(get(hObject,'String')) returns contents of patternText1 as a double


% --- Executes during object creation, after setting all properties.
function patternText1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patternText1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function patternText2_Callback(hObject, eventdata, handles)
% hObject    handle to patternText2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of patternText2 as text
%        str2double(get(hObject,'String')) returns contents of patternText2 as a double


% --- Executes during object creation, after setting all properties.
function patternText2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patternText2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SearchMenu.
function SearchMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SearchMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SearchMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SearchMenu
contents = cellstr(get(hObject,'String'));
switch contents{get(hObject,'Value')}
    case 'Identity'
        set(handles.patternText2,'Visible','off')
        set(handles.cutoffEdit,'Visible','off')            
        set(handles.cutoffEdit,'String','0')
    otherwise
        set(handles.patternText2,'Visible','on')        
        set(handles.cutoffEdit,'Visible','on')
end
% --- Executes during object creation, after setting all properties.
function SearchMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SearchMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cutoffEdit_Callback(hObject, eventdata, handles)
% hObject    handle to cutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cutoffEdit as text
%        str2double(get(hObject,'String')) returns contents of cutoffEdit as a double


% --- Executes during object creation, after setting all properties.
function cutoffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateResults(hObject, eventdata, handles)
uiresume(handles.figure1)


function UpdateResults(hObject, eventdata, handles)
result=get(handles.output,'UserData');
ID=result.ID;
FAM=result.FAM;
h=PleaseWait();
try    
        CurrentChain=result.CurrentChain;

    %%
    %  2. Determine which chains to process and how many there are
    NameOfChains=get(handles.chainMenu,'String');
    SelectedChains=NameOfChains(get(handles.chainMenu,'Value'));
    num_chains=length(SelectedChains);                                           % Find the number of chains
    
    %%
    %  3. Determine field names for chains, pseudo atoms models, and results
    ChainName=cell(1,num_chains);                                              % Pre-allocate these variables for speed
    PseudoAtomName=cell(1,num_chains);
    ResultsName=cell(1,num_chains);
    
    for index=1:num_chains                                                     % Pre-determine the name of all chains, pseudo atoms model, and results
        ChainName{index}=strcat('Chain','_',SelectedChains{index});
        PseudoAtomName{index}=strcat('PseudoAtom_Chain_',SelectedChains{index});
        ResultsName{index}=strcat('Results_Chain_',SelectedChains{index});
    end
    contents = cellstr(get(handles.CenterOfMassMenu,'String'));
    Method.CenterOfMass=contents{get(handles.CenterOfMassMenu,'Value')};
    contents = cellstr(get(handles.SearchMenu,'String'));
    Method.Search=contents{get(handles.SearchMenu,'Value')};
    cutoff=str2double(get(handles.cutoffEdit,'String'));
    Pattern={{get(handles.patternText1,'String')} {get(handles.patternText2,'String')}};       
    Pattern{1}=cellstr(strread(Pattern{1}{1},'%s'))';
    Pattern{2}=cellstr(strread(Pattern{2}{1},'%s'))';
    for index=1:num_chains                                                     % Start the main block loop
        %%
        %  1. Make the chain object
        chain.(ChainName{index})=Chain(ID,SelectedChains{index});                % Instantiate
        chain.(ChainName{index}).CreateChain(FAM,SelectedChains{index});         % Build the chain
        
        %%
        %  2. Make the pseudo atom object
        pa.(PseudoAtomName{index})=PseudoAtoms(strcat(ID,'_',...               % Instantiate
            ChainName{index}));
        pa.(PseudoAtomName{index}).CenterOfMass(chain.(ChainName{index}...     % Find the center of masses
            ).residues,Method.CenterOfMass);
        %%
        %  3. Find results based on search method.
        results.(ResultsName{index})=Results(pa.(PseudoAtomName{index}).Name); % Instantiate
        switch Method.Search
            case {'Triangle','Linear'}
                results.(ResultsName{index}).FindNearby(...                    $ Find nearby residues
                    pa.(PseudoAtomName{index}),Pattern,...
                    chain.(ChainName{index}).residues.ListOfResidues,cutoff);
                if cutoff~=0
                    if length(Pattern{1}) > 1
                        results.(ResultsName{index}).Triangle...                   % Restrict results using the Triangle method
                            (pa.(PseudoAtomName{index}).Position,'intra',cutoff);
                    else
                        results.(ResultsName{index}).Linear();             % Removes symmetrical results
                    end
                end
            case 'Identity'
                results.(ResultsName{index}).Identity(...                    $ Find itself
                    pa.(PseudoAtomName{index}),Pattern,...
                    chain.(ChainName{index}).residues.ListOfResidues);
            otherwise
                warning('No valid Search Method specified. Results are blank.')
        end
        result.Model{CurrentChain}.chain=chain.(ChainName{index});
        result.Model{CurrentChain}.pa=pa.(PseudoAtomName{index});
        result.Settings{CurrentChain}.chain=SelectedChains{index};
        result.Settings{CurrentChain}.chainIND=get(handles.chainMenu,'Value');
        result.Settings{CurrentChain}.CurrentChain=get(handles.chainMenu,'Value');
        result.Settings{CurrentChain}.CenterOfMassMethod=Method.CenterOfMass;
        result.Settings{CurrentChain}.CenterOfMassMethodIND=get(handles.CenterOfMassMenu,'Value');
        result.Settings{CurrentChain}.Pattern={{get(handles.patternText1,'String')} {get(handles.patternText2,'String')}};
        result.Settings{CurrentChain}.SearchMethod=Method.Search;
        result.Settings{CurrentChain}.SearchMethodIND=get(handles.SearchMenu,'Value');
        result.Settings{CurrentChain}.cutoff=get(handles.cutoffEdit,'String');
       
        result.results{CurrentChain}=results.(ResultsName{index});
        
    end

catch
end
delete(h)
set(handles.output,'UserData',result)


% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

function x=dummy(vargin)
x=rand;
