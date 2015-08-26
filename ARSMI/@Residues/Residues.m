%% DOCUMENT TITLE
% INTRODUCTORY TEXT
%%
classdef Residues < handle
    %Residues organizes data into residues
    %   throws out more uneeded data and groups by resid
    
    properties (SetAccess = private)
        Name
        ItemNames
        ResidueNumber
        ResidueName
        ResidueChain
%         ListOfResidues
%         ListOfResiduesU
%         NamesOfResidues
%         NamesOfResiduesU
        Atoms
        Position
%         ResSeq
        UniqueResSeq
%         ChainID
        tempFactor
    end
    %% SECTION TITLE
    % DESCRIPTIVE TEXT
    
    methods
        function Res = Residues(name)
            if nargin <1
                Res.Name='';
            else
                Res.Name=name;
            end
        end
        
        %         function GroupResidues(Res,FAM)
        %             List_Residues=unique([FAM.Model.resSeq]);
        %             num_Residues=length(List_Residues);
        % %             atoms=cell(1,num_Residues);
        %             r=cell(1,num_Residues);
        %             resseq=cell(1,num_Residues);
        %
        %             % Organizes residue numbers and position (x,y,z) data
        %             %data=[[FAM.Model.X]; [FAM.Model.Y];[FAM.Model.Z]]';
        %             dataX=[FAM.Model.X]';
        %             dataY=[FAM.Model.Y]';
        %             dataZ=[FAM.Model.Z]';
        %
        %             resSeq=[FAM.Model.resSeq];
        %             % Find position (r) data for each residue, also, record atom
        %             % names
        %             ANS=[FAM.Model.AtomNameStruct];
        %             atoms(num_Residues,30)=struct('chemSymbol','','remoteInd','','branch','');
        %             for index=1:num_Residues
        %                 indices=resSeq==List_Residues(index);
        %                 r{index}=[dataX(indices),dataY(indices),dataZ(indices)];
        %                 atoms(index,1:sum(indices))=ANS(indices);
        %                 resseq{index}=resSeq(indices);
        % %                 Atoms{index}=[FAM.Model(indices).AtomNameStruct];
        %             end
        %
        %             % Find the name of each residue
        %             [~, I]=unique([FAM.Model.resSeq],'first');
        %             Names_Residues={FAM.Model(I).resName};
        %
        %             % Output block
        %             Res.ListOfResidues=List_Residues;
        %             Res.NamesOfResidues=Names_Residues;
        %             Res.Atoms=atoms;
        %             Res.ResSeq=resseq;
        %             Res.Position=r;
        %         end
        
        
        % function GroupResiduesUnique(Res,FAM,SphPosition)
        function GroupResidues(Res,Structure,SphPosition)
            switch class(Structure)
                case 'FullAtomModel'
                    FAM=Structure;
                case 'PDBentry'
                    FAM.UniqueResSeq=Structure.UniqueResSeq;
                    FAM.ChainID=Structure.ChainID;
                    FAM.Model=Structure.PDB.Model.Atom;
                case 'CADS'
                    FAM.UniqueResSeq=Structure.PDB.UniqueResSeq;
                    FAM.ChainID=Structure.PDB.ChainID;
                    FAM.Model=Structure.PDB.PDB.Model.Atom;
            end
            %             if isempty(FAM.UniqueResSeq)
            %                 FAM.renumberRes()
            %             end
            %             List_Residues=unique([FAM.Model.resSeq]);
            %             List_ResiduesU=unique(FAM.UniqueResSeq);
            
            [urs,I]=unique(FAM.UniqueResSeq);
            if issorted(I)
                AtomRes=I;
                Res.ItemNames=urs;
            else
                [~,uniqueind]=sort(I);
                Res.ItemNames=urs(uniqueind);
                AtomRes=I(uniqueind);
            end
            
            
            %             num_Residues=length(List_Residues);
            num_ResiduesU=length(Res.ItemNames);
            
            r=cell(num_ResiduesU,1);
            resnum=cell(num_ResiduesU,1);
            resSeqU=cell(num_ResiduesU,1);
            tempFactors=cell(num_ResiduesU,1);
            %             resseq=cell(1,num_ResiduesU);
%             resseqU=cell(num_ResiduesU,1);
            
            if nargin > 2
                dataX=SphPosition(:,1);
                dataY=SphPosition(:,2);
                dataZ=SphPosition(:,3);
            else
                dataX=[FAM.Model.X]';
                dataY=[FAM.Model.Y]';
                dataZ=[FAM.Model.Z]';
            end
            %             resSeq=[FAM.Model.resSeq];
            %             resSeqU=FAM.UniqueResSeq;
            
            AtNaStr=[FAM.Model.AtomNameStruct];
            %             atoms(num_ResiduesU,30)=struct('chemSymbol','','remoteInd','','branch','');
            
            [~,J]=ismember(FAM.UniqueResSeq,Res.ItemNames);
            atoms=repmat(struct('chemSymbol','','remoteInd','','branch',''),...
                num_ResiduesU,sum(J==mode(J)));
            
            [~,II]=unique(J,'first');
            [~,III]=unique(J,'last');
            R=[dataX,dataY,dataZ];
            
            for index=1:num_ResiduesU
    
                %% New way
                indices=II(index):III(index);
                atoms(index,1:length(indices))=AtNaStr(indices);
                r{index}=R(indices,:);
                resnum{index}=Res.ItemNames{index}(3:end);
                resSeqU{index}=FAM.UniqueResSeq(indices)';
                tempFactors{index}=[FAM.Model(indices).tempFactor]';
                %% old way
%                 seleRes=ismember(FAM.UniqueResSeq,Res.ItemNames{index});
%                 r{index}=[dataX(seleRes),dataY(seleRes),dataZ(seleRes)];
                
%                 atoms(index,1:sum(seleRes))=AtNaStr(seleRes);
%                 resseq{index}=resSeq(indices);
%                 resseqU{index}=resSeqU(indices)';
                
%                 resnum{index}=Res.ItemNames{index}(3:end);
%                 resSeqU{index}=FAM.UniqueResSeq(seleRes)';

            end
            
            %             % Find the name of each residue
            %             [~, I]=unique(resSeqU,'first');
            %             Names_Residues={FAM.Model(I).resName};
            
            % Find the name of each residue
%             [~, I]=unique(FAM.UniqueResSeq,'first');
            %             if length(FAM.Model(I(1)).resName)==1
            %                 Names_ResiduesU=cellstr(aminolookup([FAM.Model(I).resName])');
            %             else
            Res.ResidueName={FAM.Model(AtomRes).resName}';
            %             end
            
            % Find the chain of each residue
            %[~, I]=unique(FAM.ChainID,'first');
            Res.ResidueChain=FAM.ChainID(AtomRes);
            %chainID=FAM.UniqueResSeq(I);
            % Output block
%             Res.ListOfResidues=List_Residues;
%             Res.ListOfResiduesU=List_ResiduesU;
%             Res.NamesOfResidues=Names_ResiduesU;
%             Res.NamesOfResiduesU=Names_ResiduesU;
            Res.Atoms=atoms;
%             Res.ResSeq=resseq;
%             Res.UniqueResSeq=resseqU;
            Res.Position=r;
%             Res.ChainID=chainID;
            Res.ResidueNumber=strtrim(resnum);
            Res.UniqueResSeq=resSeqU;
            Res.tempFactor=tempFactors;
        end
        
        function FilterAtoms(Res,resnum,subset)
            Res.Position{resnum}=Res.Position{resnum}(subset,:);
            Res.UniqueResSeq{resnum}=Res.UniqueResSeq{resnum}(:,subset);
        end
        
        function CutRes(ResB,subset,res_orig)
            if nargin > 2
                ResA=res_orig;
            else
                ResA=ResB;
            end
            ResB.ItemNames=ResA.ItemNames(subset);
            ResB.ResidueNumber=ResA.ResidueNumber(subset);
            ResB.ResidueName=ResA.ResidueName(subset);
            ResB.ResidueChain=ResA.ResidueChain(subset);
            ResB.Atoms=ResA.Atoms(subset,:);
            ResB.Position=ResA.Position(subset);
            ResB.UniqueResSeq=ResA.UniqueResSeq(subset);
%             if nargin < 3
%                 
%                 %Res.ListOfResidues=Res.ListOfResidues(subset);
%                 ResB.NamesOfResiduesU=ResB.NamesOfResiduesU(subset);
%                 %Res.NamesOfResidues=Res.NamesOfResidues(subset);
%                 
%                 
%                 ResB.ResSeq=ResB.ResSeq(subset);
%                 ResB.UniqueResSeq=ResB.UniqueResSeq(subset);
%                 ResB.ChainID=ResB.ChainID(subset);
%             else
%                 ResB.ListOfResiduesU=res_orig.ListOfResiduesU(subset);
%                 ResB.NamesOfResiduesU=res_orig.NamesOfResiduesU(subset);
%                 try
%                     if length(res_orig.ListOfResiduesU(subset))==length(res_orig.ListOfResidues(subset))
%                         ResB.ListOfResidues=res_orig.ListOfResidues(subset);
%                         ResB.NamesOfResidues=res_orig.NamesOfResidues(subset);
%                     end
%                 catch
%                 end
%                 ResB.Atoms=res_orig.Atoms(subset,:);
%                 ResB.Position=res_orig.Position(subset);
%                 ResB.ResSeq=res_orig.ResSeq(subset);
%                 ResB.UniqueResSeq=res_orig.UniqueResSeq(subset);
%                 ResB.ChainID=res_orig.ChainID(subset);
                
%             end
        end
        function [Res,RealAtomsNames]=AtomFilter(Res,AtomFilterType)
            
            ProteinCodes=lower({'Ala','Arg','Asn','Asp','Cys','Gln','Glu','Gly','His','Ile',...
                'Leu','Lys','Met','Phe','Pro','Ser','Thr','Trp','Tyr','Val'});
            for resnum=1:length(Res.Position)
                Atoms=Res.Atoms(resnum,:);
                switch lower(AtomFilterType)
                    case 'phosphate'
                        sele_subset=isPhosphate(Atoms);
                    case 'sugar'
                        sele_subset=isSugar(Atoms);
                    case 'base'
                        sele_subset=isBase(Atoms);
                    case {'anything','any'}
                        sele_subset=isAnything(Atoms);
                    case 'rna'
                        sele_subset=isPhosphate(Atoms) | isSugar(Atoms) | isBase(Atoms);
                    case 'protein'
                        r=ismember(lower(Res.ResidueName(resnum)),ProteinCodes);
                        if r
                            sele_subset=isAnything(Atoms);
                        else
                            sele_subset=false(1,length(Atoms));
                        end
                    case 'na_backbone'
                        sele_subset=~isBase(Atoms);
                    case 'aa_backbone'
                        sele_subset=isAABackbone(Atoms);
                    case 'magnesium'
                        sele_subset=isMagnesium(Atoms);
                    case 'aa_sidechain'
                        sele_subset=~isAABackbone(Atoms);
                    case 'calcium'
                        sele_subset=isCalcium(Atoms);
                end
                Res.FilterAtoms(resnum,sele_subset);
                
                
            end
            BAtoms=Res.Atoms;
            I=isRealAtom(BAtoms(:),AtomFilterType);
            RealAtomsNames=BAtoms(I);
            
        end
        % Supports the addition of residues objects
        function addobj(Res,res1,res2)
            Res.ItemNames=[res1.ItemNames;res2.ItemNames];
            Res.ResidueNumber=[res1.ResidueNumber;res2.ResidueNumber];
            Res.ResidueName=[res1.ResidueName;res2.ResidueName];
            Res.ResidueChain=[res1.ResidueChain;res2.ResidueChain];
            Res.Atoms=[res1.Atoms; res2.Atoms];
            Res.Position=[res1.Position; res2.Position];
            Res.UniqueResSeq=[res1.UniqueResSeq; res2.UniqueResSeq];
            Res.tempFactor=[res1.tempFactor; res2.tempFactor];
        end
    end
end


function sele_subset=isRealAtom(Atoms,AtomFilterType)
%% New

switch lower(AtomFilterType)
    case 'phosphate'
        sele_subset=isPhosphate(Atoms);
    case 'sugar'
        sele_subset=isSugar(Atoms);
    case 'base'
        sele_subset=isBase(Atoms);
    case {'anything','any'}
        sele_subset=isAnything(Atoms);
    case 'rna'
        sele_subset=isPhosphate(Atoms) | isSugar(Atoms) | isBase(Atoms);
    case 'protein'   
        sele_subset=isAnything(Atoms);
    case 'na_backbone'
        sele_subset=~isBase(Atoms);
    case 'aa_backbone'
        sele_subset=isAABackbone(Atoms);
    case 'magnesium'
        sele_subset=isMagnesium(Atoms);
    case 'aa_sidechain'
        sele_subset=~isAABackbone(Atoms);
    case 'calcium'
        sele_subset=isCalcium(Atoms);
end

%% old
% realatoms=0;
% cs={Atoms.chemSymbol};
% I=false(1,length(Atoms));
% for i=1:length(Atoms)
%     if ~isempty(cs{i})
%         switch lower(AtomFilterType)
%             case 'phosphate'
%                 sele_subset=isPhosphate(Atoms(i));
%             case 'sugar'
%                 sele_subset=isSugar(Atoms(i));
%             case 'base'
%                 sele_subset=isBase(Atoms(i));
%             case {'anything','any'}
%                 sele_subset=isAnything(Atoms(i));
%             case 'na_backbone'
%                 sele_subset=~isBase(Atoms(i));
%             case 'aa_backbone'
%                 sele_subset=isAABackbone(Atoms(i));
%             case 'magnesium'
%                 sele_subset=isMagnesium(Atoms(i));
%             case 'aa_sidechain'
%                 sele_subset=~isAABackbone(Atoms(i));
%             case 'calcium'
%                 sele_subset=isCalcium(Atoms(i));
%         end
%         
%         I(i)=sele_subset;
%     end
% end

end

function I=isAnything(Atoms)
%% NEW
c=char({Atoms.chemSymbol});
I=~isspace(c(:,1));

% [~,ind]=ismember('',{Atoms.chemSymbol},'R2012A');
% if ind==0
%     I= true(1,length({Atoms.chemSymbol}));
% else
%     I= true(1,ind-1);
% end
%% OLD

% realatoms=0;
% cs={Atoms.chemSymbol};
% for i=1:length(Atoms)
%     if ~isempty(cs{i})
%         realatoms=realatoms+1;
%     end
% end
% I= true(1,length(Atoms(1:realatoms)));
end

function I=isBase(Atoms)
c=char({Atoms.chemSymbol});
realatoms=~isspace(c(:,1));

I=  ismember({Atoms(realatoms).chemSymbol},{'N','C','O'}) & ismember({Atoms(realatoms).remoteInd},...
    {'1','2','3','4','5','6','7','8','9'}) & strcmp({Atoms(realatoms).branch},'');
end

function I=isPhosphate(Atoms)
c=char({Atoms.chemSymbol});
realatoms=~isspace(c(:,1));

I=ismember({Atoms(realatoms).remoteInd},{'P'}) | ismember({Atoms(realatoms).branch},{'P'}) | ...
    (ismember({Atoms(realatoms).chemSymbol},{'P'}) & ismember({Atoms(realatoms).remoteInd},{''}));
end

function I=isSugar(Atoms)
c=char({Atoms.chemSymbol});
realatoms=~isspace(c(:,1));

I=ismember({Atoms(realatoms).branch},{''''}) | ismember({Atoms(realatoms).branch},{'*'});
end

function I=isAABackbone(Atoms)
c=char({Atoms.chemSymbol});
realatoms=~isspace(c(:,1));

I=  (ismember({Atoms(realatoms).chemSymbol},{'N'}) & ismember({Atoms(realatoms).remoteInd}, {''})) | ...
    (ismember({Atoms(realatoms).chemSymbol},{'C'}) & ismember({Atoms(realatoms).remoteInd},{'A'})) | ...
    (ismember({Atoms(realatoms).chemSymbol},{'C'}) & ismember({Atoms(realatoms).remoteInd}, {''})) | ...
    (ismember({Atoms(realatoms).chemSymbol},{'O'}) & ismember({Atoms(realatoms).remoteInd},{ ''}));
end

function I=isMagnesium(Atoms)
c=char({Atoms.chemSymbol});
realatoms=~isspace(c(:,1));

if realatoms <= length(Atoms)
    I=ismember({Atoms(realatoms).chemSymbol},{'MG','M'});
else
    I=ismember(Atoms.chemSymbol,{'MG','M'});
end
end

function I=isCalcium(Atoms)
c=char({Atoms.chemSymbol});
realatoms=~isspace(c(:,1));

I=ismember({Atoms(realatoms).chemSymbol},{'CA'});
end
