function varargout = RiboLabRV(varargin)
% RIBOLABRV MATLAB code for RiboLabRV.fig
%      RIBOLABRV, by itself, creates a new RIBOLABRV or raises the existing
%      singleton*.
%
%      H = RIBOLABRV returns the handle to a new RIBOLABRV or the handle to
%      the existing singleton*.
%
%      RIBOLABRV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RIBOLABRV.M with the given input arguments.
%
%      RIBOLABRV('Property','Value',...) creates a new RIBOLABRV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RiboLabRV_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RiboLabRV_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RiboLabRV

% Last Modified by GUIDE v2.5 24-Feb-2015 20:50:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RiboLabRV_OpeningFcn, ...
    'gui_OutputFcn',  @RiboLabRV_OutputFcn, ...
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


% --- Executes just before RiboLabRV is made visible.
function RiboLabRV_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RiboLabRV (see VARARGIN)

% Choose default command line output for RiboLabRV
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RiboLabRV wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RiboLabRV_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_pdb_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_pdb_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function PDB_FileList_Callback(hObject, eventdata, handles)
% hObject    handle to PDB_FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PDB_FileList as text
%        str2double(get(hObject,'String')) returns contents of PDB_FileList as a double


% --- Executes during object creation, after setting all properties.
function PDB_FileList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PDB_FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Domain_File_Callback(hObject, eventdata, handles)
% hObject    handle to Domain_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Domain_File as text
%        str2double(get(hObject,'String')) returns contents of Domain_File as a double


% --- Executes during object creation, after setting all properties.
function Domain_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Domain_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Helix_File_Callback(hObject, eventdata, handles)
% hObject    handle to Helix_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Helix_File as text
%        str2double(get(hObject,'String')) returns contents of Helix_File as a double


% --- Executes during object creation, after setting all properties.
function Helix_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Helix_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StructureFile_Callback(hObject, eventdata, handles)
% hObject    handle to StructureFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StructureFile as text
%        str2double(get(hObject,'String')) returns contents of StructureFile as a double


% --- Executes during object creation, after setting all properties.
function StructureFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StructureFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over PDB_FileList.
function PDB_FileList_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to PDB_FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
if ~isempty(result)
    file=result.File;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.pdb';'*.*'},'Select the PDB File (or two)',file,...
    'MultiSelect','on');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    %set(handles.FilesProcessedText,'Visible','off')
    %set(handles.FilesLoadedText,'Visible','off')
    h=PleaseWait();
    if iscell(FileName)
        numFiles=length(FileName);
    else
        numFiles = 1;
        FileName={FileName};
    end
    RiboLabCads=[];
    RiboLabPDBs=[];
    DataSetName='';
    FullFileList='';
    for i=1:numFiles
        file=fullfile(PathName,FileName{i});
        [~,DataSetName_piece]=fileparts(file);
        DataSetName = [DataSetName,DataSetName_piece,'_'];
        FullFileList = [FullFileList,DataSetName_piece,', '];
        [a,b]=CadsSet(file);
        RiboLabCads = [RiboLabCads,a];
        RiboLabPDBs = [RiboLabPDBs,b];
    end
    DataSetName(end)=[];
    FullFileList(end-1:end)=[];
    
    %RiboLabCads = CADS(name);
    %%RiboLabCads.AddPDB({file});
 
    
    %     textfile=fileread(file);
    %
    %     IDlist=regexp(textfile,'[\w]+','match');
    %     numIDs=length(IDlist);
    %     Structures(numIDs,1)=PDBentry();
    %     %     h=PleaseWait();
    %     numFiles=length(IDlist);
    %     set(handles.FilesLoadedText,'String',sprintf('%d out of %d files loaded.',0,numFiles))
    %     set(handles.FilesLoadedText,'Visible','on')
    %     drawnow()
    %
    %     for i=1:numFiles
    %         ID=fullfile(path,IDlist{i});
    %         if exist([ID,'.mat'],'file') == 2
    %             load([ID,'.mat'])
    %         elseif exist([ID,'.pdb'],'file') == 2
    %             pdb=importdata([ID,'.pdb']);
    %             save([ID,'.mat'],'pdb')
    %         else
    %             pdb = getpdb(IDlist{i}, 'ToFile', [ID,'.pdb']);
    %             save([ID,'.mat'],'pdb')
    %         end
    %         Structures(i)=PDBentry(pdb.Title);
    %         Structures(i).PDBfromStruct(pdb,IDlist{i})
    %         %Structures(i).Process()
    %         set(handles.FilesLoadedText,'String',sprintf('%d out of %d files loaded.',i,numFiles))
    %         drawnow()
    %     end
    
    result.RiboLabCads=RiboLabCads;
    result.RiboLabPDBs=RiboLabPDBs;

    result.File=file;
    %     result.IDlist=IDlist;
    
    set(handles.DataSetName,'String',DataSetName);
    set(handles.output,'UserData',result);
    set(hObject,'String',FullFileList);
    numCads=length(RiboLabCads);
    CadsTable=cell(numCads,3);
    for i =1:numCads
        CadsTable{i,1}=RiboLabCads(i).Name;
        x=regexp(RiboLabCads(i).Name,'RIBOSOMAL PROTEIN ([\w][^\s:]+)','tokens');
        if isempty(x)
            x=regexp(RiboLabCads(i).Name,'([\d\.]+S)','tokens');
            if isempty(x)
                x=regexp(RiboLabCads(i).Name,'([^:]+):','tokens');
                CadsTable(i,3)=regexprep(x{1},'\.','p');
                CadsTable{i,2}='other';
            else
                CadsTable(i,3)=x{1};
                CadsTable{i,2}='rRNA';
            end
        else
            CadsTable(i,3)=regexprep(x{1},'-','');
            CadsTable{i,2}='rProtein';
        end
        y=regexp(RiboLabCads(i).Name,':\sChain\(s\)\s([\w\d])','tokens');
        CadsTable(i,4)=y{1};
    end
    set(handles.MoleculeNamesTable,'Data',CadsTable);
    set(handles.customAtomN,'enable','on');
    
    
    %     %     delete(h)
    %     %     set(handles.FilesLoadedText,'String',sprintf('%i files have been loaded.',numIDs))
    %
    %
    %     if strcmp(get(handles.auto_mode,'checked'),'on')
    %         set(handles.gobutton,'Visible','off')
    %         BindSite('gobutton_Callback',handles.gobutton,[],guidata(hObject))
    %         BindSite('save_pml_menu_Callback',handles.save_pml_menu,[],guidata(hObject))
    %     else
    %        set(handles.gobutton,'Visible','on')
    %        set(handles.SettingsPanel,'Visible','on')
    %     end
    delete(h);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text4.
function text4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in CalculateBtn.
function CalculateBtn_Callback(hObject, eventdata, handles)
% hObject    handle to CalculateBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=PleaseWait();
OnionShellWidth_Callback(hObject, eventdata, handles);
OnionCenterTextBox_Callback(hObject, eventdata, handles);

result=get(handles.output,'UserData');
RiboLabCads=result.RiboLabCads;
CadsTable=get(handles.MoleculeNamesTable,'Data');
if ~isempty(result) && isfield(result,'OnionFiles')
    OnionFiles=result.OnionFiles;
end
RiboLabCads_rRNA=[];
RiboLabCads_rRNA_Names={};
RiboLabCads_rProtein_Names={};
RiboLabCads_rProtein=[];

numCads=length(RiboLabCads);
for i=1:numCads
    if strcmp(CadsTable(i,2),'rRNA')
        RiboLabCads_rRNA=[RiboLabCads_rRNA,RiboLabCads(i)];
        RiboLabCads_rRNA_Names=[RiboLabCads_rRNA_Names,CadsTable{i,3}];
    elseif strcmp(CadsTable(i,2),'rProtein')
        RiboLabCads_rProtein=[RiboLabCads_rProtein,RiboLabCads(i)];
        RiboLabCads_rProtein_Names=[RiboLabCads_rProtein_Names,CadsTable{i,3}];
    end
    MoleculeChainMap.(['mol_',CadsTable{i,3}])=CadsTable{i,4};
    ChainMoleculeMap.(['chain_',CadsTable{i,4}])=CadsTable{i,3};
end
result.MoleculeChainMap=MoleculeChainMap;
result.ChainMoleculeMap=ChainMoleculeMap;
result.RiboLabCads_rProtein_Names=RiboLabCads_rProtein_Names;
result.RiboLabCads_rRNA_Names=RiboLabCads_rRNA_Names;

%%
     RiboLabMap = Map2D(get(handles.DataSetName,'String'));
     ResidueList = RiboLabMap.AddMapStructureFile(result.StructureFile,MoleculeChainMap); 
     %RiboLabMap.TransformAuto();
     result.RiboLabMap=RiboLabMap;
     result.ResidueList=ResidueList;
%%

if get(handles.meanBFactBox,'value')
    Thermal_Factor_Table = ThermalFactorTable(RiboLabCads_rRNA,...
        repmat({RiboLabMap.ItemNames},1,length(RiboLabCads_rRNA)));
    numDataPoints=size(Thermal_Factor_Table,1);
    for j = 1: numDataPoints
        chainID=regexp(Thermal_Factor_Table{j,1},'([^_])_','tokens');
        Thermal_Factor_Table{j,1}=regexprep(Thermal_Factor_Table{j,1},'([^_]+)_',[ChainMoleculeMap.(['chain_',chainID{1}{1}]),':']);
        if isempty(Thermal_Factor_Table{j,2})
            Thermal_Factor_Table{j,2}='';
        else
             Thermal_Factor_Table{j,2}=num2str(Thermal_Factor_Table{j,2});
        end
    end
    result.Thermal_Factor_Table=Thermal_Factor_Table;
end

if get(handles.fineOnionBox,'value') || get(handles.coarseOnionBox,'value')
    for i=1:length(RiboLabCads_rRNA)
        OnionFiles.Onions(i) = Onion([RiboLabCads_rRNA(i).Name,' Onion'],RiboLabCads_rRNA(i).PDB,OnionFiles.Center,OnionFiles.Layers);
    end
    RiboLabCads_rRNA_Names=regexprep(RiboLabCads_rRNA_Names,'S','S:');
    if get(handles.fineOnionBox,'value')
        result.Fine_Onion_Table=OnionFiles.Onions.OnionTable(RiboLabMap.ItemNames,'ModelType','fine','PreFix',RiboLabCads_rRNA_Names);
    end
    if get(handles.coarseOnionBox,'value')
        result.Coarse_Onion_Table=OnionFiles.Onions.OnionTable(RiboLabMap.ItemNames,'ModelType','coarse','PreFix',RiboLabCads_rRNA_Names);
    end
end
if get(handles.ProteinOnionBox,'value')
    ProteinItemNames={};
    for i=1:length(RiboLabCads_rProtein)
        OnionFiles.ProteinOnions(i) = Onion([RiboLabCads_rProtein(i).Name,' Onion'],RiboLabCads_rProtein(i).PDB,OnionFiles.Center,OnionFiles.Layers);
        ProteinItemNames=vertcat(ProteinItemNames,unique(OnionFiles.ProteinOnions(i).Structure.UniqueResSeq));
    end
    ProteinItemNames=regexprep(ProteinItemNames,'_[\s]*','');
    Protein_Prefixes=regexprep(RiboLabCads_rProtein_Names,'(.*)','$1:');    
    result.Protein_Onion_Table=OnionFiles.ProteinOnions.OnionTable(ProteinItemNames,'ModelType','fine','PreFix',Protein_Prefixes);
end
if get(handles.helixDefBox,'value')
    FakeMap.ItemNames=ResidueList;
    Helix_Table=HelixDefinitions(result.HelixDef,FakeMap,'DisplayPlots',false,'ColorFile',result.HelixColorFile);
    result.Helix_Table=Helix_Table;
end
if get(handles.DomainDefbox,'value')
    FakeMap.ItemNames=ResidueList;
    Domain_Table=DomainDefinitions(result.DomainDef,FakeMap,'DisplayPlots',false,'ColorFile',result.DomainColorFile);
    result.Domain_Table=Domain_Table;
end
if get(handles.FR3D_InteractionsBox,'value')
    for i=1:length(result.RiboLabFullBP)
        result.RiboLabFullBP(i).Name=['rRNA ',num2str(i)];
    end
    [~,FilteredBP]=PlotBPbyType(result.RiboLabFullBP,RiboLabMap,'DisplayPlots',false);
    BP2Table([FilteredBP{:}],'TableFormat','website','ItemList',RiboLabMap.ItemNames);
    BPorg=BPorganize([FilteredBP{:}]);
    DeDupped_BPs=DeDupBP(BPorg);
    FR3D_Interaction_Tables=BP2Table(DeDupped_BPs,'TableFormat','website','ItemList',RiboLabMap.ItemNames,'Merge',false);
    result.FR3D_Interaction_Tables=FR3D_Interaction_Tables;
end
if get(handles.EntropyBox,'value') || get(handles.CoVarEntropyBox,'value')
    A=fastaread(result.AlignmentFile);
    RiboLabCads_rRNA(1).AddAlignment('premade',A);
    FindSpecies=regexprep(lower(RiboLabCads_rRNA(1).Species),'[\s_]','');
    LookSpecies=lower(regexprep({A.Header},'[\s_]',''));
    [~,Species_Ind]=ismember(FindSpecies,LookSpecies);
    B=RiboLabCads_rRNA(1).PlotAlignment('species',Species_Ind,'ShowPlots',false);
    RiboLabCads_rRNA(1).Alignment=B{1};
    
    H=Seq_entropy(RiboLabCads_rRNA(1).Alignment,'Gap_mode','prorate');
    numSamples = length(H{1});
    ConservationTable=cell(numSamples+1,9);
    ConservationTable{1,1}='resNum';
    ConservationTable(2:end,1) = result.ResidueList(1:length(H{1}));
    ConservationTable{1,2}='resName';
    ConservationTable(2:end,2)=cellstr(RiboLabCads_rRNA(1).Alignment(Species_Ind).Sequence');
    ConservationTable{1,3} = 'Consensus';
    ConservationTable(2:end,3)= cellstr(regexprep(seqconsensus(RiboLabCads_rRNA(1).Alignment,...
        'Alphabet','NT','Gaps','all'),'T','U')');
    ConservationTable(1,4:8) = {'A','C','G','U','Gaps'};
    ConservationTable(2:end,4:8) = num2cell(seqprofile(RiboLabCads_rRNA(1).Alignment,...
        'Alphabet','NT','Gaps','all')');
    ConservationTable{1,9} = 'Shannon';
    ConservationTable(2:end,9) = num2cell(H{1});
    
    result.Conservation_Table=ConservationTable;
    
    if get(handles.EntropyBox,'value')
        result.Entropy_Table=[result.ResidueList(1:length(H{1})),num2cell(H{1}')];
        result.Entropy_Table=vertcat(result.Entropy_Table, ...
            [result.ResidueList(length(H{1})+1:end),repmat({'\N'},...
            length(result.ResidueList(length(H{1})+1:end)),1)]);
    end
    
    if get(handles.CoVarEntropyBox,'value')
        %Assume FR3D was calculated, because checkbox rules says it has to
        %have been.
        H_CoVar=CoVarEntropy(RiboLabCads_rRNA(1).Alignment,FR3D_Interaction_Tables,{'cww'},'ByTypes');
        result.CoVarEntropy_Table=[result.ResidueList(1:length(H_CoVar{1})),num2cell(H_CoVar{1}')];
        result.CoVarEntropy_Table=vertcat(result.CoVarEntropy_Table, ...
            [result.ResidueList(length(H_CoVar{1})+1:end),repmat({'\N'},...
            length(result.ResidueList(length(H_CoVar{1})+1:end)),1)]);
    end
    
end

if get(handles.ProteinContactsBox,'value') || get(handles.MagContactsBox,'value')
    %FakeMap.ItemNames=ResidueList;
    %Domain_Table=DomainDefinitions(result.DomainDef,FakeMap,'DisplayPlots',false,'ColorFile',result.DomainColorFile);
    NewTarget.Name=[RiboLabCads_rRNA.Name];
    NewTarget.ID=RiboLabCads_rRNA(1).PDB.ID;
    NewTarget.PDB=PDBentry();
    newpdb=RiboLabCads_rRNA(1).PDB.PDB;
    for i=2:length(RiboLabCads_rRNA)
        newpdb.Model.Atom=[newpdb.Model.Atom,RiboLabCads_rRNA(i).PDB.PDB.Model.Atom];
    end
    NewTarget.PDB.PDBfromStruct(newpdb);
    NewTarget.PDB.Process();
    RiboLabCads.AddTarget(NewTarget.PDB);%Because they are handles, adding Target to main Cads object, also adds it to the RiboLabCads_rProtein and RiboLabCads_rRNA objects.
    
    rvfam=FullAtomModel();
    rvfam.PopulateFAM(NewTarget.PDB.PDB);
    chain=unique([NewTarget.PDB.PDB.Model.Atom.chainID]);
    x=Chain('',chain);
    x.CreateChain(rvfam,chain);
    RVResidues=x.residues;
    [RVResidues,RealAtomsNames_B]=AtomFilter(RVResidues,'rna');
    
    if get(handles.ProteinContactsBox,'value')
        for j=1:length(RiboLabCads_rProtein)
            RiboLabCads_rProtein(j).Settings.Structure.ContactCutoff=3.4;
            RiboLabCads_rProtein(j).FilterMap('AtomFilterType',{'protein','rna'},'ResidueTarget',{RVResidues},'RealAtomsNames_B',RealAtomsNames_B);
            %disp(j);
        end
         Protein_Contact_Table=ProteinContactTable(RiboLabCads_rProtein,RiboLabMap);
         result.Protein_Contact_Table=Protein_Contact_Table{1};
    end
    if get(handles.ProteinInteractionBox,'value')
        RiboLab_BP_NPN = ContactMap2BP(RiboLabCads_rProtein,'MapMode','withinTarget','bp_type','NPN');
        Protein_Interaction_Table=BP2Table(RiboLab_BP_NPN,'TableFormat','website','ItemList',RiboLabMap.ItemNames,'ProteinCol',RiboLabCads_rProtein_Names);
        result.Protein_Interaction_Table=Protein_Interaction_Table;
    end
    if get(handles.MagContactsBox,'value')
        cutoffs={'6.0','2.6','2.4'};%make the one you want interactions for last.
        numCutoff=length(cutoffs);
        Mg_Individual_Contact_Table=cell(1,numCutoff);
        MgColNames=cell(1,numCutoff);
        for k=1:numCutoff
            MgColNames{k}=['Mg_ions_', regexprep(cutoffs{k},'[^\d]','')];
            for m=1:length(RiboLabCads)
                RiboLabCads(m).Settings.Structure.ContactCutoff=str2double(cutoffs{k});
                %check through all just in case right now
                RiboLabCads(m).FilterMap('AtomFilterType',{'magnesium','rna'},'Subsets',[],'ResidueTarget',{RVResidues},'RealAtomsNames_B',RealAtomsNames_B);
                %disp([k,m]);
            end
            Mg_Individual_Contact_Table{k}=ProteinContactTable(RiboLabCads,RiboLabMap,'TableFormat','website','Magnesium',true,'CombineCols',true);
        end
        result.Mg_Individual_Contact_Table=Mg_Individual_Contact_Table(end:-1:1); 
        result.MgColNames=MgColNames(end:-1:1);
    end
    
    if get(handles.MagInteractionBox,'value')
        RiboLab_BP_NMN = ContactMap2BP(RiboLabCads,'MapMode','withinTarget','bp_type','NMN');
        Magnesium_Interaction_Table=BP2Table(RiboLab_BP_NMN,'TableFormat','website','ItemList',RiboLabMap.ItemNames);
        result.Magnesium_Interaction_Table=Magnesium_Interaction_Table;
    end
end

result.RiboLabCads_rRNA=RiboLabCads_rRNA;
result.RiboLabCads_rProtein=RiboLabCads_rProtein;
result.OnionFiles=OnionFiles;
set(handles.output,'UserData',result);
delete(h);


% --- Executes on button press in SaveBtn.
function SaveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
RiboLabMap=result.RiboLabMap;
RiboLabCads_rRNA= result.RiboLabCads_rRNA;
%result.RiboLabCads_rProtein_Names
%result.RiboLabCads_rRNA_Names
%RiboLabCads_rProtein = result.RiboLabCads_rProtein;
%ResidueList=result.ResidueList;
R=[RiboLabCads_rRNA.PDB];
Table = RiboLabMap.BasicTable(vertcat(R.UniqueResSeq));
TableHeader={'map_Index','resNum','resName','ChainID','X','Y','Xtal_Index';'int',...
    'varchar(6)','varchar(3)','char(1)','real(8,3)','real(8,3)','int'};


if get(handles.DomainDefbox,'value')
    Table=[Table,result.Domain_Table(:,2:4)];
    TableHeader=[TableHeader,{'Domain_RN','Domain_AN','Domains_Color';'varchar(4)','char(1)','int'}];
end
if get(handles.helixDefBox,'value')
    Table=[Table,result.Helix_Table(:,2:3)];
    TableHeader=[TableHeader,{'Helix_Num','Helix_Color';'varchar(4)','int'}];
end
if get(handles.fineOnionBox,'value')
    Table=[Table,result.Fine_Onion_Table(:,2)];
    TableHeader=[TableHeader,{'FineOnion';'real(8,3)'}];
end
if get(handles.coarseOnionBox,'value')
    Table=[Table,result.Coarse_Onion_Table(:,2)];
    TableHeader=[TableHeader,{'Onion';'int'}];
end
if get(handles.meanBFactBox,'value')
    Table=[Table,result.Thermal_Factor_Table(:,2)];
    TableHeader=[TableHeader,{'mean_tempFactor';'real(8,3)'}];
end
if get(handles.EntropyBox,'value')
    Table=[Table,result.Entropy_Table(:,2)];
    TableHeader=[TableHeader,{'Shannon_Entropy';'real(5,3)'}];
end
if get(handles.CoVarEntropyBox,'value')
    Table=[Table,result.CoVarEntropy_Table(:,2)];
    TableHeader=[TableHeader,{'CoVar_Entropy';'real(5,3)'}];
end
if get(handles.ProteinContactsBox,'value')
    Table=[Table,result.Protein_Contact_Table(:,2:end)];
    TableHeader=[TableHeader,[result.RiboLabCads_rProtein_Names;repmat({'int'},1,length(result.RiboLabCads_rProtein_Names))]];
end
if get(handles.MagContactsBox,'value')
    d=[result.Mg_Individual_Contact_Table{:}];
    numMgCols=length(result.Mg_Individual_Contact_Table);
    e=[d{:}];
    Table=[Table,e(:,2:2:2*numMgCols)];
    TableHeader=[TableHeader,[result.MgColNames;repmat({'int'},1,numMgCols)]];
end

[DataSetName_path]=fileparts(result.File);
xlswrite([DataSetName_path,'\',get(handles.DataSetName,'String'),'.xlsx'],vertcat(TableHeader,Table));
if get(handles.ProteinInteractionBox,'value')
    NPN=[{'pairIndex','resIndex1','resIndex2','bp_type','ProteinName'};
     {'int','int','int','varchar(6)','varchar(6)'};
        result.Protein_Interaction_Table];
    xlswrite([DataSetName_path,'\',get(handles.DataSetName,'String'),'_NPN','.xlsx'],NPN);
    
end
if get(handles.MagInteractionBox,'value')
    NMN=[{'pairIndex','resIndex1','resIndex2','bp_type'};
     {'int','int','int','varchar(6)'};
        result.Magnesium_Interaction_Table(:,1:4)];
    xlswrite([DataSetName_path,'\',get(handles.DataSetName,'String'),'_NMN','.xlsx'],NMN);
    
end
if get(handles.FR3D_InteractionsBox,'value')
    Names={'BasePairs','Stacking','BaseSugar','BasePhosphate'};
    for i=1:length(Names)
        xlswrite([DataSetName_path,'\',get(handles.DataSetName,'String'),'_',Names{i},'.xlsx'],...
            result.FR3D_Interaction_Tables{i}(:,1:4));
    end
end
if get(handles.ProteinOnionBox,'value')
    xlswrite([DataSetName_path,'\',get(handles.DataSetName,'String'),'_ProteinOnions','.xlsx'],...
        [{'resNum','DataCol'};result.Protein_Onion_Table]);
end
if get(handles.EntropyBox,'value')
    xlswrite([DataSetName_path,'\',get(handles.DataSetName,'String'),'_ConservationTable','.xlsx'],...
        [result.Conservation_Table(1,:);{'varchar(11)','varchar(3)','char(1)',...
        'real(5,4)','real(5,4)','real(5,4)','real(5,4)','real(5,4)','real(5,4)'};result.Conservation_Table(2:end,:)]);
end
% --- Executes on button press in DomainDefbox.
function DomainDefbox_Callback(hObject, eventdata, handles)
% hObject    handle to DomainDefbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DomainDefbox


% --- Executes on button press in helixDefBox.
function helixDefBox_Callback(hObject, eventdata, handles)
% hObject    handle to helixDefBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of helixDefBox


% --- Executes on button press in fineOnionBox.
function fineOnionBox_Callback(hObject, eventdata, handles)
% hObject    handle to fineOnionBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fineOnionBox


% --- Executes on button press in meanBFactBox.
function meanBFactBox_Callback(hObject, eventdata, handles)
% hObject    handle to meanBFactBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of meanBFactBox


% --- Executes on button press in coarseOnionBox.
function coarseOnionBox_Callback(hObject, eventdata, handles)
% hObject    handle to coarseOnionBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of coarseOnionBox


% --- Executes on button press in ProteinContactsBox.
function ProteinContactsBox_Callback(hObject, eventdata, handles)
% hObject    handle to ProteinContactsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ProteinContactsBox
if ~get(hObject,'Value')
    set(handles.ProteinInteractionBox,'Value',0)
end

% --- Executes on button press in EntropyBox.
function EntropyBox_Callback(hObject, eventdata, handles)
% hObject    handle to EntropyBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EntropyBox


% --- Executes on button press in MagContactsBox.
function MagContactsBox_Callback(hObject, eventdata, handles)
% hObject    handle to MagContactsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MagContactsBox
if ~get(hObject,'Value')
    set(handles.MagInteractionBox,'Value',0)
end

% --- Executes on button press in ProteinInteractionBox.
function ProteinInteractionBox_Callback(hObject, eventdata, handles)
% hObject    handle to ProteinInteractionBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ProteinInteractionBox
if get(hObject,'Value')
    set(handles.ProteinContactsBox,'Value',1)
end

% --- Executes on button press in FR3D_InteractionsBox.
function FR3D_InteractionsBox_Callback(hObject, eventdata, handles)
% hObject    handle to FR3D_InteractionsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FR3D_InteractionsBox
if ~get(hObject,'Value')
    set(handles.CoVarEntropyBox,'Value',0)
end

% --- Executes on button press in MagInteractionBox.
function MagInteractionBox_Callback(hObject, eventdata, handles)
% hObject    handle to MagInteractionBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MagInteractionBox

if get(hObject,'Value')
    set(handles.MagContactsBox,'Value',1)
end


function FullFR3DFile_Callback(hObject, eventdata, handles)
% hObject    handle to FullFR3DFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FullFR3DFile as text
%        str2double(get(hObject,'String')) returns contents of FullFR3DFile as a double


% --- Executes during object creation, after setting all properties.
function FullFR3DFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FullFR3DFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over StructureFile.
function StructureFile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to StructureFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
if ~isempty(result)
    file=result.File;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.csv';'*.*'},'Select the CSV File',file,...
    'MultiSelect','off');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    h=PleaseWait();
    file=fullfile(PathName,FileName);
    result.File=file;
    set(hObject,'String',FileName);
    result.StructureFile=file;
    result.OnionFiles=[];
    set(handles.output,'UserData',result);
    delete(h);
end



function OnionShellWidth_Callback(hObject, eventdata, handles)
% hObject    handle to OnionShellWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OnionShellWidth as text
%        str2double(get(hObject,'String')) returns contents of OnionShellWidth as a double
result=get(handles.output,'UserData');
if ~isempty(result) && isfield(result,'OnionFiles')
    OnionFiles=result.OnionFiles;
end

OnionFiles.Layers=str2double(get(handles.OnionShellWidth,'String'));

result.OnionFiles=OnionFiles;
set(handles.output,'UserData',result);
% --- Executes during object creation, after setting all properties.
function OnionShellWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OnionShellWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OnionCenterTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to OnionCenterTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OnionCenterTextBox as text
%        str2double(get(hObject,'String')) returns contents of OnionCenterTextBox as a double
result=get(handles.output,'UserData');
if ~isempty(result) && isfield(result,'OnionFiles')
    OnionFiles=result.OnionFiles;
end

if get(handles.customXYZ,'Value')
    OnionFiles.Center= str2num(char(regexp(get(handles.OnionCenterTextBox,'String'),',','split')))';
elseif get(handles.customAtomN,'Value')
    UniqueAtomName = get(handles.OnionCenterTextBox,'String');
    % Convert Syntax later as appropiate.
    RiboLabPDBs=result.RiboLabPDBs;
    numPDBs=length(RiboLabPDBs);
    I=0;j=0;
    while ~I && j < numPDBs
        j=j+1;
        [~,I]=ismember(UniqueAtomName,RiboLabPDBs(j).UniqueAtomNames);
    end
    if I == 0 && ~isempty(UniqueAtomName)
        error('Atom not found');
    elseif I > 0
        OnionFiles.Center = [RiboLabPDBs(j).PDB.Model.Atom(I).X, RiboLabPDBs(j).PDB.Model.Atom(I).Y, RiboLabPDBs(j).PDB.Model.Atom(I).Z];
    end
elseif get(handles.supPTC,'Value')
    OnionFiles.Center=[-32.3240 123.0920 161.9990];
elseif get(handles.supDCC,'Value')
    OnionFiles.Center= [-60.9250 89.2770 91.1510];
end
result.OnionFiles=OnionFiles;
set(handles.output,'UserData',result);

% --- Executes during object creation, after setting all properties.
function OnionCenterTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OnionCenterTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in OnionCenterButtons.
function OnionCenterButtons_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in OnionCenterButtons 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
drawnow();
result=get(handles.output,'UserData');
if ~isempty(result) && isfield(result,'OnionFiles')
    OnionFiles=result.OnionFiles;
end

  
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'supPTC'
        OnionFiles.Center=[-32.3240 123.0920 161.9990];
    case 'supDCC'
       OnionFiles.Center= [-60.9250 89.2770 91.1510];
    case 'customXYZ'
       OnionFiles.Center= str2num(char(regexp(get(handles.OnionCenterTextBox,'String'),',','split')))';
    case 'customAtomN'
        UniqueAtomName = get(handles.OnionCenterTextBox,'String');
        % Convert Syntax later as appropiate.
        RiboLabPDBs=result.RiboLabPDBs;
        numPDBs=length(RiboLabPDBs);
        I=0;j=0;
        while ~I && j < numPDBs
            j=j+1;
            [~,I]=ismember(UniqueAtomName,RiboLabPDBs(j).UniqueAtomNames);
        end
        if I == 0 && ~isempty(UniqueAtomName)
            error('Atom not found');
        elseif I > 0
            OnionFiles.Center = [RiboLabPDBs(j).PDB.Model.Atom(I).X, RiboLabPDBs(j).PDB.Model.Atom(I).Y, RiboLabPDBs(j).PDB.Model.Atom(I).Z];
        else
            return;
        end
        % Continue with more cases as necessary.
    otherwise
       error('Huh?');
end
result.OnionFiles=OnionFiles;
set(handles.output,'UserData',result);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Helix_File.
function Helix_File_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Helix_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
if ~isempty(result)
    file=result.File;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.csv';'*.*'},'Select the CSV File',file,...
    'MultiSelect','off');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    h=PleaseWait();
    file=fullfile(PathName,FileName);
    result.HelixDef=ReadHelixDefTemplate(file);
    set(hObject,'String',FileName);
    %result.StructureFile=file;
    set(handles.output,'UserData',result);
    delete(h);
end



function HelixColorFile_Callback(hObject, eventdata, handles)
% hObject    handle to HelixColorFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HelixColorFile as text
%        str2double(get(hObject,'String')) returns contents of HelixColorFile as a double


% --- Executes during object creation, after setting all properties.
function HelixColorFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HelixColorFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over HelixColorFile.
function HelixColorFile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to HelixColorFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
if ~isempty(result)
    file=result.File;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.csv';'*.*'},'Select the CSV File',file,...
    'MultiSelect','off');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    file=fullfile(PathName,FileName);
    result.HelixColorFile=file;
    set(hObject,'String',FileName);
    set(handles.output,'UserData',result);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Domain_File.
function Domain_File_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Domain_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
if ~isempty(result)
    file=result.File;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.csv';'*.*'},'Select the CSV File',file,...
    'MultiSelect','off');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    h=PleaseWait();
    file=fullfile(PathName,FileName);
    result.DomainDef=ReadDomainDefTemplate(file);
    set(hObject,'String',FileName);
    %result.StructureFile=file;
    set(handles.output,'UserData',result);
    delete(h);
end



function DomainColorFile_Callback(hObject, eventdata, handles)
% hObject    handle to DomainColorFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DomainColorFile as text
%        str2double(get(hObject,'String')) returns contents of DomainColorFile as a double


% --- Executes during object creation, after setting all properties.
function DomainColorFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DomainColorFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over DomainColorFile.
function DomainColorFile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to DomainColorFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
if ~isempty(result)
    file=result.File;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.csv';'*.*'},'Select the CSV File',file,...
    'MultiSelect','off');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    file=fullfile(PathName,FileName);
    result.DomainColorFile=file;
    set(hObject,'String',FileName);
    set(handles.output,'UserData',result);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over FullFR3DFile.
function FullFR3DFile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to FullFR3DFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
if ~isempty(result)
    file=result.File;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.csv';'*.*'},'Select the FR3D File',file,...
    'MultiSelect','off');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    file=fullfile(PathName,FileName);
    RiboLabFullBP = Fr3D2BP(file);
    result.RiboLabFullBP=RiboLabFullBP;
    set(hObject,'String',FileName);
    set(handles.output,'UserData',result);
end



function AlignmentFile_Callback(hObject, eventdata, handles)
% hObject    handle to AlignmentFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AlignmentFile as text
%        str2double(get(hObject,'String')) returns contents of AlignmentFile as a double


% --- Executes during object creation, after setting all properties.
function AlignmentFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AlignmentFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over AlignmentFile.
function AlignmentFile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to AlignmentFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
if ~isempty(result)
    file=result.File;
else
    file='.\';
end
[FileName,PathName] = uigetfile({'*.*'},'Select the Fasta File',file,...
    'MultiSelect','off');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    file=fullfile(PathName,FileName);
    result.AlignmentFile=file;
    %RiboLabFullBP = Fr3D2BP(file);
    %result.RiboLabFullBP=RiboLabFullBP;
    set(hObject,'String',FileName);
    set(handles.output,'UserData',result);
end


% --- Executes on button press in ProteinOnionBox.
function ProteinOnionBox_Callback(hObject, eventdata, handles)
% hObject    handle to ProteinOnionBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ProteinOnionBox


% --------------------------------------------------------------------
function Export_results_Callback(hObject, eventdata, handles)
% hObject    handle to Export_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
results=get(handles.output,'UserData');
assignin('base',get(handles.DataSetName,'String'),results);


% --- Executes on button press in CoVarEntropyBox.
function CoVarEntropyBox_Callback(hObject, eventdata, handles)
% hObject    handle to CoVarEntropyBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CoVarEntropyBox
if get(hObject,'Value')
    set(handles.FR3D_InteractionsBox,'Value',1)
end
