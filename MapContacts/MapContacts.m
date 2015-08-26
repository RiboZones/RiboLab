function [ map,AD,Data] = MapContacts(name1,name2,chain,cutoff,IncludeRes,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
SkipMap=false();
FilterAsp=false();
SkipResidues=false();

if nargin > 5
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'IncludeResTarget'
                IncludeResTarget=varargin{2*ind};
            case 'SkipMap'
                SkipMap=varargin{2*ind};
            case 'FilterAsp'
                FilterAsp=varargin{2*ind};
        end
    end
end
map=struct('contacts',{{}},'residues',{{}},'Y',{{}});
if SkipMap
    return
end

if strcmp(name2,'single')
    Data.PDB=name1;
    Data.FAM=FullAtomModel(Data.PDB.ID);
    Data.FAM.PopulateFAM(Data.PDB.PDB);
    Data.RES=Residues(Data.PDB.ID);
    Data.RES.GroupResidues(Data.FAM);
    RES=Residues([Data.RES.Name,'cut']);
    RES.CutRes(1:length(Data.RES.ItemNames),Data.RES);
    
    [contacts, residues, Y,AD]=CloseBy(RES,Data.RES,cutoff,varargin{:});
    KeepRows=true(size(Y,1),1);
    
    switch FilterAsp
        case 'Include ASP'
            for i=1:size(Y,1);
                KeepRows(i)=~isempty(cell2mat(regexp(cellstr(Y{i,3})','ASP')));
            end
        case 'Include All'
            
            
        case 'Exclude ASP'
            for i=1:size(Y,1);
                KeepRows(i)=isempty(cell2mat(regexp(cellstr(Y{i,3})','ASP')));
            end            
    end
    map.contacts=contacts(KeepRows)';
    map.residues=residues(KeepRows)';
    map.Y=Y(KeepRows,:);
    
    return
end
if  ~strcmp(class(name1),'PDBentry')&& ~strcmp(class(name2),'PDBentry')
    if strfind(name1,'.pdb')>1 && strfind(name2,'.pdb') >1
        file1=name1;
        file2=name2;
        Name1='name1';
        Name2='name2';
    else
        file1='gui';
        file2='gui';
        Name1=name1;
        Name2=name2;
    end
    Data.PDB.(Name1)=PDBentry(Name1);
    Data.PDB.(Name2)=PDBentry(Name2);
    
    Data.PDB.(Name1).ImportPDB(file1);
    Data.PDB.(Name2).ImportPDB(file2);
else
    Name1='name1';
    Name2='name2';
    Data.PDB.(Name1)=name1;
    switch class(name2)
        case 'struct'
             Data.PDB.(Name2)=name2.PDB;
        case 'PDBentry'
            Data.PDB.(Name2)=name2;
        case 'Residues'
            SkipResidues=true;
            Data.RES.(Name2)=name2;
    end
    
end
Data.FAM.(Name1)=FullAtomModel(Data.PDB.(Name1).ID);
Data.FAM.(Name1).PopulateFAM(Data.PDB.(Name1).PDB);
Data.RES.(Name1)=Residues(Data.PDB.(Name1).ID);
Data.RES.(Name1).GroupResidues(Data.FAM.(Name1));

if ~SkipResidues
    Data.FAM.(Name2)=FullAtomModel(Data.PDB.(Name2).ID);
    Data.FAM.(Name2).PopulateFAM(Data.PDB.(Name2).PDB);
    %single chain hack
    if length(unique([Data.PDB.name2.PDB.Model.Atom.chainID]))==1
        chain=unique([Data.PDB.name2.PDB.Model.Atom.chainID]);
    end
    if isempty(chain)
        chain=unique([Data.PDB.name2.PDB.Model.Atom.chainID]);
    end
    x=Chain(Data.PDB.(Name2).ID,chain);
    x.CreateChain(Data.FAM.(Name2),chain);
    Data.RES.(Name2)=x.residues;
end

if nargin > 4 && ~isempty(IncludeRes)
    [~,subset]=ismember(IncludeRes,regexprep(Data.RES.(Name1).ItemNames,'[\d\w]_\s*',''));
    subset=subset(subset>0);
    SubsetRes1=Residues([Data.PDB.(Name1).ID, '_cut']);
    SubsetRes1.CutRes(subset,Data.RES.(Name1));
else
    SubsetRes1=Data.RES.(Name1);
end
if exist('IncludeResTarget','var')
    [~,subset]=ismember(IncludeResTarget,Data.RES.(Name2).ItemNames);
    subset=subset(subset>0);
    SubsetRes2=Residues([Data.PDB.(Name2).ID, '_cut']);
    SubsetRes2.CutRes(subset,Data.RES.(Name2));
else
    SubsetRes2=Data.RES.(Name2);
end
try
    [contacts, residues, Y,AD]=CloseBy(SubsetRes1,SubsetRes2,cutoff,varargin{:});
catch ME
    contacts={''};
    residues={''};
    Y={'','','',''};
end
map.contacts=contacts';
map.residues=residues';
map.Y=Y;
Data.SubsetRes1=SubsetRes1;
Data.SubsetRes2=SubsetRes2;
end
function [ Contact, Residues, Y, AD] = CloseBy(A,B,cutoff,varargin)

AtomFilterType='anything';
InterActionFilter='any';
InterActionFilterAtom='any';
numContacts=1;
numContactsAtom=1;
SkipFilter = false();

if nargin > 3
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'AtomFilterType'
                AtomFilterType=varargin{2*ind};
            case 'InterActionFilter'
                InterActionFilter=varargin{2*ind};
            case 'numContacts'
                numContacts=varargin{2*ind};
            case 'numContactsAtom'
                numContactsAtom=varargin{2*ind};
            case 'RealAtomsNames_B'
                RealAtomsNames_B=varargin{2*ind};
                SkipFilter = true;
        end
    end
end


if iscell(AtomFilterType)
    [A,~]=AtomFilter(A,AtomFilterType{1});
    if ~SkipFilter
        [B,RealAtomsNames_B]=B.AtomFilter(AtomFilterType{2});
    end
elseif ischar(AtomFilterType)
    if ~SkipFilter
        [B,RealAtomsNames_B]=B.AtomFilter(AtomFilterType);
    end
else
    error('Bad AtomFilterType Input.')
end


if cutoff~=inf
    NN=nearestneighbour(cell2mat(A.Position)',cell2mat(B.Position)','r',cutoff);
else
    NN=nearestneighbour(cell2mat(A.Position)',cell2mat(B.Position)');
end

if size(cell2mat(A.Position)',2)==1
    NN=NN';
end
% Come back to fix up Atomic Distance Feature
%     posA=cell2mat(A.Position')';
%     X=cell2mat(B.Position')';
%
%     posB=X(:,NN);
%
%
%     atomicdistances=sqrt(sum((posA-posB).^2));
%end

switch InterActionFilterAtom
    case 'any'
        ResAcontacts=logical(NN(1,:));
        ResBcontacts=NN(:,ResAcontacts);
    case 'specific'
        ResAcontacts=sum(logical(NN),1)==numContactsAtom;
        ResBcontacts=NN(:,ResAcontacts);
        %     case 'single'
        %         ResAcontacts=sum(logical(NN),1)==1;
        %         ResBcontacts=NN(:,ResAcontacts);
    case 'multiple'
        ResAcontacts=sum(logical(NN),1)>1;
        ResBcontacts=NN(:,ResAcontacts);
    case 'mediated'
        
end


resSeqA=[A.UniqueResSeq{:}];
resSeqB=[B.UniqueResSeq{:}];

if sum(ResAcontacts)
    AtomsA=resSeqA(ResAcontacts);
    %     ResB=ResBcontacts;
else
    %     find way to end early;
    return
end

ListA=unique(AtomsA);
numHits=length(ListA);
ListB=cell(numHits,1);
ListBnames=cell(numHits,1);
ListAnames=cell(numHits,1);
ContactsB=cell(numHits,1);
ContactsA=cell(numHits,1);
ListAnumbers=cell(numHits,1);

AtomContacts=cell(numHits,1);
KeepRow=true(numHits,1);


for j=1:numHits
    KeepAtoms=ismember(AtomsA,ListA{j});
    B_indices=ResBcontacts(:,KeepAtoms);
    B_indices=unique(B_indices(logical(B_indices)));
    a=RealAtomsNames_B(B_indices);
    for k=1:length(a)
        AtomContacts{j}{k}=[a(k).chemSymbol,a(k).remoteInd,a(k).branch];
    end
    
    ListB{j}=unique(resSeqB(B_indices));
    
    [~,indexA]=ismember(ListA,A.ItemNames);
    nonidenty=setdiff(ListB{j},A.ItemNames(indexA(j)))';
    if isempty(nonidenty)
        KeepRow(j)=false;
    else
        ListB{j}=nonidenty;
    end
    
    switch InterActionFilter
        case 'any'
            
        case 'specific'
            if length(ListB{j})~=numContacts
                KeepRow(j)=false;
            end
        case 'multiple'
            if length(ListB{j})==1
                KeepRow(j)=false;
            end
        case 'mediated'
            
    end
    if ~isempty(ListB{j})
        [~,index]=ismember(ListB{j},B.ItemNames);
        ListBnames{j}=B.ResidueName(index);
        ListAnames{j}=A.ResidueName{indexA(j)};
        ListAnumbers{j}=A.ItemNames(indexA(j));
        ContactsB{j}=[char(ListBnames{j}),repmat('_',length(ListB{j}),1),...
            char(ListB{j}),repmat('  ',length(ListB{j}),1)];
        ContactsA{j}=[char(ListAnames{j}),'_',char(ListA{j}),'  '];
    end
    
end



% AD=zeros(1,size(ListA,2));
% if cutoff==inf
%     for i=1:length(AD)
%         AD(i)=min(atomicdistances(ListA(i)==resSeqA));
%     end
% end
AD='notsupported';

Contact=ListB(KeepRow)';
Residues=ListBnames(KeepRow)';
Y=cell(length(ListA(KeepRow)),3);
if ~isempty(ListA(KeepRow))
    Y(:,2)=ContactsA(KeepRow);
else
    Y(:,2)=[];
end
Y(:,1)=ListAnumbers(KeepRow);
Y(:,3)=ContactsB(KeepRow);
% Y(:,4)=Residues;
Y(:,4)=AtomContacts(KeepRow);
end



