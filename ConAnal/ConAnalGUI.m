function varargout = ConAnalGUI(varargin)
% CONANALGUI M-file for ConAnalGUI.fig
%      CONANALGUI, by itself, creates a new CONANALGUI or raises the existing
%      singleton*.
%
%      H = CONANALGUI returns the handle to a new CONANALGUI or the handle to
%      the existing singleton*.
%
%      CONANALGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONANALGUI.M with the given input arguments.
%
%      CONANALGUI('Property','Value',...) creates a new CONANALGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConAnalGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConAnalGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConAnalGUI

% Last Modified by GUIDE v2.5 26-Aug-2010 16:22:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConAnalGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ConAnalGUI_OutputFcn, ...
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


% --- Executes just before ConAnalGUI is made visible.
function ConAnalGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConAnalGUI (see VARARGIN)

% Choose default command line output for ConAnalGUI
handles.output = hObject;
handles.map_cutoff=3.4;
handles.clustal_path='/Users/Chad/Applications/clustalw2';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ConAnalGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ConAnalGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles;
%set(handles.figure1,'Visible','on')
set(handles.mapY,'Units','normalized')

% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function alignment_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to alignment_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');

variability=obj.Output.Variability;

if get(handles.pdb_radio,'Value')
    sequence=obj.Output.Alignment(obj.Output.species3D).Sequence;
    whole=1:length(sequence);
    remove=strfind(sequence,'-');
    variability(remove)=[];
    keep=find(variability<=str2double(get(handles.filter_cutoff,'String')));
    list=unique([obj.Output.Protein.FAM.Model.resSeq]);
    [~,index]=ismember(keep,list);
    index(index==0)=[];
    keep=list(index);
else
    keep=find(variability<=str2double(get(handles.filter_cutoff,'String')));
end

Pfilter=get(handles.peptide_filter,'String');    
PFstrings=cellstr(strread(Pfilter,'%s'));
ranges=str2double(PFstrings);
if mod(length(ranges),2)
     ErrorBoxGUI('Title','Error','string',['Peptide Filter must contain an',...
        ' even number of inputs, separated by spaces.'])
else
    KeepResCell=cell(1,length(ranges)/2);
    for i=1:length(ranges)/2
        KeepResCell{i}=colon(ranges(2*i-1),ranges(2*i));
    end
    KeepRes=cell2mat(KeepResCell);
end

if ~isempty(KeepRes)
    Keep=intersect(keep,KeepRes);
else
    Keep=keep;
end

if get(handles.pdb_radio,'Value')
    Remaining=whole;
    Remaining(remove)=[];
    Keep=Remaining(Keep);
end

Alignment=obj.Output.Alignment;
for i=1:length(Alignment)
    Alignment(i).Sequence=Alignment(i).Sequence(Keep);
end
showalignment(Alignment)

% --------------------------------------------------------------------
function file_open_Callback(hObject, eventdata, handles)
% hObject    handle to file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function map_cutoff_view_Callback(hObject, eventdata, handles)
% hObject    handle to map_cutoff_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mapcutoff=inputdlg({'Enter map cutoff distance'},'Edit map cutoff',...
    1,{num2str(handles.map_cutoff)});
if ~isempty(mapcutoff)
    handles.map_cutoff=str2double(mapcutoff{1});
end

% --------------------------------------------------------------------
function path_to_clustalw_Callback(hObject, eventdata, handles)
% hObject    handle to path_to_clustalw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile({'*.*'},'Select clustalw',...
    'MultiSelect', 'off');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    handles.clustal_path=fullfile(PathName,FileName);
end

% --------------------------------------------------------------------
function export_results_Callback(hObject, eventdata, handles)
% hObject    handle to export_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
    set(hObject,'Checked','on')
    if strcmp(get(handles.alignment_menu_item,'Enable'),'on')
        obj=get(handles.output,'UserData');
        assignin('base',get(handles.pdb_file_text,'String'),obj.Output)
    end
else
    set(hObject,'Checked','off')
end

% --- Executes on selection change in AlignMethod.
function AlignMethod_Callback(hObject, eventdata, handles)
% hObject    handle to AlignMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AlignMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AlignMethod


% --- Executes during object creation, after setting all properties.
function AlignMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AlignMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function CenterX_Callback(hObject, eventdata, handles)
% hObject    handle to CenterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CenterX as text
%        str2double(get(hObject,'String')) returns contents of CenterX as a double


% --- Executes during object creation, after setting all properties.
function CenterX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CenterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CenterY_Callback(hObject, eventdata, handles)
% hObject    handle to CenterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CenterY as text
%        str2double(get(hObject,'String')) returns contents of CenterY as a double


% --- Executes during object creation, after setting all properties.
function CenterY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CenterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CenterZ_Callback(hObject, eventdata, handles)
% hObject    handle to CenterZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CenterZ as text
%        str2double(get(hObject,'String')) returns contents of CenterZ as a double


% --- Executes during object creation, after setting all properties.
function CenterZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CenterZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in shell_boundaries_menu.
function shell_boundaries_menu_Callback(hObject, eventdata, handles)
% hObject    handle to shell_boundaries_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns shell_boundaries_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from shell_boundaries_menu
contents = cellstr(get(hObject,'String'));
switch contents{get(hObject,'Value')}
    case 'Ribosome Standard'
        set(handles.custom_shells,'Visible','off')
    case 'Custom'
        set(handles.custom_shells,'Visible','on')
    otherwise
        set(handles.custom_shells,'Visible','off')
end

% --- Executes during object creation, after setting all properties.
function shell_boundaries_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shell_boundaries_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in variability_bins_menu.
function variability_bins_menu_Callback(hObject, eventdata, handles)
% hObject    handle to variability_bins_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns variability_bins_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variability_bins_menu
contents = cellstr(get(hObject,'String'));
switch contents{get(hObject,'Value')}
    case 'Standard'
        set(handles.custom_bins,'Visible','off')
    case 'Custom'
        set(handles.custom_bins,'Visible','on')
    otherwise
        set(handles.custom_bins,'Visible','off')
end

% --- Executes during object creation, after setting all properties.
function variability_bins_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variability_bins_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function custom_bins_Callback(hObject, eventdata, handles)
% hObject    handle to custom_bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of custom_bins as text
%        str2double(get(hObject,'String')) returns contents of custom_bins as a double


% --- Executes during object creation, after setting all properties.
function custom_bins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to custom_bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function custom_shells_Callback(hObject, eventdata, handles)
% hObject    handle to custom_shells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of custom_shells as text
%        str2double(get(hObject,'String')) returns contents of custom_shells as a double


% --- Executes during object creation, after setting all properties.
function custom_shells_CreateFcn(hObject, eventdata, handles)
% hObject    handle to custom_shells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function load_gene_list_Callback(hObject, eventdata, handles)
% hObject    handle to load_gene_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

obj=get(handles.output,'UserData');
if strcmp(class(obj),'double')
    obj=ConAnalUserData('unnamed');
end
if ~isempty(obj.gene_list_file)
    file=obj.gene_list_file;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.xls;*.xlsx;*.xlsb;*.xlsm;*.csv',...
    'Supported Files';'*.*','All files'},'Select the Excel or CSV File',file);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    try
        gene_list=importdata([PathName,FileName]);
    catch
        ErrorBoxGUI('title','User Error','string',...
            'The Input is not in the proper format. Please fix it and try again.')
        return
    end
    obj.gene_list=gene_list;
    obj.gene_list_file=fullfile(PathName,FileName);
%     obj.gene_list_path=PathName;
    [~,filename]=fileparts(obj.gene_list_file);
    set(handles.gene_list_text,'String',filename)
    set(handles.Alignment_panel,'Visible','on')
    set(handles.filter_panel,'Visible','on')
    set(handles.gobutton,'Visible','on')
    set(handles.load_pdb_file,'Enable','on')
    set(handles.output,'UserData',obj)
end   


% --------------------------------------------------------------------
function load_pdb_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_pdb_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

obj=get(handles.output,'UserData');
if ~isempty(obj.pdb_file)
    file=obj.pdb_file;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.pdb';'*.*'},'Select the PDB File',file);
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
    chains=sort(unique([pdb.Model.Atom.chainID]));
    chainIDs=cell(1,length(chains));
    for i=1:length(chains)
        chainIDs{i}=chains(i);
    end
    obj.pdb=pdb;
    obj.pdb_file=file;
%     obj.pdb_path=PathName;
    set(handles.pdb_file_text,'String',name);
    set(handles.ChainIDedit,'String',chainIDs);
    delete(h)
    set(handles.P1_panel,'Visible','on')
    set(handles.P1_chain_panel,'Visible','on')
    set(handles.reference_frame,'Visible','on')
    set(handles.pdb_radio,'Enable','On')    
    set(handles.map_onto_menu,'Enable','on')
    set(handles.output,'UserData',obj)
end



% --------------------------------------------------------------------
function load_alignment_Callback(hObject, eventdata, handles)
% hObject    handle to load_alignment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

obj=get(handles.output,'UserData');
if strcmp(class(obj),'double')
    obj=ConAnalUserData('unnamed');
end
if ~isempty(obj.alignment_file)
    file=obj.alignment_file;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.*','All files'},'Select the alignment',file);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    file=fullfile(PathName,FileName);
    [~,name,ext]=fileparts(file);
    try    
        if strcmp(ext,'.fasta')
            alignment=fastaread(file);
        else
            alignment=multialignread(file);
        end
    catch
        ErrorBoxGUI('title','User Error','string',...
            'The Input is not in the proper format. Please fix it and try again.')
        return
    end
    obj.Output.Alignment=alignment;
    obj.alignment_file=file;
    %obj.alignment_path=PathName;
    set(handles.alignment_text,'String',name)
    set(handles.AlignMethod,'Value',2)
    set(handles.filter_panel,'Visible','on')
    set(handles.Alignment_panel,'Visible','on')
    set(handles.gobutton,'Visible','on')    
    set(handles.load_pdb_file,'Enable','on')
    set(handles.output,'UserData',obj)
end


% --- Executes on button press in gobutton.
function gobutton_Callback(hObject, eventdata, handles)
% hObject    handle to gobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

obj=get(handles.output,'UserData');


if get(handles.AlignMethod,'Value')~=2 && strcmp(get(handles.gene_list_text,'String'),'unloaded')
    ErrorBoxGUI('title','User Error','string',...
        'Please load a gene list, or choose the previous alignment method.')
    return
end

if get(handles.AlignMethod,'Value')==2 && strcmp(get(handles.alignment_text,'String'),'unloaded')
    ErrorBoxGUI('title','User Error','string',...
        'Please load an alignment file, or choose another alignment method.')
    return
end

if get(handles.AlignMethod,'Value')==2
    gene_list=[];
    options.Method='alignment';
    options.alignment_file=obj.alignment_file;
else
    gene_list=obj.gene_list;
end
newcenter=[str2double(get(handles.CenterX,'String')),...
    str2double(get(handles.CenterY,'String')),...
    str2double(get(handles.CenterZ,'String'))];
if get(handles.AlignMethod,'Value')==1
    options.Method='clustal';
end
options.Name=get(handles.pdb_file_text,'String');
options.Path=handles.clustal_path;
if ~strcmp(get(handles.pdb_file_text,'String'),'unloaded')
    options.File=obj.pdb_file;
    if get(handles.shell_boundaries_menu,'Value')==1
        shellboundaries='ribosome';
    else
        Cshells=get(handles.custom_shells,'String');
        CSstrings=cellstr(strread(Cshells,'%s'));
        shellboundaries=str2double(CSstrings);
    end
else
    newcenter=[];
    if strcmp(get(handles.gene_list_text,'String'),'unloaded')
        shellboundaries=get(handles.alignment_text,'String');  
    else
        if strcmp(get(handles.alignment_text,'String'),'unloaded')
            shellboundaries=get(handles.gene_list_text,'String');  
        else
            shellboundaries=get(handles.alignment_text,'String');
        end
    end

end

if get(handles.variability_bins_menu,'Value')==1
    variability_bins='standard';
else
    Cbins=get(handles.custom_bins,'String');
    CBstrings=cellstr(strread(Cbins,'%s'));
    variability_bins=str2double(CBstrings);
end
h=PleaseWait();

 try
% [ CAOut] = ConAnal(gene_list,newcenter,options,...
%     shellboundaries,variability_bins);


    
if exist('options','var') && isfield(options,'Method') && strcmp(options.Method,'alignment')
    %if ~isempty(obj.Output.Alignment) && ~exist(options.alignment_file,'file')
    Alignment=obj.Output.Alignment;
    %else
    %    Alignment=multialignread(options.alignment_file);
   % end
else
    num_genes=length(gene_list);
    Sequences(num_genes).Header=[];
    Sequences(num_genes).Sequence=[];

    for i=1:num_genes
        if iscell(gene_list)
            GenePept(i)=getgenpept(gene_list{i});
        else
            GenePept(i)=getgenpept(gene_list(i));
        end
        Sequences(i).Sequence=GenePept(i).Sequence;
        source=GenePept(i).Source;
        source(isspace(source))='_';
        Sequences(i).Header=source;
    end

    if exist('options','var') && isfield(options,'Method') && strcmp(options.Method,'clustal')
        if exist([options.Name,'.fa'],'file')
            recycle('on');
            delete([options.Name,'.fa']);
        end
        fastawrite([options.Name,'.fa'],Sequences);
        command=[options.Path,' -INFILE=',options.Name,'.fa',' -OUTORDER=INPUT -QUIET'];
        system(command);
        Alignment=multialignread([options.Name,'.aln']);
    else
        Alignment=multialign(Sequences,'ScoringMatrix','gonnet','GapOpen',...
            10,'ExtendGap',0.2);
    end
end

cSequence=seqconsensus(Alignment,'gaps','all');
Variability=ShannonEntropy(Alignment);
variability=Variability;
%cSequenceCut=cSequence;
if ~isempty(newcenter)
    if ~exist(options.File,'file') && ~isempty(obj.pdb)
        FAM=FullAtomModel(options.Name);                                                 % Instantiate
        FAM.PopulateFAM(obj.pdb);
        FAMs{1}=FAM;
    else
        FAMs=ImportPDBs(options.File);
        FAM=FAMs{1};
    end
    FAM_chain=FullAtomModel([options.Name,'_cut']);
    chains=get(handles.ChainIDedit,'String');
    chain_sele=chains{get(handles.ChainIDedit,'Value')};
    FAM_chain.CutFAM(strfind([FAM.Model.chainID],chain_sele),FAM);
    species3D=MatchSequence(Alignment,FAM_chain);
    sequence=Alignment(species3D).Sequence;
    variability(strfind(sequence,'-'))=[];
    %cSequenceCut(strfind(sequence,'-'))=[];
end

if ~isempty(newcenter)
    if ~exist(options.File,'file') && ~isempty(obj.pdb)
        FAM=FullAtomModel(options.Name);                                                 % Instantiate
        FAM.PopulateFAM(obj.pdb);
        FAMs{1}=FAM;
    else
        FAMs=ImportPDBs(options.File);
    end    
    numProteins=length(FAMs);
    if strcmp(shellboundaries,'ribosome')
        shellboundaries=[0,20+realmin,40+realmin,60+realmin,80+realmin,...
            100+realmin,120+realmin,140+realmin,Inf];
%         shellboundaries=[0 10+realmin,20+realmin,30+realmin,40+realmin,...
%             50+realmin,60+realmin,70+realmin,80+realmin,90+realmin,100+realmin,...
%             110+realmin,120+realmin,130+realmin,140+realmin,Inf];
    end
else
    numProteins=1;
end
Proteins(numProteins,1)=Protein('init');

for i=1:numProteins   
    if ~isempty(newcenter)
        Proteins(i)=Protein(FAMs{i}.Name);
        Proteins(i).PopulateProtein(FAM_chain(i));
        Proteins(i).ReCenter(newcenter);
        Proteins(i).DistanceFromCenter();
%         InPDB=unique([Proteins(i).FAM.Model.resSeq]);
%         variability=variability(InPDB);
%         cSequence=cSequence(InPDB);
        Proteins(i).binShells(shellboundaries);
    else
        %recycle shell_boundaries for name
        Proteins(i)=Protein(shellboundaries);
%         variability=variability;
%         cSequence=cSequence;
    end    
    Proteins(i).addConsensusSequence(cSequence);
    Proteins(i).addVariability(variability);
    H=figure('Name',['Protein Variability (',Proteins(i).Name,')'],'NumberTitle','off');
    set(H,'Units','Normalized')
    set(H,'Position',[.1 .2 .2 .7])
    Proteins(i).PlotVariability(variability_bins);
end

CAOut=ConAnalOutput(Proteins,Alignment,Variability);
if ~isempty(newcenter)
    CAOut.AddSpecies3D(species3D);
end

drawnow
if ~strcmp(get(handles.pdb_file_text,'String'),'unloaded')  
%     chains1=get(handles.ChainIDedit,'String');
%     chain1=chains1{get(handles.ChainIDedit,'Value')};
%     CAOut.CreateRamachandran(obj.pdb,chain1,'none')
    if ~strcmp(get(handles.pdb_file2_text,'String'),'unloaded')
        chains2=get(handles.ChainID2edit,'String');
        chain2=chains2{get(handles.ChainID2edit,'Value')};
%         map = MapContacts([obj.pdb_path,obj.pdb_file],...
%             [obj.pdb_path2,obj.pdb_file2],chain2,...
%             str2double(handles.map_cutoff));
%         CAOut.AddContactMap(map);
        %begin filtering             
        variability=CAOut.Variability;
        sequence=CAOut.Alignment(CAOut.species3D).Sequence;
        whole=1:length(sequence);
        remove=strfind(sequence,'-');
        newindices=whole;
        newindices(remove)=[];
        variability(remove)=[];
        keep=find(variability<=str2double(get(handles.filter_cutoff,'String')));        
        Pfilter=get(handles.peptide_filter,'String');
        PFstrings=cellstr(strread(Pfilter,'%s'));
        ranges=str2double(PFstrings);
        if mod(length(ranges),2)
            ErrorBoxGUI('Title','Error','string',['Peptide Filter must contain an',...
                ' even number of inputs, separated by spaces.'])
        else
            KeepResCell=cell(1,length(ranges)/2);
            for i=1:length(ranges)/2
                KeepResCell{i}=colon(ranges(2*i-1),ranges(2*i));
            end
            KeepRes=cell2mat(KeepResCell);
        end
        if get(handles.alignment_radio,'Value') && ~isempty(KeepRes)
            [~,KeepRes]=ismember(KeepRes,newindices);
        end        
        if ~isempty(KeepRes)
            Keep=intersect(keep,KeepRes);
            Keep(Keep==0)=[];
        else
            Keep=keep;
        end
        list=unique([CAOut.Protein.FAM.Model.resSeq]);
        [~,index]=ismember(Keep,list);
        index(index==0)=[];
        if ~exist(options.File,'file') && ~isempty(obj.pdb)
            pdb1 = PDBentry('name1');
            pdb2 = PDBentry('name2');
            pdb1.PDBfromStruct(obj.pdb,'newID1')
            pdb2.PDBfromStruct(obj.pdb2,'newID2')
            Newmap = MapContacts(pdb1,pdb2,chain2,...
                handles.map_cutoff,index);
        else
            Newmap = MapContacts(obj.pdb_file,obj.pdb2_file,chain2,...
                handles.map_cutoff,index);
        end
        CAOut.AddContactMapFiltered(Newmap,str2double(get(handles.filter_cutoff,'String')));
        myData(:,1)=CAOut.FilteredMap.Y(:,1);
        for i=1:size(myData,1)
            myData{i,2}=mat2str(CAOut.FilteredMap.Y{i,2});
        end
        myData(:,3)=CAOut.FilteredMap.Y(:,3);
        set(handles.mapY,'data',myData)
        
    end
    CAOut.AddPDB(obj.pdb,chain_sele);
end
success=true;
catch
    success=false;
    ErrorBoxGUI('title','Unknown Error','string',...
        'Unknown Error. Please check all inputs and error messages.')
end
delete(h);


if success
    obj.Output=CAOut;
    set(handles.output,'UserData',obj)
    set(handles.alignment_menu_item,'Enable','On')
    set(handles.view_cladogram,'Enable','On') 
    set(handles.view_logo,'Enable','On') 
    set(handles.view_variability,'Enable','On') 
    if ~strcmp(get(handles.pdb_file_text,'String'),'unloaded')  
        set(handles.view_ramachandran,'Enable','On') 
    end
    if ~strcmp(get(handles.pdb_file2_text,'String'),'unloaded')  
        set(handles.view_map,'Enable','On') 
        set(handles.refilter_map,'Visible','On')
    end
    if strcmp(get(handles.export_results,'Checked'),'on')
        assignin('base',CAOut.Name,obj.Output)
    end
end

% --------------------------------------------------------------------
function view_cladogram_Callback(hObject, eventdata, handles)
% hObject    handle to view_cladogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
Alignment=obj.Output.Alignment;
if strcmp(get(handles.allow_filtered_cladogram,'Checked'),'on')
    variability=obj.Output.Variability;
    keep= variability<=str2double(get(handles.filter_cutoff,'String'));
    Pfilter=get(handles.peptide_filter,'String');
    PFstrings=cellstr(strread(Pfilter,'%s'));
    ranges=str2double(PFstrings);
    if mod(length(ranges),2)
        ErrorBoxGUI('Title','Error','string',['Peptide Filter must contain an',...
            ' even number of inputs, separated by spaces.'])
    else
        KeepResCell=cell(1,length(ranges)/2);
        for i=1:length(ranges)/2
            KeepResCell{i}=colon(ranges(2*i-1),ranges(2*i));
        end
        KeepRes=cell2mat(KeepResCell);
    end
    if ~isempty(KeepRes)
        Keep=intersect(find(keep),KeepRes);
    else
        Keep=find(keep);
    end
    for i=1:length(Alignment)
        Alignment(i).Sequence=Alignment(i).Sequence(Keep);
    end
end
distances = seqpdist(Alignment,'Method','Jukes-Cantor');
tree = seqlinkage(distances,'UPGMA',Alignment);
%h = plot(tree,'orient','top');
%h = plot(tree,'orient','left');
phytreetool(tree)
% ylabel('Evolutionary distance')
% set(h.terminalNodeLabels,'Rotation',65)


% --------------------------------------------------------------------
function view_logo_Callback(hObject, eventdata, handles)
% hObject    handle to view_logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
variability=obj.Output.Variability;
keep= variability<=str2double(get(handles.filter_cutoff,'String'));
Pfilter=get(handles.peptide_filter,'String');    
PFstrings=cellstr(strread(Pfilter,'%s'));
ranges=str2double(PFstrings);
if mod(length(ranges),2)
     ErrorBoxGUI('Title','Error','string',['Peptide Filter must contain an',...
        ' even number of inputs, separated by spaces.'])
else
    KeepResCell=cell(1,length(ranges)/2);
    for i=1:length(ranges)/2
        KeepResCell{i}=colon(ranges(2*i-1),ranges(2*i));
    end
    KeepRes=cell2mat(KeepResCell);
end
if ~isempty(KeepRes)
    Keep=intersect(find(keep),KeepRes);
else
    Keep=find(keep);
end
Alignment=obj.Output.Alignment;
for i=1:length(Alignment)
    Alignment(i).Sequence=Alignment(i).Sequence(Keep);
end
seqlogo(Alignment,'Alphabet','AA');



function ChainIDedit_Callback(hObject, eventdata, handles)
% hObject    handle to ChainIDedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChainIDedit as text
%        str2double(get(hObject,'String')) returns contents of ChainIDedit as a double


% --- Executes during object creation, after setting all properties.
function ChainIDedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChainIDedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function view_ramachandran_Callback(hObject, eventdata, handles)
% hObject    handle to view_ramachandran (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
if ~isfield(obj.pdb,'Header')
    obj.pdb.Header.idCode=obj.Output.Name;
end
variability=obj.Output.Variability;
sequence=obj.Output.Alignment(obj.Output.species3D).Sequence;
whole=1:length(sequence);
remove=strfind(sequence,'-');
newindices=whole;
newindices(remove)=[];
variability(remove)=[];

keep=find(variability<=str2double(get(handles.filter_cutoff,'String')));

Pfilter=get(handles.peptide_filter,'String');    
PFstrings=cellstr(strread(Pfilter,'%s'));
ranges=str2double(PFstrings);
if mod(length(ranges),2)
     ErrorBoxGUI('Title','Error','string',['Peptide Filter must contain an',...
        ' even number of inputs, separated by spaces.'])
else
    KeepResCell=cell(1,length(ranges)/2);
    for i=1:length(ranges)/2
        KeepResCell{i}=colon(ranges(2*i-1),ranges(2*i));
    end
    KeepRes=cell2mat(KeepResCell);
end

if get(handles.alignment_radio,'Value') && ~isempty(KeepRes)
    [~,KeepRes]=ismember(KeepRes,newindices);
end

if ~isempty(KeepRes)
    Keep=intersect(keep,KeepRes);
    Keep(Keep==0)=[];
else
    Keep=keep;
end

list=unique([obj.pdb.Model.Atom.resSeq]);
[~,index]=ismember(Keep,list);
index(index==0)=[];
KeepRes=list(index);
RealKeepRes=KeepRes;
%need three res to compute the middle one, so try this.
KeepRes=unique([KeepRes,KeepRes+1,KeepRes-1]);
[~,index]=ismember(KeepRes,list);
index(index==0)=[];
KeepRes=list(index);
%please try to rewrite this section.
numRes=length(KeepRes);
resSeq=[obj.pdb.Model.Atom.resSeq];
indices=cell(1,numRes);
for index=1:numRes
    indices{index}=find(resSeq==KeepRes(index));   
end
numRealRes=length(RealKeepRes);
FalsePos=zeros(1,2*numRealRes);
for j=1:numRealRes-1
    if RealKeepRes(j+1)-RealKeepRes(j) == 2
        FalsePos(2*j-1)=RealKeepRes(j)+1;
    end
    if RealKeepRes(j+1)-RealKeepRes(j) == 3
        FalsePos(2*j-1)=RealKeepRes(j)+1;
        FalsePos(2*j)=RealKeepRes(j)+2;
    end
end
[~,ind]=ismember(FalsePos,KeepRes);
ind(ind==0)=[];
SevereCa=zeros(1,length(ind));
for i=1:length(ind)
    SevereCa(i)=indices{ind(i)}(2);
end
keepAtoms=cell2mat(indices);
if ~isempty(SevereCa)
    [~,index]=ismember(SevereCa,keepAtoms);
    keepAtoms(index)=[];
end
newpdb=obj.pdb;
newpdb.Model.Atom=newpdb.Model.Atom(keepAtoms);
obj.Output.CreateRamachandran(newpdb,get(handles.ChainIDedit,'String'),'Separate')

        
        
% --------------------------------------------------------------------
function map_onto_menu_Callback(hObject, eventdata, handles)
% hObject    handle to map_onto_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
if ~isempty(obj.pdb_file)
    file=obj.pdb_file;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.pdb';'*.*'},'Select the PDB File',file);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    file=fullfile(PathName,FileName);
    [path,name]=fileparts(file);
    ID=fullfile(path,name);                                                      % If no backslashes were found, the ID would just be the file name without the .pdb
    h=PleaseWait();
    if exist([ID,'.mat'],'file') == 2
        load([ID,'.mat'])       
    else
        pdb=importdata(file);
        save([ID,'.mat'],'pdb','-v6')
    end
    chains=sort(unique([pdb.Model.Atom.chainID]));
    chainIDs=cell(1,length(chains));
    for i=1:length(chains)
        chainIDs{i}=chains(i);
    end
    obj.pdb2=pdb;
    obj.pdb2_file=file;
    %obj.pdb2_path=PathName;
    set(handles.pdb_file2_text,'String',name);
    set(handles.ChainID2edit,'String',chainIDs);
    delete(h)
    set(handles.P2_panel,'Visible','on')
    set(handles.P2_chain_panel,'Visible','on')
    set(handles.output,'UserData',obj)
end



% --- Executes during object creation, after setting all properties.
function map_cutoff_view_CreateFcn(hObject, eventdata, handles)
% hObject    handle to map_cutoff_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ChainID2edit_Callback(hObject, eventdata, handles)
% hObject    handle to ChainID2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChainID2edit as text
%        str2double(get(hObject,'String')) returns contents of ChainID2edit as a double


% --- Executes during object creation, after setting all properties.
function ChainID2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChainID2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function map_cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to map_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function view_variability_Callback(hObject, eventdata, handles)
% hObject    handle to view_variability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
if get(handles.variability_bins_menu,'Value')==1
    variability_bins='standard';
end
figure()
obj.Output.Protein.PlotVariability(variability_bins);


% --- Executes on selection change in filter_level.
function filter_level_Callback(hObject, eventdata, handles)
% hObject    handle to filter_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filter_level contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filter_level
switch get(handles.filter_level,'Value')
    case 1
        set(handles.filter_cutoff,'String','0')
        set(handles.filter_cutoff,'Enable','off')
    case 2
        set(handles.filter_cutoff,'String','1')        
        set(handles.filter_cutoff,'Enable','off')

    case 3
        set(handles.filter_cutoff,'String','2')        
        set(handles.filter_cutoff,'Enable','off')
    case 4
        set(handles.filter_cutoff,'Enable','on')
    case 5
        set(handles.filter_cutoff,'String','4.3220')
        set(handles.filter_cutoff,'Enable','off')
end

% --- Executes during object creation, after setting all properties.
function filter_level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filter_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to filter_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filter_cutoff as text
%        str2double(get(hObject,'String')) returns contents of filter_cutoff as a double


% --- Executes during object creation, after setting all properties.
function filter_cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end   


% --------------------------------------------------------------------
function edit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to edit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function view_menu_Callback(hObject, eventdata, handles)
% hObject    handle to view_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function advanced_menu_Callback(hObject, eventdata, handles)
% hObject    handle to advanced_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function instructions_menu_Callback(hObject, eventdata, handles)
% hObject    handle to instructions_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_menu_Callback(hObject, eventdata, handles)
% hObject    handle to about_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function matlabonly_menu_Callback(hObject, eventdata, handles)
% hObject    handle to matlabonly_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function everyone_menu_Callback(hObject, eventdata, handles)
% hObject    handle to everyone_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function options_menu_Callback(hObject, eventdata, handles)
% hObject    handle to options_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_state_Callback(hObject, eventdata, handles)
% hObject    handle to save_state (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UserData=get(handles.output,'UserData');
if ~isempty(UserData)
    if ~isempty(UserData.alignment_file)
        [~,name]=fileparts(UserData.alignment_file);
        %name=UserData.alignment_file(1:end-4);
    end
    if ~isempty(UserData.gene_list_file)
        [~,name]=fileparts(UserData.alignment_file);
    end
    [FileName,PathName] = uiputfile('*.cass','Save to...',...
        [sprintf('%c',name),'.cass']);
    if ~isequal(FileName,0) && ~isequal(PathName,0)
        CASS=ConAnalSaveState(handles);
        CASS.CASSsaveBasic(handles);
        CASS.CASSsaveAdvanced(handles);
        file2=fullfile(PathName,FileName);
        save(file2,'CASS','-v6')
    end
end

% --- Executes on selection change in Center_menu.
function Center_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Center_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Center_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Center_menu
contents = cellstr(get(hObject,'String'));
switch contents{get(hObject,'Value')}
    case 'PTC (23S rRNA)'
        set(handles.CenterX,'String',num2str(-32.3240))
        set(handles.CenterY,'String',num2str(123.0920))
        set(handles.CenterZ,'String',num2str(161.9990))     
        set(handles.center_custom_panel,'Visible','off')
     case 'DCC (16S rRNA)'
        set(handles.CenterX,'String',num2str(-57.5940))
        set(handles.CenterY,'String',num2str(094.5030))
        set(handles.CenterZ,'String',num2str(097.2900))
        set(handles.center_custom_panel,'Visible','off')  
    case 'None (0,0,0)'
        set(handles.CenterX,'String',num2str(0))
        set(handles.CenterY,'String',num2str(0))
        set(handles.CenterZ,'String',num2str(0))
        set(handles.center_custom_panel,'Visible','off')  
    case 'Custom'
        set(handles.center_custom_panel,'Visible','on')
end
% --- Executes during object creation, after setting all properties.
function Center_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Center_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function filter_enable_Callback(hObject, eventdata, handles)
% hObject    handle to filter_enable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function allow_filtered_cladogram_Callback(hObject, eventdata, handles)
% hObject    handle to allow_filtered_cladogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'Checked'),'off')
    set(hObject,'Checked','on')
else
    set(hObject,'Checked','off')
end



function peptide_filter_Callback(hObject, eventdata, handles)
% hObject    handle to peptide_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of peptide_filter as text
%        str2double(get(hObject,'String')) returns contents of peptide_filter as a double

Pfilter=get(handles.peptide_filter,'String');    
PFstrings=cellstr(strread(Pfilter,'%s'));
ranges=str2double(PFstrings);
if mod(length(ranges),2)
     ErrorBoxGUI('Title','Error','string',['Peptide Filter must contain an',...
        ' even number of inputs, separated by spaces.'])
end

% Pfilter=get(handles.peptide_filter,'String');    
% PFstrings=cellstr(strread(Pfilter,'%s'));
% ranges=str2double(PFstrings);
% if mod(length(ranges),2)
%      ErrorBoxGUI('Title','Error','string',['Peptide Filter must contain an',...
%         ' even number of inputs, separated by spaces.'])
% end
% else
%     KeepResCell=cell(1,length(ranges)/2);
%     for i=1:length(ranges)/2
%         KeepResCell{i}=colon(ranges(2*i-1),ranges(2*i));
%     end
%     KeepRes=cell2mat(KeepResCell)
% end

% --- Executes during object creation, after setting all properties.
function peptide_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peptide_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refilter_map.
function refilter_map_Callback(hObject, eventdata, handles)
% hObject    handle to refilter_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
CAOut=obj.Output;
if ~strcmp(get(handles.pdb_file2_text,'String'),'unloaded')
    h=PleaseWait();
        chains2=get(handles.ChainID2edit,'String');
        chain2=chains2{get(handles.ChainID2edit,'Value')};
%         map = MapContacts([obj.pdb_path,obj.pdb_file],...
%             [obj.pdb_path2,obj.pdb_file2],chain2,...
%             handles.map_cutoff);
%         CAOut.AddContactMap(map);
        %begin filtering             
        variability=CAOut.Variability;
        sequence=CAOut.Alignment(CAOut.species3D).Sequence;
        whole=1:length(sequence);
        remove=strfind(sequence,'-');
        newindices=whole;
        newindices(remove)=[];
        variability(remove)=[];
        keep=find(variability<=str2double(get(handles.filter_cutoff,'String')));        
        Pfilter=get(handles.peptide_filter,'String');
        PFstrings=cellstr(strread(Pfilter,'%s'));
        ranges=str2double(PFstrings);
        if mod(length(ranges),2)
            ErrorBoxGUI('Title','Error','string',['Peptide Filter must contain an',...
                ' even number of inputs, separated by spaces.'])
        else
            KeepResCell=cell(1,length(ranges)/2);
            for i=1:length(ranges)/2
                KeepResCell{i}=colon(ranges(2*i-1),ranges(2*i));
            end
            KeepRes=cell2mat(KeepResCell);
        end
        if get(handles.alignment_radio,'Value') && ~isempty(KeepRes)
            [~,KeepRes]=ismember(KeepRes,newindices);
        end        
        if ~isempty(KeepRes)
            Keep=intersect(keep,KeepRes);
            Keep(Keep==0)=[];
        else
            Keep=keep;
        end
        list=unique([CAOut.Protein.FAM.Model.resSeq]);
        [~,index]=ismember(Keep,list);
        index(index==0)=[];
        
        Newmap = MapContacts(obj.pdb_file,obj.pdb2_file,chain2,handles.map_cutoff,index);
        CAOut.AddContactMapFiltered(Newmap,str2double(get(handles.filter_cutoff,'String')));

        if ~isempty(CAOut.FilteredMap)
            myData(:,1)=CAOut.FilteredMap.Y(:,1);
            for i=1:size(myData,1)
                myData{i,2}=mat2str(CAOut.FilteredMap.Y{i,2});
            end
            myData(:,3)=CAOut.FilteredMap.Y(:,3);
            set(handles.mapY,'data',myData)
        end
        delete(h)
end


% --------------------------------------------------------------------
function view_map_Callback(hObject, eventdata, handles)
% hObject    handle to view_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj=get(handles.output,'UserData');
openvar('obj.Output.FilteredMap.Y');
pause



function map_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to map_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of map_cutoff as text
%        str2double(get(hObject,'String')) returns contents of map_cutoff as a double


% --------------------------------------------------------------------
function SSrenumA_Callback(hObject, eventdata, handles)
% hObject    handle to SSrenumA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

objA=get(handles.output,'userdata');

SSrenumberFigureHandle  = SSrenumber;
uiwait
SSrenumberData = guidata(SSrenumberFigureHandle);
objB = get(SSrenumberData.output,'UserData');

if isempty(objA.Output.Map)
    Y1=cell2mat(objA.Output.FilteredMap.Y(:,1));
else
    Y1=cell2mat(objA.Output.Map.Y(:,1));
end
Map=objB.Map;
% numhits=length(Y1);
[~,ind]=ismember(Y1,Map(:,1));
Y1=Map(ind,2);

if isempty(objA.Output.Map)
    objA.Output.FilteredMap.Y(:,2)=num2cell(Y1);
    objA.Output.FilteredMap.contacts=num2cell(Y1);
else
    objA.Output.Map.Y(:,2)=num2cell(Y1);
    objA.Output.Map.contacts=num2cell(Y1);
end
CAOut=objA.Output;
if ~isempty(CAOut.FilteredMap)
    myData(:,1)=CAOut.FilteredMap.Y(:,1);
    for i=1:size(myData,1)
        myData{i,2}=mat2str(CAOut.FilteredMap.Y{i,2});
    end
    myData(:,3)=CAOut.FilteredMap.Y(:,3);
    set(handles.mapY,'data',myData)
end
delete(SSrenumberFigureHandle);

% --------------------------------------------------------------------
function restore_state_Callback(hObject, eventdata, handles)
% hObject    handle to restore_state (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closeGUI = handles.figure1; %handles.figure1 is the GUI figure
 
guiPosition = get(handles.figure1,'Position'); %get the position of the GUI
guiName = get(handles.figure1,'Name'); %get the name of the GUI
eval(['handles=',guiName,';']) %call the GUI again
 
close(closeGUI); %close the old GUI
set(gcf,'Position',guiPosition); %set the position for the new GUI


[FileName,PathName] = uigetfile('*.cass','Restore from...',...
    [sprintf('%c','unnamed'),'.cass']);
if ~isequal(FileName,0) && ~isequal(PathName,0)
    file=fullfile(PathName,FileName);
    load(file,'CASS','-MAT');
    if ~isempty(CASS.AlignmentFile) && ~exist(CASS.AlignmentFile,'file')
        [FileName2,PathName2] = uigetfile({'*.aln','Clustal';'*.*',...
            'All files'},['File Not Found: Select',...
            'the ALN or other alignment file'],CASS.Name);
        if ~isequal(FileName2,0) && ~isequal(PathName2,0)
            
            CASS.AlignmentFile=fullfile(PathName2,FileName2);
        end
    end
    if ~isempty(CASS.GeneList.gene_list_file) && ~exist(CASS.GeneList.gene_list_file,'file')
        [FileName3,PathName3] = uigetfile({'*.xls;*.xlsx;*.xlsb;*.xlsm;*.csv',...
            'Supported Files';'*.*','All files'},['File Not Found: Select ',...
            'the Excel or CSV File'],CASS.Name);
        if ~isequal(FileName3,0) && ~isequal(PathName3,0)
            CASS.GeneList.gene_list_file=fullfile(PathName3,FileName3);
%             CASS.GeneList.gene_list_path=PathName3;
        end
    end
    CASS.CASSrestoreBasic(handles)
    CASS.CASSrestoreAdvanced(handles)
    
    CAUD=get(handles.output,'UserData');
        
    if ~isempty(CAUD.alignment_file)
        [~,name]=fileparts(CAUD.alignment_file);
        set(handles.alignment_text,'String',name)  
    end
    if ~isempty(CAUD.gene_list_file)
        [~,name]=fileparts(CAUD.gene_list_file);
        set(handles.gene_list_text,'String',name)
    end
    if ~isempty(CAUD.pdb_file) 
        chains=sort(unique([CAUD.pdb.Model.Atom.chainID]));
        chainIDs=cell(1,length(chains));
        for i=1:length(chains)
            chainIDs{i}=chains(i);
        end
        [~,name]=fileparts(CAUD.pdb_file);
        set(handles.pdb_file_text,'String',name);
        set(handles.ChainIDedit,'String',chainIDs);
        set(handles.P1_panel,'Visible','on')
        set(handles.P1_chain_panel,'Visible','on')
        set(handles.reference_frame,'Visible','on')
        set(handles.pdb_radio,'Enable','On')
        set(handles.map_onto_menu,'Enable','on')
    end
    if ~isempty(CAUD.pdb2_file)
        chains=sort(unique([CAUD.pdb2.Model.Atom.chainID]));
        chainIDs=cell(1,length(chains));
        for i=1:length(chains)
            chainIDs{i}=chains(i);
        end
        [~,name]=fileparts(CAUD.pdb2_file);
        set(handles.pdb_file2_text,'String',name);
        set(handles.ChainID2edit,'String',chainIDs);
        set(handles.P2_panel,'Visible','on');
        set(handles.P2_chain_panel,'Visible','on');
    end
    if ~isempty(CAUD.gene_list_file) || ~isempty(CAUD.alignment_file)
        set(handles.filter_panel,'Visible','on');
        set(handles.Alignment_panel,'Visible','on');
        set(handles.gobutton,'Visible','on');
        set(handles.load_pdb_file,'Enable','on');
    end
    if ~isempty(CAUD.Output.Alignment)
        set(handles.alignment_menu_item,'Enable','On')
        set(handles.view_cladogram,'Enable','On') 
        set(handles.view_logo,'Enable','On') 
        set(handles.view_variability,'Enable','On')
        if ~strcmp(get(handles.pdb_file_text,'String'),'unloaded')
            set(handles.view_ramachandran,'Enable','On')
        end
        if ~strcmp(get(handles.pdb_file2_text,'String'),'unloaded')
            set(handles.view_map,'Enable','On')
            set(handles.refilter_map,'Visible','On')
        end
        if strcmp(get(handles.export_results,'Checked'),'on')
            assignin('base',CAUD.Output.Name,CAUD.Output)
        end
    end
    if get(handles.filter_level,'Value')==4
        set(handles.filter_cutoff,'Enable','on')
    else
        set(handles.filter_cutoff,'Enable','off')
    end
    
    contents = cellstr(get(handles.shell_boundaries_menu,'String'));
    switch contents{get(handles.shell_boundaries_menu,'Value')}
        case 'Ribosome Standard'
            set(handles.custom_shells,'Visible','off')
        case 'Custom'
            set(handles.custom_shells,'Visible','on')
        otherwise
            set(handles.custom_shells,'Visible','off')
    end
    
    contents = cellstr(get(handles.variability_bins_menu,'String'));
    switch contents{get(handles.variability_bins_menu,'Value')}
        case 'Standard'
            set(handles.custom_bins,'Visible','off')
        case 'Custom'
            set(handles.custom_bins,'Visible','on')
        otherwise
            set(handles.custom_bins,'Visible','off')
    end
    contents = cellstr(get(handles.Center_menu,'String'));
    switch contents{get(handles.Center_menu,'Value')}
        case 'PTC (23S rRNA)'
            set(handles.CenterX,'String',num2str(-32.3240))
            set(handles.CenterY,'String',num2str(123.0920))
            set(handles.CenterZ,'String',num2str(161.9990))
            set(handles.center_custom_panel,'Visible','off')
        case 'DCC (16S rRNA)'
            set(handles.CenterX,'String',num2str(-57.5940))
            set(handles.CenterY,'String',num2str(094.5030))
            set(handles.CenterZ,'String',num2str(097.2900))
            set(handles.center_custom_panel,'Visible','off')
        case 'None (0,0,0)'
            set(handles.CenterX,'String',num2str(0))
            set(handles.CenterY,'String',num2str(0))
            set(handles.CenterZ,'String',num2str(0))
            set(handles.center_custom_panel,'Visible','off')
        case 'Custom'
            set(handles.center_custom_panel,'Visible','on')
    end
    if ~isempty(CAUD.Output.FilteredMap)
        myData(:,1)=CAUD.Output.FilteredMap.Y(:,1);
        for i=1:size(myData,1)
            myData{i,2}=mat2str(CAUD.Output.FilteredMap.Y{i,2});
        end
        myData(:,3)=CAUD.Output.FilteredMap.Y(:,3);
        set(handles.mapY,'data',myData)
    end
    
    
    
end


% --------------------------------------------------------------------
function SSrenumB_Callback(hObject, eventdata, handles)
% hObject    handle to SSrenumB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
objA=get(handles.output,'userdata');

SSrenumberFigureHandle  = SSrenumber;
uiwait
SSrenumberData = guidata(SSrenumberFigureHandle);
objB = get(SSrenumberData.output,'UserData');

if isempty(objA.Output.Map)
    Y2=objA.Output.FilteredMap.Y(:,2);
else
    Y2=objA.Output.Map.Y(:,2);
end
Map=objB.Map;
numhits=length(Y2);
for i=1:numhits
    [~,ind]=ismember(Y2{i},Map(:,1));
    Y2{i}=Map(ind,2);
end
if isempty(objA.Output.Map)
    objA.Output.FilteredMap.Y(:,2)=Y2;
    objA.Output.FilteredMap.contacts=Y2;
else
    objA.Output.Map.Y(:,2)=Y2;
    objA.Output.Map.contacts=Y2;
end
CAOut=objA.Output;
if ~isempty(CAOut.FilteredMap)
    myData(:,1)=CAOut.FilteredMap.Y(:,1);
    for i=1:size(myData,1)
        myData{i,2}=mat2str(CAOut.FilteredMap.Y{i,2});
    end
    myData(:,3)=CAOut.FilteredMap.Y(:,3);
    set(handles.mapY,'data',myData)
end
delete(SSrenumberFigureHandle);



% --------------------------------------------------------------------
function save_file_Callback(hObject, eventdata, handles)
% hObject    handle to save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function species3D=MatchSequence(Alignment,FAM)
% FAM=ImportPDBs(File);
%Warning, this doesn't handle skipped amino acids yet
AllSequences={Alignment(:).Sequence};
[~,I]=unique(FAM.UniqueResSeq);

Mode='NA';%'AA'
switch Mode
    case 'AA'
        TargetSequence=aminolookup([FAM.Model(I).resName]);
    case 'NA'
        TargetSequence=[FAM.Model(I).resName];
end

lenTS=length(TargetSequence);
numSeqs=length(AllSequences);
pmatch=zeros(1,numSeqs);
for i=1:numSeqs
    AllSequences{i}(AllSequences{i}=='-')=[];
    offset=min(strfind(AllSequences{i},TargetSequence(1:4)))-1;
    numres=length(AllSequences{i});
    if offset+lenTS <= numres
        match=zeros(1,lenTS);
        for j=1:lenTS
            match(j)=TargetSequence(j)==AllSequences{i}(j+offset);
        end
        pmatch(i)=sum(match)/numres;
    else
        match=zeros(1,numres-offset);
        for j=1:numres-offset
            match(j)=TargetSequence(j)==AllSequences{i}(j+offset);
        end
        pmatch(i)=sum(match)/numres;

    end   
end    
[~,species3D]=max(pmatch);


% --------------------------------------------------------------------
function misc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to misc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function resetgui_Callback(hObject, eventdata, handles)
% hObject    handle to resetgui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closeGUI = handles.figure1; %handles.figure1 is the GUI figure
 
guiPosition = get(handles.figure1,'Position'); %get the position of the GUI
guiName = get(handles.figure1,'Name'); %get the name of the GUI
eval(['handles=',guiName,';']) %call the GUI again
 
close(closeGUI); %close the old GUI
set(gcf,'Position',guiPosition); %set the position for the new GUI
