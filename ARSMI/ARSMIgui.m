function varargout = ARSMIgui(varargin)
% ARSMIGUI M-file for ARSMIgui.fig
%      ARSMIGUI, by itself, creates a new ARSMIGUI or raises the existing
%      singleton*.
%
%      H = ARSMIGUI returns the handle to a new ARSMIGUI or the handle to
%      the existing singleton*.
%
%      ARSMIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARSMIGUI.M with the given input arguments.
%
%      ARSMIGUI('Property','Value',...) creates a new ARSMIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ARSMIgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ARSMIgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ARSMIgui

% Last Modified by GUIDE v2.5 22-Mar-2012 16:28:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ARSMIgui_OpeningFcn, ...
                   'gui_OutputFcn',  @ARSMIgui_OutputFcn, ...
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


% --- Executes just before ARSMIgui is made visible.
function ARSMIgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ARSMIgui (see VARARGIN)

% Choose default command line output for ARSMIgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% set(handles.patternA1,'String','MG')
% set(handles.patternA2,'String','MG')
% set(handles.cutoffEdit,'String','6')

% UIWAIT makes ARSMIgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ARSMIgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function fileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to fileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function editMenu_Callback(hObject, eventdata, handles)
% hObject    handle to editMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function viewMenu_Callback(hObject, eventdata, handles)
% hObject    handle to viewMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function advancedMENU_Callback(hObject, eventdata, handles)
% hObject    handle to advancedMENU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function helpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to helpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function optionsmenu_Callback(hObject, eventdata, handles)
% hObject    handle to optionsmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openpdb_Callback(hObject, eventdata, handles)
% hObject    handle to openpdb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
if ~isempty(result)
    file=result.File;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.pdb';'*.*'},'Select the PDF File',file);
if ~isequal(FileName,0) && ~isequal(PathName,0)    
    
    file=fullfile(PathName,FileName);
    [path,name]=fileparts(file);
    ID=fullfile(path,name);                                                      
    h=PleaseWait();
    if exist([ID,'.mat'],'file') == 2
        load([ID,'.mat'])       
    else
        pdb=importdata(file);
        save([ID,'.mat'],'pdb','-v6')
    end
    result.pdb=pdb;
    result.File=file;
    result.ID=name;
    FAM=FullAtomModel(result.ID);                                                 % Instantiate
    FAM.PopulateFAM(result.pdb);                                                  % Populate the model with data from the pdb sructure
    result.FAM=FAM;
    NameOfChains=unique({FAM.Model.chainID});
    set(handles.output,'UserData',result)
    set(handles.pdbIDtext,'String',result.ID)
    set(handles.chainA,'Value',1);
    set(handles.chainA,'String',NameOfChains)
    set(handles.chainB,'Value',1);
    set(handles.chainB,'String',NameOfChains)  
    delete(h)
    set(handles.Main_mode,'Visible','on')
    %set(handles.Main_mode,'Value',1)
    set(handles.chainA,'Visible','on')
    set(handles.patternA1,'Visible','on')    
    set(handles.gobutton,'Visible','on')
end

% --------------------------------------------------------------------
function saveResults_Callback(hObject, eventdata, handles)
% hObject    handle to saveResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
numchains=length(result.results);
[FileName,PathName] = uiputfile('*.pml','Choose an output file',...
    [sprintf('%c',result.ID),'.pml']);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    pdbname=[FileName(1:end-4) '.pdb'];
    try
    copyfile(result.File,[PathName, pdbname]);
    catch
    end
    cd(PathName)
    if numchains == 1
        result.Intermediate(1,1).Whole=result.results{1};
        result.Intermediate(1,1).Pattern={result.Settings{1}.Pattern,...
            result.Settings{1}.Pattern};
    end
    Intermediate=[result.Intermediate(:).Whole];
%     Pattern=[result.Intermediate(:).Pattern];
%     extend=[sum(~isspace(Pattern{1}{1})),sum(~isspace(Pattern{2}{1}))];
%     
%     Intermediate.Extend(extend);
    Intermediate.WriteToFile(result.ID,0,FileName);
end

% --------------------------------------------------------------------
function autosave_Callback(hObject, eventdata, handles)
% hObject    handle to autosave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'Checked'),'off')
    set(hObject,'Checked','on')
else
    set(hObject,'Checked','off')
end


% --------------------------------------------------------------------
function fetchpdb_Callback(hObject, eventdata, handles)
% hObject    handle to fetchpdb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[result fig]=FetchPDB();
if isstruct(result)
    FAM=FullAtomModel(result.ID);                                                 % Instantiate
    FAM.PopulateFAM(result.pdb);                                                  % Populate the model with data from the pdb sructure
    result.FAM=FAM;
    NameOfChains=unique({result.pdb.Sequence.ChainID});
    set(handles.output,'UserData',result)
    set(handles.pdbIDtext,'String',result.ID)
    set(handles.chainA,'Value',1);
    set(handles.chainA,'String',NameOfChains)
end
if ishandle(fig)
    delete(fig);
    set(handles.chainpanel1,'Visible','on')
    set(handles.chainpanel2,'Visible','on')
    set(handles.chainpanel3,'Visible','on')
    set(handles.chainpanel4,'Visible','on')
    set(handles.closecontactpanel,'Visible','on')
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



function patternA1_Callback(hObject, eventdata, handles)
% hObject    handle to patternA1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of patternA1 as text
%        str2double(get(hObject,'String')) returns contents of patternA1 as a double

contents = cellstr(get(handles.Main_mode,'String'));
switch contents{get(handles.Main_mode,'Value')}
    case 'Single Residue'
        handles.Pattern{1}={{get(handles.patternA1,'String')}};
    case {'Base Pair','Unbonded Segment(s)'}
        handles.Pattern{1}={{get(handles.patternA1,'String')}};        
        handles.Pattern{2}={{get(handles.patternB,'String')}};
    case {'Triangle','Bonded Segment'}
        handles.Pattern{1}={{get(handles.patternA1,'String'),...
            get(handles.patternA2,'String')}};
        handles.Pattern{2}={{get(handles.patternB,'String')}};
    case 'Mg --> Pi(s)'
        handles.Pattern{1}={{'MG'}};        
        handles.Pattern{2}={{'*'}};
    case 'Pi --> Mg(s)'
        handles.Pattern{1}={{'*'}};        
        handles.Pattern{2}={{'MG'}};
    case 'Mg u-cluster'
        warning('mg u cluster mode is not done yet')
        handles.Pattern{1}={{'*'}};        
        handles.Pattern{2}={{'MG'}};
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function patternA1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patternA1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in chainA.
function chainA_Callback(hObject, eventdata, handles)
% hObject    handle to chainA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chainA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chainA


% --- Executes during object creation, after setting all properties.
function chainA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chainA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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




function UpdateResults(hObject, eventdata, handles)
result=get(handles.output,'UserData');
%%
try 
    ID=result.ID;
    FAM=result.FAM;
    h=PleaseWait();
    NameOfChains=get(handles.chainA,'String');
    chainIND=[get(handles.chainA,'Value'),get(handles.chainB,'Value')];
    SelectedChains={NameOfChains{chainIND}};
    ChainName=cell(1,handles.numChains);                                              % Pre-allocate these variables for speed
    PseudoAtomName=cell(1,handles.numChains);
    ResultsName=cell(1,handles.numChains);
    CenterofMassMethod=handles.CenterofMassMethod;
    SearchMethod=handles.SearchMethod;
    cutoff=str2double(get(handles.cutoffEdit,'String'));
    Pattern=handles.Pattern;

    for CurrentChain=1:handles.numChains
        ChainName{CurrentChain}=strcat('Chain','_',SelectedChains{CurrentChain});
        PseudoAtomName{CurrentChain}=strcat('PseudoAtom_Chain_',SelectedChains{CurrentChain});
        ResultsName{CurrentChain}=strcat('Results_Chain_',SelectedChains{CurrentChain});
        
        %         Pattern={{get(handles.patternText1,'String')} {get(handles.patternText2,'String')}};
        %         Pattern{1}=cellstr(strread(Pattern{1}{1},'%s'))';
        %         Pattern{2}=cellstr(strread(Pattern{2}{1},'%s'))';
        
        
        
        % Start the main block loop
        %%
        %  1. Make the chain object
        chain.(ChainName{CurrentChain})=Chain(ID,SelectedChains{CurrentChain});                % Instantiate
        chain.(ChainName{CurrentChain}).CreateChain(FAM,SelectedChains{CurrentChain});         % Build the chain
        
        %%
        %  2. Make the pseudo atom object
        pa.(PseudoAtomName{CurrentChain})=PseudoAtoms(strcat(ID,'_',...               % Instantiate
            ChainName{CurrentChain}));
        pa.(PseudoAtomName{CurrentChain}).CenterOfMass(chain.(ChainName{CurrentChain}...     % Find the center of masses
            ).residues,CenterofMassMethod{CurrentChain});
        %%
        %  3. Find results based on search method.
        results.(ResultsName{CurrentChain})=Results(pa.(PseudoAtomName{CurrentChain}).Name); % Instantiate
        switch SearchMethod{CurrentChain}
            case {'Triangle','Linear'}
                results.(ResultsName{CurrentChain}).FindNearby(...                    $ Find nearby residues
                    pa.(PseudoAtomName{CurrentChain}),Pattern{CurrentChain},...
                    chain.(ChainName{CurrentChain}).residues.ListOfResiduesU,cutoff);
                if cutoff~=0
                    if length(Pattern{CurrentChain}{1}) > 1
                        results.(ResultsName{CurrentChain}).Triangle...                   % Restrict results using the Triangle method
                            (pa.(PseudoAtomName{CurrentChain}).Position,'intra',cutoff);
                    else
                        results.(ResultsName{CurrentChain}).Linear();             % Removes symmetrical results
                    end
                end
            case 'BondedSegment'
                results.(ResultsName{CurrentChain}).BondedSegment(...                    $ Find nearby residues
                    pa.(PseudoAtomName{CurrentChain}),Pattern{CurrentChain},...
                    chain.(ChainName{CurrentChain}).residues.ListOfResiduesU);
            case 'Identity'
                results.(ResultsName{CurrentChain}).Identity(...                    $ Find itself
                    pa.(PseudoAtomName{CurrentChain}),Pattern{CurrentChain},...
                    chain.(ChainName{CurrentChain}).residues.ListOfResiduesU);
            otherwise
                warning('No valid Search Method specified. Results are blank.')
        end
        result.Model{CurrentChain}.chain=chain.(ChainName{CurrentChain});
        result.Model{CurrentChain}.pa=pa.(PseudoAtomName{CurrentChain});
        result.Settings{CurrentChain}.chain=SelectedChains{CurrentChain};
        result.Settings{CurrentChain}.chainIND=chainIND(CurrentChain);
        result.Settings{CurrentChain}.CurrentChain=CurrentChain;
        result.Settings{CurrentChain}.CenterOfMassMethod=CenterofMassMethod{CurrentChain};
        %result.Settings{CurrentChain}.CenterOfMassMethodIND=get(handles.CenterOfMassMenu,'Value');
        result.Settings{CurrentChain}.Pattern=Pattern{CurrentChain};
        result.Settings{CurrentChain}.SearchMethod=SearchMethod{CurrentChain};
        %result.Settings{CurrentChain}.SearchMethodIND=get(handles.SearchMenu,'Value');
        result.Settings{CurrentChain}.cutoff=get(handles.cutoffEdit,'String');  
        result.results{CurrentChain}=results.(ResultsName{CurrentChain});       
    end
    if handles.numChains == 2
        results=[result.results{:}];
        model=[result.Model{:}];
        settings.cutoff=cutoff;
        
        contents = cellstr(get(handles.Main_mode,'String'));
        switch contents{get(handles.Main_mode,'Value')}
            case 'Triangle'
                Intermediate=results.Triangle(model,settings);
            case 'Base Pair'
                settings.SearchMethod='Base Pair';
                Intermediate=results.Linear(model,settings);
            case 'Mg u-cluster'
                results=[result.results{[2,2]}];
                model=[result.Model{[2,2]}];
                settings.cutoff=5.8;
                settings.SearchMethod='StrictLinear';
                Intermediate=results.Linear(model,settings);
                %mg pairs to p triangle
                settings.cutoff=3.8;
                results2=[Intermediate,result.results{1}];
                model=[result.Model{[2,1]}];
                Intermediate=results2.Triangle(model,settings);
                Intermediate=MguCluster(Intermediate,model,3.8);
                Intermediate=MguClusterExpand(Intermediate,model);
            case {'Mg --> Pi(s)','Pi --> Mg(s)'}
                settings.SearchMethod='Linear';
                Intermediate=results.Linear(model,settings);
                Intermediate=CheckMgPdist(model,Intermediate);
                
            otherwise
                settings.SearchMethod='Linear';
                Intermediate=results.Linear(model,settings);
        end
        
        result.Intermediate(1,2).Whole=Intermediate;
        result.Intermediate(1,2).Pattern={result.Settings{1}.Pattern,...
            result.Settings{2}.Pattern};
        set(handles.output,'UserData',result)
    end
    
catch
end
delete(h)
set(handles.output,'UserData',result)
if strcmp(get(handles.exportobjects,'Checked'),'on')
    ExportResults=1;
else
    ExportResults=0;
end
try
    if ExportResults
        assignin('base',['PDB_',result.ID],result)
    end
catch
    set(handles.exportobjects,'Checked','off')
    ErrorBoxGUI('title','User Error','string',['Invalid dataset name.',...
        ' Please rename your dataset to be a valid variable name.',...
        ' Alternatively, you may skip exporting to the MATLAB workspace,',...
        ' and just save to a text file.'])
end

% --- Executes on button press in gobutton.
function gobutton_Callback(hObject, eventdata, handles)
% hObject    handle to gobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateResults(hObject, eventdata, handles)



function patternA2_Callback(hObject, eventdata, handles)
% hObject    handle to patternA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of patternA2 as text
%        str2double(get(hObject,'String')) returns contents of patternA2 as a double
contents = cellstr(get(handles.Main_mode,'String'));
switch contents{get(handles.Main_mode,'Value')}
    case 'Single Residue'
        handles.Pattern{1}={{get(handles.patternA1,'String')}};
    case {'Base Pair','Unbonded Segment(s)'}
        handles.Pattern{1}={{get(handles.patternA1,'String')}};        
        handles.Pattern{2}={{get(handles.patternB,'String')}};
    case {'Triangle','Bonded Segment'}
        handles.Pattern{1}={{get(handles.patternA1,'String'),...
            get(handles.patternA2,'String')}};
        handles.Pattern{2}={{get(handles.patternB,'String')}};
    case 'Mg --> Pi(s)'
        handles.Pattern{1}={{'MG'}};        
        handles.Pattern{2}={{'*'}};
    case 'Pi --> Mg(s)'
        handles.Pattern{1}={{'*'}};        
        handles.Pattern{2}={{'MG'}};
    case 'Mg u-cluster'
        warning('mg u cluster mode is not done yet')
        handles.Pattern{1}={{'*'}};        
        handles.Pattern{2}={{'MG'}};
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function patternA2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patternA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_14_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_15_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_15 (see GCBO)
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


% --- Executes on button press in editchain1.
function editchain1_Callback(hObject, eventdata, handles)
% hObject    handle to editchain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Newresult fig]=NewChain(get(handles.output,'UserData'),1);
if ishandle(fig)
    set(handles.output,'UserData',Newresult)
    delete(fig)
    if ~isempty(Newresult.results{1}.Match)
        chainText=sprintf('%s %s\n','Selected Chain:            ',...
            Newresult.Settings{1}.chain, 'Center of Mass Method: ',...
            Newresult.Settings{1}.CenterOfMassMethod,'Pattern:               ',...
            [Newresult.Settings{1}.Pattern{1}{1} '    ' Newresult.Settings{1}.Pattern{2}{1}],...
            'Search Method:           ',Newresult.Settings{1}.SearchMethod,'Cutoff:                    ',...
            Newresult.Settings{1}.cutoff);
        set(handles.chain1text,'String',chainText)
    else
        set(handles.chain1text,'String','No results. Try again.')   
    end
end



% --- Executes on button press in editchain2.
function editchain2_Callback(hObject, eventdata, handles)
% hObject    handle to editchain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Newresult fig]=NewChain(get(handles.output,'UserData'),2);
if ishandle(fig)
    set(handles.output,'UserData',Newresult)
    delete(fig)
    if ~isempty(Newresult.results{2}.Match)
        chainText=sprintf('%s %s\n','Selected Chain:            ',...
            Newresult.Settings{2}.chain, 'Center of Mass Method: ',...
            Newresult.Settings{2}.CenterOfMassMethod,'Pattern:               ',...
            [Newresult.Settings{2}.Pattern{1}{1} '    ' Newresult.Settings{2}.Pattern{2}{1}],...
            'Search Method:           ',Newresult.Settings{2}.SearchMethod,'Cutoff:                    ',...
            Newresult.Settings{2}.cutoff);
        set(handles.chain2text,'String',chainText)
    else
        set(handles.chain2text,'String','No results. Try again.')
    end
end

% --- Executes on button press in editchain3.
function editchain3_Callback(hObject, eventdata, handles)
% hObject    handle to editchain3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Newresult fig]=NewChain(get(handles.output,'UserData'),3);
if ishandle(fig)
    set(handles.output,'UserData',Newresult)
    delete(fig)
    if ~isempty(Newresult.results{3}.Match)
        chainText=sprintf('%s %s\n','Selected Chain:            ',...
            Newresult.Settings{3}.chain, 'Center of Mass Method: ',...
            Newresult.Settings{3}.CenterOfMassMethod,'Pattern:               ',...
            [Newresult.Settings{3}.Pattern{1}{1} '    ' Newresult.Settings{3}.Pattern{2}{1}],...
            'Search Method:           ',Newresult.Settings{3}.SearchMethod,'Cutoff:                    ',...
            Newresult.Settings{3}.cutoff);
        set(handles.chain3text,'String',chainText)
    else
        set(handles.chain3text,'String','No results. Try again.')
    end
end

% --- Executes on button press in editchain4.
function editchain4_Callback(hObject, eventdata, handles)
% hObject    handle to editchain4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Newresult fig]=NewChain(get(handles.output,'UserData'),4);
if ishandle(fig)
    set(handles.output,'UserData',Newresult)
    delete(fig)
    if ~isempty(Newresult.results{4}.Match)
        chainText=sprintf('%s %s\n','Selected Chain:            ',...
            Newresult.Settings{4}.chain, 'Center of Mass Method: ',...
            Newresult.Settings{4}.CenterOfMassMethod,'Pattern:               ',...
            [Newresult.Settings{4}.Pattern{1}{1} '    ' Newresult.Settings{4}.Pattern{2}{1}],...
            'Search Method:           ',Newresult.Settings{4}.SearchMethod,'Cutoff:                    ',...
            Newresult.Settings{4}.cutoff);
        set(handles.chain4text,'String',chainText)
    else
        set(handles.chain4text,'String','No results. Try again.')
    end
end


% --- Executes on button press in protobuttun.
function protobuttun_Callback(hObject, eventdata, handles)
% hObject    handle to protobuttun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of protobuttun
result=get(handles.output,'UserData');
% dbstop in ARSMIgui.m
disp('end debug')

% --- Executes on selection change in CloseA.
function CloseA_Callback(hObject, eventdata, handles)
% hObject    handle to CloseA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CloseA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CloseA


% --- Executes during object creation, after setting all properties.
function CloseA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CloseA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CloseB.
function CloseB_Callback(hObject, eventdata, handles)
% hObject    handle to CloseB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CloseB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CloseB


% --- Executes during object creation, after setting all properties.
function CloseB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CloseB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in closego.
function closego_Callback(hObject, eventdata, handles)
% hObject    handle to closego (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
h=PleaseWait();
chains=[get(handles.CloseA,'Value'),get(handles.CloseB,'Value')];
cutoff=str2double(get(handles.closecutoff,'String'));

results=[result.results{chains(1)},result.results{chains(2)}];
model=[result.Model{chains(1)},result.Model{chains(2)}];
settings.cutoff=cutoff;
contents = cellstr(get(handles.SearchMenu,'String'));
settings.SearchMethod=contents{get(handles.SearchMenu,'Value')};

switch settings.SearchMethod
    case 'Linear'
        Intermediate=results.Linear(model,settings);

    case 'Triangle [2A,B]'
%         Intermediate.Triangle(result.Model{1}.pa.Position)
        ErrorBoxGUI('title','Unfinished feature','String','not done yet.')
        delete(h)
        return
    case 'Triangle [A,2B]'
        ErrorBoxGUI('title','Unfinished feature','String','not done yet.')
        delete(h)
        return
    otherwise
        disp('this isn''t really possible')
end
result.Intermediate(chains(1),chains(2)).Whole=Intermediate;

set(handles.output,'UserData',result)
interstr=sprintf('%s\n%s',strcat(get(handles.IntermediateText,'String')),['chain ' num2str(chains(1)) '+' num2str(chains(2))]);
set(handles.IntermediateText,'String',interstr)
set(handles.MgclusterGO,'Visible','on')
set(handles.text9,'Visible','on')
set(handles.mgPDist,'Visible','on')
set(handles.IntermediateText,'Visible','on')
delete(h)

function closecutoff_Callback(hObject, eventdata, handles)
% hObject    handle to closecutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of closecutoff as text
%        str2double(get(hObject,'String')) returns contents of closecutoff as a double


% --- Executes during object creation, after setting all properties.
function closecutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to closecutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in WriteIntermediate.
function WriteIntermediate_Callback(hObject, eventdata, handles)
% hObject    handle to WriteIntermediate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
chains=[get(handles.CloseA,'Value'),get(handles.CloseB,'Value')];

result.Intermediate(chains(1),chains(2)).Whole.WriteToFile(result.ID,0);


% --- Executes on button press in overlapGO.
function overlapGO_Callback(hObject, eventdata, handles)
% hObject    handle to overlapGO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in overlap1.
function overlap1_Callback(hObject, eventdata, handles)
% hObject    handle to overlap1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overlap1


% --- Executes on button press in overlap2.
function overlap2_Callback(hObject, eventdata, handles)
% hObject    handle to overlap2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overlap2


% --- Executes on button press in overlap3.
function overlap3_Callback(hObject, eventdata, handles)
% hObject    handle to overlap3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overlap3


% --- Executes on button press in overlap4.
function overlap4_Callback(hObject, eventdata, handles)
% hObject    handle to overlap4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overlap4


% --- Executes on button press in MgclusterGO.
function MgclusterGO_Callback(hObject, eventdata, handles)
% hObject    handle to MgclusterGO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% result=get(handles.output,'UserData');
% h=PleaseWait();
% Pattern=result.Intermediate(1,2).Whole.Pattern_Index;
% Match=result.Intermediate(1,2).Whole.Match_Index;
% 
% 
% for i=1:length(Pattern)
%     keep=zeros(length(Pattern),length(Match{i}));
%     for mg=1:2
%         posMg=result.Model{1}.chain.residues.Position{Pattern{i}(mg)};
%         cutoff=str2double(get(handles.mgPDist,'String'));
%         for j=1:length(Match{i})
%             posRes=result.Model{2}.chain.residues.Position{Match{i}(j)};           
%             R=[posMg;posRes];
%             num_Res=length(R);
%             x=repmat(R(:,1),[1 num_Res]);
%             y=repmat(R(:,2),[1 num_Res]);
%             z=repmat(R(:,3),[1 num_Res]);
%             deltax=x-x';
%             deltay=y-y';
%             deltaz=z-z';
%             Distances=sqrt(deltax.^2+deltay.^2+deltaz.^2);
%             Distances(Distances==0)=NaN;
%             
%             posP1=result.Model{2}.chain.residues.Position{Match{i}(j)}(1,:);
%             distMgP1=sqrt(sum((posMg-posP1).^2));
%             if distMgP1 < cutoff
%                 [~, I]=min(Distances(1,:));
%                 X=result.Model{1}.chain.residues.Atoms(Match{i}(j));
%                 if strcmp(X(I-1).chemSymbol,'O')
%                     Distances(:,I)=NaN;
%                     [~, I]=min(Distances(I,:));
%                     if strcmp(X(I-1).chemSymbol,'P')
%                         Distances(:,I)=NaN;
%                         [~, I]=min(Distances(I,:));
%                         if strcmp(X(I-1).chemSymbol,'O')
%                             Distances(:,I)=NaN;
%                             [~, I]=min(Distances(I,:));
%                             if strcmp(X(I-1).chemSymbol,'O')
%                                 Distances(:,I)=NaN;
%                                 [~, I]=min(Distances(I,:));
%                                 if strcmp(X(I-1).chemSymbol,'C') && ...
%                                         strcmp(X(I-1).remoteInd,'5')
%                                     Distances(:,I)=NaN;
%                                     [~, I]=min(Distances(I,:));
%                                     if strcmp(X(I-1).chemSymbol,'C') && ...
%                                             strcmp(X(I-1).remoteInd,'4')
%                                         Distances(:,I)=NaN;
%                                         [~, I2]=min(Distances(I,:));
%                                         Distances(:,I2)=NaN;
%                                         [~, I]=min(Distances(I,:));
%                                         if strcmp(X(I-1).chemSymbol,'C') && ...
%                                                 strcmp(X(I-1).remoteInd,'3')
%                                             Distances(:,I)=NaN;
%                                             [~, I]=min(Distances(I,:));
%                                             if strcmp(X(I-1).chemSymbol,'O') && ...
%                                                     strcmp(X(I-1).remoteInd,'3')
%                                                 
%                                                 Y=result.Model{1}.chain.residues.Atoms(Match{i}(j)+1);
%                                                 if strcmp(Y(1).chemSymbol,'P')
%                                                     posP2=result.Model{2}.chain.residues.Position{Match{i}(j)+1}(1,:);
%                                                     distMgP2=sqrt(sum((posMg-posP2).^2));
%                                                     if distMgP2 < cutoff
%                                                         keep(i,j)=1;
%                                                     end
%                                                 else
%                                                     break
%                                                 end
%                                             else
%                                                 break
%                                             end
%                                         else
%                                             break
%                                         end
%                                     else
%                                         break
%                                     end
%                                 else
%                                     break
%                                 end
%                             else
%                                 break
%                             end
%                         else
%                             break
%                         end
%                     else
%                         break
%                     end
%                 else
%                     break
%                 end
%             end
%         end
%     end
%     Match_Index{i}=Match{i}(logical(keep(i,:)));
%     Match_Index{i}= [Match_Index{i}, Match_Index{i}+1];
%     result.Intermediate(1,2).Whole.Match{i}=result.Intermediate(1,2).Whole.Match{i}(logical(keep(i,:)));
%     result.Intermediate(1,2).Whole.Match{i}=[result.Intermediate(1,2).Whole.Match{i},result.Intermediate(1,2).Whole.Match{i}+1];
%     if isempty(Match_Index{i})
%         deleteRes(i)=1;
%     end
% end
%         
% if exist('deleteRes','var')
%     Pattern(logical(deleteRes))=[];
%     result.Intermediate(1,2).Whole.Pattern(logical(deleteRes))=[];
%     result.Intermediate(1,2).Whole.Match(logical(deleteRes))=[];
%     Match_Index(logical(deleteRes))=[];    
% end
% result.Intermediate(1,2).Whole.Pattern_Index{1}=Pattern;
% result.Intermediate(1,2).Whole.Match_Index=Match_Index;
% set(handles.output,'UserData',result);
% if ishandle(h)
%     delete(h);
% end


function mgPDist_Callback(hObject, eventdata, handles)
% hObject    handle to mgPDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mgPDist as text
%        str2double(get(hObject,'String')) returns contents of mgPDist as a double


% --- Executes during object creation, after setting all properties.
function mgPDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mgPDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Main_mode.
function Main_mode_Callback(hObject, eventdata, handles)
% hObject    handle to Main_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Main_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Main_mode
contents = cellstr(get(hObject,'String'));
switch contents{get(hObject,'Value')}
    case 'Single Residue'
        handles.numChains=1;
        set(handles.chainA,'Visible','on')
        set(handles.patternA1,'Visible','on')
        set(handles.chainB,'Visible','off')
        set(handles.patternA2,'Visible','off')
        set(handles.patternB,'Visible','off')
        set(handles.textA1A2,'Visible','off')
        set(handles.textA2B,'Visible','off')
        set(handles.textA1B,'Visible','off')
        set(handles.chainpanel1,'Visible','off')
        set(handles.chainpanel2,'Visible','off')
        set(handles.chainpanel3,'Visible','off')
        set(handles.chainpanel4,'Visible','off')
        set(handles.closecontactpanel,'Visible','off')
        handles.CenterofMassMethod={'Whole'};
        set(handles.cutoffEdit,'String','0')
        handles.SearchMethod={'Identity'};
        handles.Pattern{1}={{get(handles.patternA1,'String')}};
    case 'Unbonded Segment(s)' 
        handles.numChains=2;
        set(handles.chainA,'Visible','on')       
        set(handles.patternA1,'Visible','on')
        set(handles.chainB,'Visible','on')
        set(handles.patternA2,'Visible','off')
        set(handles.patternB,'Visible','on')
        set(handles.textA1A2,'Visible','off')
        set(handles.textA2B,'Visible','off')
        set(handles.textA1B,'Visible','on')
        set(handles.chainpanel1,'Visible','off')
        set(handles.chainpanel2,'Visible','off')
        set(handles.chainpanel3,'Visible','off')
        set(handles.chainpanel4,'Visible','off')
        set(handles.closecontactpanel,'Visible','off')
        handles.CenterofMassMethod={'Base only','Base only'};
        set(handles.cutoffEdit,'String','6')           
        handles.SearchMethod={'Identity','Identity'};
        handles.Pattern{1}={{get(handles.patternA1,'String')}};        
        handles.Pattern{2}={{get(handles.patternB,'String')}};
    case 'Base Pair'
        handles.numChains=2;
        set(handles.chainA,'Visible','on')       
        set(handles.patternA1,'Visible','on')
        set(handles.chainB,'Visible','on')
        set(handles.patternA2,'Visible','off')
        set(handles.patternB,'Visible','on')
        set(handles.textA1A2,'Visible','off')
        set(handles.textA2B,'Visible','off')
        set(handles.textA1B,'Visible','on')
        set(handles.chainpanel1,'Visible','off')
        set(handles.chainpanel2,'Visible','off')
        set(handles.chainpanel3,'Visible','off')
        set(handles.chainpanel4,'Visible','off')
        set(handles.closecontactpanel,'Visible','off')
        handles.CenterofMassMethod={'Base only','Base only'};
        set(handles.cutoffEdit,'String','6')           
        handles.SearchMethod={'Identity','Identity'};
        handles.Pattern{1}={{get(handles.patternA1,'String')}};        
        handles.Pattern{2}={{get(handles.patternB,'String')}};
    case 'Bonded Segment'
        handles.numChains=1;
        set(handles.chainA,'Visible','on')
        set(handles.patternA1,'Visible','on')
        set(handles.chainB,'Visible','off')
        set(handles.patternA2,'Visible','on')
        set(handles.patternB,'Visible','off')
        set(handles.textA1A2,'Visible','on')
        set(handles.textA2B,'Visible','off')
        set(handles.textA1B,'Visible','off')
        set(handles.chainpanel1,'Visible','off')
        set(handles.chainpanel2,'Visible','off')
        set(handles.chainpanel3,'Visible','off')
        set(handles.chainpanel4,'Visible','off')
        set(handles.closecontactpanel,'Visible','off')
        handles.CenterofMassMethod={'Base only'};
        set(handles.cutoffEdit,'String','6')        
        handles.SearchMethod={'BondedSegment'};
        handles.Pattern{1}={{get(handles.patternA1,'String'),...
            get(handles.patternA2,'String')}};
    case 'Triangle'
        handles.numChains=2;
        set(handles.chainA,'Visible','on')
        set(handles.patternA1,'Visible','on')
        set(handles.chainB,'Visible','on')
        set(handles.patternA2,'Visible','on')
        set(handles.patternB,'Visible','on')
        set(handles.textA1A2,'Visible','on')
        set(handles.textA2B,'Visible','on')
        set(handles.textA1B,'Visible','on')
        set(handles.chainpanel1,'Visible','off')
        set(handles.chainpanel2,'Visible','off')
        set(handles.chainpanel3,'Visible','off')
        set(handles.chainpanel4,'Visible','off')
        set(handles.closecontactpanel,'Visible','off')
        handles.CenterofMassMethod={'Base only','Base only'};
        set(handles.cutoffEdit,'String','6')
        handles.SearchMethod={'BondedSegment','Identity'};
        handles.Pattern{1}={{get(handles.patternA1,'String'),...
            get(handles.patternA2,'String')}};
        handles.Pattern{2}={{get(handles.patternB,'String')}};
    case 'Mg --> Pi(s)'
        handles.numChains=2;
        set(handles.chainA,'Visible','on')
        set(handles.chainB,'Visible','on')
        set(handles.patternA1,'Visible','off')
        set(handles.patternA2,'Visible','off')
        set(handles.patternB,'Visible','off')
        set(handles.textA1A2,'Visible','off')
        set(handles.textA2B,'Visible','off')
        set(handles.textA1B,'Visible','off')
        set(handles.chainpanel1,'Visible','off')
        set(handles.chainpanel2,'Visible','off')
        set(handles.chainpanel3,'Visible','off')
        set(handles.chainpanel4,'Visible','off')
        set(handles.closecontactpanel,'Visible','off')
        handles.CenterofMassMethod={'Magnesium','Phosphate'};
        set(handles.cutoffEdit,'String','4')
        handles.SearchMethod={'Identity','Identity'};
        handles.Pattern{1}={{'MG'}};        
        handles.Pattern{2}={{'*'}};
    case 'Pi --> Mg(s)'
        handles.numChains=2;
        set(handles.chainA,'Visible','on')
        set(handles.chainB,'Visible','on')
        set(handles.patternA1,'Visible','off')
        set(handles.patternA2,'Visible','off')
        set(handles.patternB,'Visible','off')
        set(handles.textA1A2,'Visible','off')
        set(handles.textA2B,'Visible','off')
        set(handles.textA1B,'Visible','off')
        set(handles.chainpanel1,'Visible','off')
        set(handles.chainpanel2,'Visible','off')
        set(handles.chainpanel3,'Visible','off')
        set(handles.chainpanel4,'Visible','off')
        set(handles.closecontactpanel,'Visible','off')
        handles.CenterofMassMethod={'Phosphate','Magnesium'};
        set(handles.cutoffEdit,'String','4')
        handles.SearchMethod={'Identity','Identity'};
        handles.Pattern{1}={{'*'}};        
        handles.Pattern{2}={{'MG'}};
    case 'Mg u-cluster'
        handles.numChains=2;
        set(handles.chainA,'Visible','on')
        set(handles.chainB,'Visible','on')
        set(handles.patternA1,'Visible','off')
        set(handles.patternA2,'Visible','off')
        set(handles.patternB,'Visible','off')
        set(handles.textA1A2,'Visible','off')
        set(handles.textA2B,'Visible','off')
        set(handles.textA1B,'Visible','off')
        set(handles.chainpanel1,'Visible','off')
        set(handles.chainpanel2,'Visible','off')
        set(handles.chainpanel3,'Visible','off')
        set(handles.chainpanel4,'Visible','off')
        set(handles.closecontactpanel,'Visible','off')
        handles.CenterofMassMethod={'Phosphate','Magnesium'};
        set(handles.cutoffEdit,'String','4')
        handles.SearchMethod={'Identity','Identity'};
        handles.Pattern{1}={{'*'}};        
        handles.Pattern{2}={{'MG'}};
    case 'Custom'
        set(handles.chainA,'Visible','off')
        set(handles.chainB,'Visible','off')
        set(handles.patternA1,'Visible','off')
        set(handles.patternA2,'Visible','off')
        set(handles.patternB,'Visible','off')
        set(handles.textA1A2,'Visible','off')
        set(handles.textA2B,'Visible','off')
        set(handles.textA1B,'Visible','off')
        set(handles.chainpanel1,'Visible','on')
        set(handles.chainpanel2,'Visible','on')
        set(handles.chainpanel3,'Visible','on')
        set(handles.chainpanel4,'Visible','on')
        set(handles.closecontactpanel,'Visible','on')
end
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function Main_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Main_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in chainB.
function chainB_Callback(hObject, eventdata, handles)
% hObject    handle to chainB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chainB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chainB


% --- Executes during object creation, after setting all properties.
function chainB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chainB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function patternB_Callback(hObject, eventdata, handles)
% hObject    handle to patternB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of patternB as text
%        str2double(get(hObject,'String')) returns contents of patternB as a double
contents = cellstr(get(handles.Main_mode,'String'));
switch contents{get(handles.Main_mode,'Value')}
    case 'Single Residue'
        handles.Pattern{1}={{get(handles.patternA1,'String')}};
    case {'Base Pair','Unbonded Segment(s)'}
        handles.Pattern{1}={{get(handles.patternA1,'String')}};        
        handles.Pattern{2}={{get(handles.patternB,'String')}};
    case {'Triangle','Bonded Segment'}
        handles.Pattern{1}={{get(handles.patternA1,'String'),...
            get(handles.patternA2,'String')}};
        handles.Pattern{2}={{get(handles.patternB,'String')}};
    case 'Mg --> Pi(s)'
        handles.Pattern{1}={{'MG'}};        
        handles.Pattern{2}={{'*'}};
    case 'Pi --> Mg(s)'
        handles.Pattern{1}={{'*'}};        
        handles.Pattern{2}={{'MG'}};
    case 'Mg u-cluster'
        warning('mg u cluster mode is not done yet')
        handles.Pattern{1}={{'*'}};        
        handles.Pattern{2}={{'MG'}};
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function patternB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patternB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Intermediate=MguCluster(Intermediate,model,cutoff)

Pattern=Intermediate.Pattern_Index;
Match=Intermediate.Match_Index;
Pind=cell2mat(Pattern);
Pind_cut=Pind(1:2:end);
Pind_cut_out=Pind(2:2:end);
Positions{1}=cell2mat(model(1).pa.Position')';%Mg
Positions{2}=cell2mat(model(2).pa.Position')';%Pi
M_ind=cell2mat(Intermediate.Match_Index);
M_orig=cell2mat(Intermediate.Match);

keep=false(1,length(Pind_cut));
PiCandInd=cell(1,length(Pind_cut));
for i=1:length(Pind_cut)
    for j=1:length(Match{i})
        nnP=nearestneighbour(Positions{1}(:,Pind_cut(i)),...
            Positions{2}(:,[Match{i}(j)-1,Match{i}(j)+1]),'r', cutoff);
        if ~isempty(nnP)
            keep(i)=true;
            if isempty(PiCandInd{i})
                PiCandInd{i}(j)=nnP;
            else
                PiCandInd{i}=[PiCandInd{i},nnp];
            end
        end
    end
end

MgCandidates{1}=Pind_cut(keep);
MgCandidates{2}=Pind_cut_out(keep);
PiCandInd=PiCandInd(keep);
OrigPi=Match(keep);
PiCandidates=cell(1,length(OrigPi));
PiCandidates_orig=cell(1,length(OrigPi));
for i=1:length(OrigPi)
    for j=1:length(PiCandInd{i})
        if PiCandInd{i}(j)==1
            PiCandidates{i}=[PiCandidates{i},OrigPi{i}(j),OrigPi{i}(j)-1];
            [~,loc]=ismember([OrigPi{i}(j),OrigPi{i}(j)-1],M_ind);
            PiCandidates_orig{i}=[PiCandidates_orig{i},M_orig(loc(1))];
        elseif PiCandInd{i}(j)==2
            PiCandidates{i}=[PiCandidates{i},OrigPi{i}(j),OrigPi{i}(j)+1];
            [~,loc]=ismember([OrigPi{i}(j),OrigPi{i}(j)+1],M_ind);
            PiCandidates_orig{i}=[PiCandidates_orig{i},M_orig(loc(1))];
        end
    end
end
%fix loc(1)

%check Mg-O distance
Oxygens=cell(2,length(OrigPi));
MgPos=cell(1,length(OrigPi));
Oxygens{1,1}=strfind([model(2).chain.residues.Atoms(PiCandidates{1}(1),:).remoteInd],'P');
Mgucluster=false(1,length(OrigPi));
if ~isempty(Oxygens{1,1})
    for k=1:length(OrigPi)
        MgPos{k}=Positions{1}(:,[MgCandidates{1}(k),MgCandidates{2}(k)]);
        realatoms=[0 0];
        ri1={model(2).chain.residues.Atoms(PiCandidates{k}(1),:).remoteInd};
        for i=1:length(ri1)
            if ischar(ri1{i})
                realatoms(1)=realatoms(1)+1;
            end
        end
        ri2={model(2).chain.residues.Atoms(PiCandidates{k}(2),:).remoteInd};
        for i=1:length(ri2)
            if ischar(ri2{i})
                realatoms(2)=realatoms(2)+1;
            end
        end
        Oxygens{1,k}=model(2).chain.residues.Position{PiCandidates{k}(1)}(ismember({model(2).chain.residues.Atoms(PiCandidates{k}(1),1:realatoms(1)).remoteInd},{'P'}),:)';
        Oxygens{2,k}=model(2).chain.residues.Position{PiCandidates{k}(2)}(ismember({model(2).chain.residues.Atoms(PiCandidates{k}(2),1:realatoms(2)).remoteInd},{'P'}),:)';
        if nearestneighbour(MgPos{k},Oxygens{1,k},'r',2.41)
            if ~isempty(nearestneighbour(MgPos{k},Oxygens{2,k},'r',2.41))
                Mgucluster(k)=1;
            end
        end
    end
else
    for k=1:length(OrigPi)
        MgPos{k}=Positions{1}(:,[MgCandidates{1}(k),MgCandidates{2}(k)]);
        realatoms=[0 0];
        ri1={model(2).chain.residues.Atoms(PiCandidates{k}(1),:).branch};
        for i=1:length(ri1)
            if ischar(ri1{i})
                realatoms(1)=realatoms(1)+1;
            end
        end
        ri2={model(2).chain.residues.Atoms(PiCandidates{k}(2),:).branch};
        for i=1:length(ri2)
            if ischar(ri2{i})
                realatoms(2)=realatoms(2)+1;
            end
        end
        Oxygens{1,k}=model(2).chain.residues.Position{PiCandidates{k}(1)}(ismember({model(2).chain.residues.Atoms(PiCandidates{k}(1),1:realatoms(1)).branch},{'P'}),:)';
        Oxygens{2,k}=model(2).chain.residues.Position{PiCandidates{k}(2)}(ismember({model(2).chain.residues.Atoms(PiCandidates{k}(2),1:realatoms(2)).branch},{'P'}),:)';
        if nearestneighbour(MgPos{k},Oxygens{1,k},'r',2.41)
            if ~isempty(nearestneighbour(MgPos{k},Oxygens{2,k},'r',2.41))
                Mgucluster(k)=1;
            end
        end 
    end
end

[~, b1]=ismember(MgCandidates{1}(Mgucluster),cell2mat(Intermediate.Pattern_Index')');
[~, b2]=ismember(MgCandidates{2}(Mgucluster),cell2mat(Intermediate.Pattern_Index')');
OrigPind=cell2mat(Intermediate.Pattern')';
Intermediate.Pattern_Index=mat2cell(cell2mat(MgCandidates')',ones(1,length(OrigPi)),2)';
Intermediate.Pattern_Index=Intermediate.Pattern_Index(Mgucluster);
MgCandidates_Orig{1}=OrigPind(b1);
MgCandidates_Orig{2}=OrigPind(b2);
Intermediate.Pattern=mat2cell(cell2mat(MgCandidates_Orig')',ones(1,sum(Mgucluster)),2)';
Intermediate.Match=PiCandidates_orig(Mgucluster);
Intermediate.Match_Index=PiCandidates(Mgucluster);

function Intermediate=MguClusterExpand(Intermediate,model)
%put other residues back in

for i=1:length(Intermediate.Pattern_Index)
    Intermediate.Pattern_Index{i}=sort(Intermediate.Pattern_Index{i});
    Intermediate.Pattern{i}=sort(Intermediate.Pattern{i});

end

[B,I]=unique(cell2mat(Intermediate.Pattern_Index'),'rows');
Pattern_Index=B;
Pattern=cell2mat(Intermediate.Pattern(I)');
PosMg=cell2mat(model(1).pa.Position')';
PosAtoms=cell2mat(model(2).chain.residues.Position')';

nnP=nearestneighbour(PosMg(:,Pattern_Index(:)),PosAtoms,'r',2.41);

Match=cell(1,size(nnP,2));
Match_Index=cell(1,size(nnP,2));
for j=1:size(nnP,2)
    Matches=model(2).chain.resSeq(nnP(nnP(:,j)~=0,j));
    [~,Matches_Index]=ismember(Matches,model(2).chain.residues.ListOfResidues);
    Match{j}=Matches(~ismember(model(2).chain.residues.NamesOfResidues(Matches_Index),{'MG','HOH','NA','K','CL'}));
    Match_Index{j}=Matches_Index(~ismember(model(2).chain.residues.NamesOfResidues(Matches_Index),{'MG','HOH','NA','K','CL'}));
end

numHits=size(nnP,2)/2;
NewPattern_Index=cell(1,numHits);
NewPattern=cell(1,numHits);
NewMatch_Index=cell(1,numHits);
NewMatch=cell(1,numHits);
for k=1:numHits
   NewPattern_Index{k}=Pattern_Index(k,:);
   NewPattern{k}=Pattern(k,:);
   NewMatch_Index{k}=unique([Match_Index{k},Match_Index{k+numHits}]);
   NewMatch{k}=unique([Match{k},Match{k+numHits}]);
end

%finish up
Intermediate.RebuildResults(NewPattern,NewMatch,NewPattern_Index,NewMatch_Index);

function Intermediate=CheckMgPdist(model,Intermediate)
    MgPositions=cell2mat(model(1).chain.residues.Position(cell2mat(Intermediate.Pattern_Index))');
    CandRes_Index=cell2mat(Intermediate.Match_Index)';
    CandRes=cell2mat(Intermediate.Match)';
    ResPositions=zeros(2*length(CandRes_Index),3);
    for i=1:length(CandRes_Index)
        ResPositions(2*i-1:2*i,:)=model(2).chain.residues.Position{CandRes_Index(i)}([2,3],:);
    end
    nnP=nearestneighbour(MgPositions',ResPositions','r',2.6-realmin);
    KeepMg=logical(nnP(1,:));
    nnPr=nnP(:,KeepMg);
    
    numMg=sum(KeepMg);
    Match_Index=cell(1,numMg);
    Match=cell(1,numMg);
    for i=1:numMg
        Match_Index{i}=unique(CandRes_Index(ceil(nnPr(nnPr(:,i)>0,i)/2)));        
        Match{i}=unique(CandRes(ceil(nnPr(nnPr(:,i)>0,i)/2)));
    end
    
    Intermediate.Pattern_Index=Intermediate.Pattern_Index(KeepMg);
    Intermediate.Pattern=Intermediate.Pattern(KeepMg);
    Intermediate.Match_Index=Match_Index;
    Intermediate.Match=Match;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
