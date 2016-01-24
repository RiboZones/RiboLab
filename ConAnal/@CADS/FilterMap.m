function KeepFilter=FilterMap(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
VarCutoff=Inf;
numTiles=1;
ResidueTargetMode=false();
try 
    contact_cutoff=CADS_object(1).Settings.Structure.ContactCutoff;
catch
    contact_cutoff=3.4;
end
AtomFilterType='anything';
% InterActionFilter='any';

if nargin >1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'numBins'
                numBins=varargin{2*ind};
            case 'VarCutoff'
                VarCutoff=varargin{2*ind};
            case 'FilterRes'
                FilterRes=varargin{2*ind};
            case 'numTiles'
                numTiles=varargin{2*ind};
            case 'Subsets'
                Subsets=varargin{2*ind};
            case 'ContactCutoff'
                contact_cutoff=varargin{2*ind};
            case 'AtomFilterType'
                AtomFilterType=varargin{2*ind};
%             case 'InterActionFilter'
%                 InterActionFilter=varargin{2*ind};
            case 'ResidueTarget'
                ResidueTarget=varargin{2*ind};
                ResidueTargetMode=true;
        end
    end
end

if exist('numBins','var')
    [~, Bounds] = cSequenceColor(CADS_object,varargin{:});
    if numTiles<numBins
        VarCutoff=Bounds(numTiles);
    else
        warning('numTiles was too high, ignoring')
    end
end
%
% if exist('Subsets','var')
%     subsetsmode=true;
% else
%     subsetsmode=false;
% end
numDataSets=length(CADS_object);
ChosenSubsets=cell(numDataSets,1);
MapUC=cell(numDataSets,1);
KeepFilter=cell(numDataSets,1);
for Pro_ind=1:numDataSets
    if exist('Subsets','var') && ~isempty(Subsets) && ~isempty(Subsets{Pro_ind})
        subsetsmode=true;
        ChosenSubsets{Pro_ind}=Subsets{Pro_ind};
        numSubsets=length(ChosenSubsets{Pro_ind});
    elseif ~exist('Subsets','var') && ~isempty(CADS_object(Pro_ind).Subsets)
        subsetsmode=true;
        ChosenSubsets{Pro_ind}=CADS_object(Pro_ind).Subsets;
        numSubsets=length(ChosenSubsets{Pro_ind});
    else
        subsetsmode=false;
        numSubsets=1;
    end
%     names=CADS_object(Pro_ind).Species;
    %     CAOut(length(names))=ConAnalOutput();
    %     MapUC=cell(1,length(names));
    
    for model=1:length(CADS_object(Pro_ind).PDB)
        %         pdb1 = PDBentry([names{model},'Subject']);
        %         pdb2 = PDBentry([names{model},'Target']);
        %         pdb1.PDBfromStruct(CADS_object(Pro_ind).PDB(model),'newID1')
        %         pdb2.PDBfromStruct(Target(model),'newID2')
        if exist('FilterRes','var')
            KeepRes=logical(sum(vertcat(FilterRes{Pro_ind}{:}),1));
            VarCutoff=FilterRes{Pro_ind};
        else
            if isnumeric(CADS_object(Pro_ind).Results(model).Variability)...
                    && ~isempty(CADS_object(Pro_ind).Results(model).Variability)
                KeepRes=CADS_object(Pro_ind).Results(model).Variability<=VarCutoff;
            else
                KeepRes=true(length(CADS_object(Pro_ind).Keep(model).PDB),1);
            end
        end
        
        for subset=1:numSubsets
            if subsetsmode
                KeepRes2=false(size(KeepRes));
                KeepRes2(ChosenSubsets{Pro_ind}{subset})=true;
                KeepRes3=KeepRes&KeepRes2;
            else
                KeepRes3=KeepRes;
            end
            
            if sum(KeepRes3)
                if ResidueTargetMode
                    [MapUC{Pro_ind}{model}{subset}]=MapContacts(CADS_object(Pro_ind).PDB(model),...
                        ResidueTarget{model},[],contact_cutoff,...
                        CADS_object(Pro_ind).Keep(model).Alignment(KeepRes3),...
                        'AtomFilterType',AtomFilterType,varargin{:});
                else
                    [MapUC{Pro_ind}{model}{subset}]=MapContacts(CADS_object(Pro_ind).PDB(model),...
                        CADS_object(Pro_ind).Target(model),[],contact_cutoff,...
                        CADS_object(Pro_ind).Keep(model).Alignment(KeepRes3),...
                        'AtomFilterType',AtomFilterType,varargin{:});
                end
            else
                MapUC{Pro_ind}{model}{subset}=struct('contacts',{{}},'residues',{{}},'Y',{{}});
%                 KeepFilter{Pro_ind}{model}{subset}=[];
            end
            if ~isempty(MapUC{Pro_ind}{model}{subset}.Y)
                [~,Keep]=ismember([MapUC{Pro_ind}{model}{subset}.Y{:,1}],...
                CADS_object(Pro_ind).Keep(model).Alignment);
            else
                Keep=0;
            end
            
            KeepRes4=false(size(KeepRes));
            if sum(Keep)>0
                KeepRes4(Keep)=true;
            end
            KeepFilter{Pro_ind}{model}{subset}=KeepRes4;
            
        end
        CADS_object(Pro_ind).Results(model).AddContactMapFiltered([MapUC{Pro_ind}{model}{:}],{VarCutoff});
    end
end
end


