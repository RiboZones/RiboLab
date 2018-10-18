function varargout = RiboLabRV2(varargin)
% RIBOLABRV2 MATLAB code for RiboLabRV2.fig
%      RIBOLABRV2, by itself, creates a new RIBOLABRV2 or raises the existing
%      singleton*.
%
%      H = RIBOLABRV2 returns the handle to a new RIBOLABRV2 or the handle to
%      the existing singleton*.
%
%      RIBOLABRV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RIBOLABRV2.M with the given input arguments.
%
%      RIBOLABRV2('Property','Value',...) creates a new RIBOLABRV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RiboLabRV2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RiboLabRV2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RiboLabRV2

% Last Modified by GUIDE v2.5 12-Jun-2018 14:56:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RiboLabRV2_OpeningFcn, ...
    'gui_OutputFcn',  @RiboLabRV2_OutputFcn, ...
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


% --- Executes just before RiboLabRV2 is made visible.
function RiboLabRV2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RiboLabRV2 (see VARARGIN)

% Choose default command line output for RiboLabRV2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RiboLabRV2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RiboLabRV2_OutputFcn(hObject, eventdata, handles)
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
[FileName,PathName] = uigetfile({'*.cif';'*.pdb';'*.*'},'Select the mmCIF or pdb files',file,...
    'MultiSelect','on');
if ~isequal(FileName,0) && ~isequal(PathName,0)
    h=PleaseWait();
    if iscell(FileName)
        numFiles=length(FileName);
    else
        numFiles = 1;
        FileName={FileName};
    end
    RiboLabCads=[];
    RiboLabPDBs=[];
    
    for i=1:numFiles
        file=fullfile(PathName,FileName{i});
        [a,b]=CadsSet(file);
        RiboLabCads = [RiboLabCads,a];
        RiboLabPDBs = [RiboLabPDBs,b];
    end
%     FullFileList='';
%     [~,DataSetName_piece]=fileparts(file);
%     FullFileList = [FullFileList,DataSetName_piece,', '];
%     DataSetName='';
%     DataSetName = [DataSetName,DataSetName_piece,'_'];
%     DataSetName(end)=[];
%     FullFileList(end-1:end)=[];

    result.RiboLabCads=RiboLabCads;
    result.RiboLabPDBs=RiboLabPDBs;

    result.File=file;
    
   
    set(handles.output,'UserData',result);
   
    numCads=length(RiboLabCads);
    CadsTable=cell(numCads,5);
    subunit='';
    for i =1:numCads
        CadsTable{i,1}=RiboLabCads(i).Name;
        x=regexpi(RiboLabCads(i).Name,'RIBOSOMAL PROTEIN ([\w][^\s:]+)','tokens');
        if isempty(x)
            x=regexp(RiboLabCads(i).Name,'([\d\.]+S)','tokens');
            if isempty(x)
                x=regexp(RiboLabCads(i).Name,'([^:]+):','tokens');
                CadsTable(i,4)=regexprep(x{1},'\.','p');
                CadsTable{i,3}='other';
                CadsTable{i,2}='LSU'; % Guess, needs manual correcting. 
            else
                CadsTable(i,4)=x{1};
                CadsTable{i,3}='rRNA';
                CadsTable{i,2}='LSU'; % Guess, needs manual correcting. 
            end
        else
            %CadsTable(i,3)=regexprep(x{1},'-','');
            %Sanitize names to be valid field names. Remove later maybe. 
            t=regexprep(x{1},'[^\w]+','_');
            CadsTable(i,4)=regexprep(t,'^(\d)','z$1');

            %Guess subunit based on first rProtein. 
            if strcmp(x{1}{1}(1),'L')
                subunit='LSU';
            elseif strcmp(x{1}{1}(1),'S')
                subunit='SSU';
            end
            CadsTable{i,3}='rProtein';
            CadsTable{i,2}=subunit;
        end
        y=regexp(RiboLabCads(i).Name,':\sChain\(s\)\s([\w\d]+)','tokens');
        CadsTable(i,5)=y{1};
    end
    set(handles.MoleculeNamesTable,'Data',CadsTable);
      
    %Guess species abreviation (four letters)
    sn=regexp(RiboLabCads(1).Species{1},'([\w][\w])[^\s]*\s([\w][\w])[\w]*','tokens');
    sn=[upper(sn{1}{1}(1)),lower(sn{1}{1}(2)),upper(sn{1}{2}(1)),lower(sn{1}{2}(2))];
    
    set(handles.DataSetName,'String',[sn,'_',subunit]);
%     set(hObject,'String',FullFileList);
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
rRNA_Chains=[];
rProtein_Chains=[];
ProteinMenu=[];

numCads=length(RiboLabCads);
for i=1:numCads
    if strcmp(CadsTable(i,3),'rRNA')
        RiboLabCads_rRNA=[RiboLabCads_rRNA,RiboLabCads(i)];
        RiboLabCads_rRNA_Names=[RiboLabCads_rRNA_Names,CadsTable{i,4}];
        rRNA_Chains=[rRNA_Chains,';',CadsTable{i,5}];
    elseif strcmp(CadsTable(i,3),'rProtein')
        RiboLabCads_rProtein=[RiboLabCads_rProtein,RiboLabCads(i)];
        RiboLabCads_rProtein_Names=[RiboLabCads_rProtein_Names,CadsTable{i,4}];
        rProtein_Chains=[rProtein_Chains,';',CadsTable{i,5}];
        ProteinMenu=[ProteinMenu;{[CadsTable{i,3},':',CadsTable{i,4},':',CadsTable{i,5}]}];
    end
    MoleculeChainMap.(['mol_',CadsTable{i,4}])=CadsTable{i,5};
    ChainMoleculeMap.(['chain_',CadsTable{i,5}])=CadsTable{i,4};
    MoleculeGroupMap.(['mol_',CadsTable{i,4}])=CadsTable{i,2};
end
result.rRNA_Chains=rRNA_Chains;
result.rProtein_Chains=rProtein_Chains;
result.MoleculeChainMap=MoleculeChainMap;
result.ChainMoleculeMap=ChainMoleculeMap;
result.MoleculeGroupMap=MoleculeGroupMap;
result.RiboLabCads_rProtein_Names=RiboLabCads_rProtein_Names;
result.RiboLabCads_rRNA_Names=RiboLabCads_rRNA_Names;
result.ProteinMenu=ProteinMenu;

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
        chainID=regexp(Thermal_Factor_Table{j,1},'([^_]+)_','tokens');
        Thermal_Factor_Table{j,1}=regexprep(Thermal_Factor_Table{j,1},'([^_]+)_',[ChainMoleculeMap.(['chain_',chainID{1}{1}]),':']);
        if isempty(Thermal_Factor_Table{j,2})
            Thermal_Factor_Table{j,2}='';
        else
             Thermal_Factor_Table{j,2}=num2str(Thermal_Factor_Table{j,2});
        end
    end
     result.Thermal_Factor_Table=Thermal_Factor_Table;
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
    %BP2Table([FilteredBP{:}],'TableFormat','website','ItemList',RiboLabMap.ItemNames);
    BPorg=BPorganize([FilteredBP{:}]);
    BPorg(5)=[]; % Remove other type
    DeDupped_BPs=DeDupBP(BPorg);
    FR3D_Interaction_Tables=BP2Table(DeDupped_BPs,'TableFormat','website2','ItemList',RiboLabMap.ItemNames,'ItemList2',ResidueList,'Merge',false);
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
        result=PaseEntropyStruct(result); % So meta, maybe fix this sometime. 
        %result.CoVarEntropy_Table=[result.ResidueList(1:length(H_CoVar)),num2cell(H_CoVar')];
        %result.CoVarEntropy_Table=vertcat(result.CoVarEntropy_Table, ...
          %  [result.ResidueList(length(H_CoVar)+1:end),repmat({'\N'},...
          %  length(result.ResidueList(length(H_CoVar)+1:end)),1)]);
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
    chains=unique(cellstr(vertcat(NewTarget.PDB.PDB.Model.Atom.chainID)));
    x=Chain('',chains);
    x.CreateChain(rvfam,chains);
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
        Protein_Interaction_Table=BP2Table(RiboLab_BP_NPN,'TableFormat','website2','ItemList',RiboLabMap.ItemNames,'ItemList2',ResidueList,'ProteinCol',RiboLabCads_rProtein_Names);
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
            pct=ProteinContactTable(RiboLabCads,RiboLabMap,'TableFormat','website2','Magnesium',true,'CombineCols',true);
            % Take first species only, this program doesn't allow
            % processing of more than one species at a time. 
            Mg_Individual_Contact_Table{k} = [pct{1}(:,1), num2cell(sum(cell2mat(pct{1}(:,2:end)),2))];
        end
        result.Mg_Individual_Contact_Table=Mg_Individual_Contact_Table(end:-1:1); 
        result.MgColNames=MgColNames(end:-1:1);
    end
    
    if get(handles.MagInteractionBox,'value')
        RiboLab_BP_NMN = ContactMap2BP(RiboLabCads,'MapMode','withinTarget','bp_type','NMN');
        Magnesium_Interaction_Table=BP2Table(RiboLab_BP_NMN,'TableFormat','website2','ItemList',RiboLabMap.ItemNames,'ItemList2',ResidueList);
        result.Magnesium_Interaction_Table=Magnesium_Interaction_Table;
    end
end

result.RiboLabCads_rRNA=RiboLabCads_rRNA;
result.RiboLabCads_rProtein=RiboLabCads_rProtein;
set(handles.output,'UserData',result);
delete(h);


% --- Executes on button press in SaveBtn.
function SaveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result=get(handles.output,'UserData');
RiboLabMap=result.RiboLabMap;
%RiboLabCads_rRNA= result.RiboLabCads_rRNA;
%result.RiboLabCads_rProtein_Names
%result.RiboLabCads_rRNA_Names
%RiboLabCads_rProtein = result.RiboLabCads_rProtein;
%ResidueList=result.ResidueList;
%R=[RiboLabCads_rRNA.PDB];
Table = cell2table(RiboLabMap.BasicTable(result.ResidueList),'VariableNames',{'map_Index','molName','resNum','unModeResName','modResName','X','Y'});
numData=height(Table);
molecules=cellstr(horzcat(repmat('mol_',height(Table),1),char(Table.molName)));
molecule_group = cell(numData,1);
ss_table = cell(numData,1);
for i = 1:numData
    molecule_group{i} = result.MoleculeGroupMap.(molecules{i});
    ss_table{i} = [get(handles.DataSetName,'String'),'_',molecule_group{i}];
end
% split_name=regexp(get(handles.DataSetName,'String'),'_','split');
% if length(split_name) < 2
%     split_name{2}='';
% end
Table=[Table,table(ss_table,'VariableNames', {'SS_Table'})];
[DataSetName_path]=fileparts(result.File);
writetable(Table, [DataSetName_path,'\',get(handles.DataSetName,'String'),'_SecondaryStructures','.csv'] );

Table_SD2=Table(:,1);
if get(handles.DomainDefbox,'value')
    t=cell2table(result.Domain_Table(:,2:4),'VariableNames',{'Domain_RN','Domain_AN','Domains_Color'});
    Table_SD2=[Table_SD2,t];
end
if get(handles.helixDefBox,'value')
    t=cell2table(result.Helix_Table(:,2:3),'VariableNames',{'Helix_Num','Helix_Color'});
    Table_SD2=[Table_SD2,t];
end
if ~isempty(Table_SD2)
    Table_SD2=[Table_SD2,Table(:,8)];
    writetable(Table_SD2, [DataSetName_path,'\',get(handles.DataSetName,'String'),'_StructuralData2','.csv']);
end

Table_SD3  = cell2table(cell(0,4), 'VariableNames', {'map_Index', 'Value', 'VariableName', 'StructureName'});

if get(handles.meanBFactBox,'value')
    t=table(Table.map_Index,result.Thermal_Factor_Table(:,2),repmat({'mean_tempFactor'},numData,1),repmat(result.RiboLabPDBs.ID,numData,1),...
        'VariableNames', {'map_Index', 'Value', 'VariableName', 'StructureName'});
    Table_SD3=[Table_SD3;t];
end

if get(handles.MagContactsBox,'value')
    numMgcutoffs = length(result.Mg_Individual_Contact_Table);
    for i = 1:numMgcutoffs
        t=table(Table.map_Index,result.Mg_Individual_Contact_Table{i}(:,2),repmat(result.MgColNames(i),numData,1),repmat(result.RiboLabPDBs.ID,numData,1),...
            'VariableNames', {'map_Index', 'Value', 'VariableName', 'StructureName'});
        % Remove residues with no Mg contacts, they can be asumed.
        t=t(logical(cell2mat(t.Value)),:);
        Table_SD3=[Table_SD3;t];
    end
end

if ~isempty(Table_SD3)
    writetable(Table_SD3, [DataSetName_path,'\',get(handles.DataSetName,'String'),'_StructuralData3','.csv'] );
end

if get(handles.ProteinContactsBox,'value')
   Table_ProteinContacts  = cell2table(cell(0,3), 'VariableNames', {'map_Index', 'ProtName', 'StructureName'});

   numProts = size(result.Protein_Contact_Table,2) - 1;
   pcts=cell2mat(result.Protein_Contact_Table(:,2:end));
   for i = 1:numProts
       keepRes = Table.map_Index(pcts(:,1)>0);
       numkr = length(keepRes);
       t=table(keepRes,repmat(result.RiboLabCads_rProtein_Names(i),numkr,1),repmat(result.RiboLabPDBs.ID,numkr,1),...
        'VariableNames', {'map_Index', 'ProtName' 'StructureName'});
        Table_ProteinContacts=[Table_ProteinContacts;t];
   end
end

if ~isempty(Table_ProteinContacts)
    writetable(Table_ProteinContacts, [DataSetName_path,'\',get(handles.DataSetName,'String'),'_ProteinContacts','.csv'] );
end

if get(handles.ProteinInteractionBox,'value')
    NPN={'residue_i','residue_j','bp_type','bp_group','ProteinResName','ProteinResNo','StructureName'};
    writetable(cell2table([result.Protein_Interaction_Table,cellstr(repmat(result.RiboLabPDBs(1).ID,...
        length(result.Protein_Interaction_Table),1))],'VariableNames',NPN),...
        [DataSetName_path,'\',get(handles.DataSetName,'String'),'_ProteinInteractions','.csv'] );    
end

Table_Interactions  = cell2table(cell(0,5), 'VariableNames', {'residue_i','residue_j','bp_type','bp_group','StructureName'});

if get(handles.MagInteractionBox,'value')
    t=cell2table([result.Magnesium_Interaction_Table,cellstr(repmat(result.RiboLabPDBs(1).ID,...
        length(result.Magnesium_Interaction_Table),1))],'VariableNames',{'residue_i','residue_j','bp_type','bp_group','StructureName'});
    Table_Interactions=[Table_Interactions;t];
end
if get(handles.FR3D_InteractionsBox,'value')
    t=cell2table([result.FR3D_Interaction_Tables,cellstr(repmat(result.RiboLabPDBs(1).ID,...
        length(result.FR3D_Interaction_Tables),1))],'VariableNames',{'residue_i','residue_j','bp_type','bp_group','StructureName'});
    Table_Interactions=[Table_Interactions;t];
end

if ~isempty(Table_Interactions)
    writetable(Table_Interactions, [DataSetName_path,'\',get(handles.DataSetName,'String'),'_Interactions','.csv'] );
end

Table_Entropy  = cell2table(cell(0,4), 'VariableNames', {'map_Index', 'Value', 'EntropyType', 'StructureName'});

if get(handles.EntropyBox,'value')
    t=table(Table.map_Index,result.Entropy_Table(:,2),repmat({'Shannon_Entropy'},numData,1),repmat(result.RiboLabPDBs.ID,numData,1),...
        'VariableNames', {'map_Index', 'Value', 'EntropyType', 'StructureName'});
    Table_Entropy=[Table_Entropy;t];
    
       writetable(table(Table.map_Index,result.Conservation_Table(2:end,3),...
           result.Conservation_Table(2:end,4),result.Conservation_Table(2:end,5),...
       result.Conservation_Table(2:end,6),result.Conservation_Table(2:end,7),...
       result.Conservation_Table(2:end,8),Table.SS_Table,'VariableNames',{'map_Index',...
       'Consensus','A', 'C', 'G', 'U', 'Gaps','SS_Table'}), [DataSetName_path,...
        '\',get(handles.DataSetName,'String'),'_ConservationTable','.csv'] );
  
end

if get(handles.CoVarEntropyBox,'value')
     t=table(Table.map_Index,result.CoVarEntropy_Table(:,2),repmat({'PASE'},numData,1),repmat(result.RiboLabPDBs.ID,numData,1),...
        'VariableNames', {'map_Index', 'Value', 'EntropyType', 'StructureName'});
    Table_Entropy=[Table_Entropy;t];
end

if ~isempty(Table_Entropy)
    writetable(Table_Entropy, [DataSetName_path,'\',get(handles.DataSetName,'String'),'_Conservation','.csv'] );
end
 
%%Species Table Load CSV
SpeciesTable=struct();
spn=result.RiboLabCads_rRNA(1).Species{1};
sn=regexp(spn,'([^\s]+)\s(.+)','tokens');

SpeciesTable.Species_Name=[upper(sn{1}{1}(1)),lower(sn{1}{1}(2:end)),' ',...
    lower(sn{1}{2})];

dsn=get(handles.DataSetName,'String');
if strfind(dsn,'_') > 0
    dsn2=regexp(dsn,'([^_]+)_(.+)','tokens');
    SpeciesTable.Species_Abr=dsn2{1}{1};
    SpeciesTable.Subunit=dsn2{1}{2};
else 
    SpeciesTable.Species_Abr=dsn;
    %SpeciesTable.Subunit='other';

end

%SpeciesTable.Species_Name=spn;
%SpeciesTable.DataSetName='<b>3D-based Structure</b> (recommended)';
%SpeciesTable.MapType='3D-based';
%SpeciesTable.Orientation='portrait';
SpeciesTable.SS_Table=[dsn,'_LSU'];
SpeciesTable.Font_Size_SVG=round(RiboLabMap.FontSize,1);
% Magic correction factor for canvas font size. Reason unknown. 
SpeciesTable.Font_Size_Canvas=round(0.8*RiboLabMap.FontSize,1);
% Magic number to get reasonably sized circles. 
SpeciesTable.Circle_Radius=round(.55*RiboLabMap.FontSize,1);

writetable(struct2table(SpeciesTable), [DataSetName_path,...
    '\',get(handles.DataSetName,'String'),'_SecondaryStructureDetails','.csv'] );

% Chain List
numRNAs = length(result.RiboLabCads_rRNA_Names);
ChainList=[cellstr(repmat(result.RiboLabPDBs(1).ID,numRNAs,1)),...
    result.RiboLabCads_rRNA_Names',regexp(result.rRNA_Chains(2:end),';','split')'];
% After RNA, do protein
numProts = length(result.RiboLabCads_rProtein_Names);
ChainList=[ChainList; cellstr(repmat(result.RiboLabPDBs(1).ID,numProts,1)),...
   result.RiboLabCads_rProtein_Names',regexp(result.rProtein_Chains(2:end),';','split')'];

writetable(cell2table(ChainList, 'VariableNames',{'StructureName','MoleculeName','ChainName'}), [DataSetName_path,...
    '\',get(handles.DataSetName,'String'),'_ChainList','.csv'] );

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
    % New center based on cif file, 4V9D
    OnionFiles.Center=[-79.501 -50.248 4.312];
elseif get(handles.supDCC,'Value')
    % No new DCC defined yet. Using this would lead to incorrect results. 
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
