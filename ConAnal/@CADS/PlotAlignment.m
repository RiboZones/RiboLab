function [Alignment,Residue_Numbers]=PlotAlignment(CADS_object,varargin)

%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
FilterAlignments=false();
SortAlignments=false;
SubsetMode=false();
NameSubsets={'Glb','RPE'};
Species=0;
freq_filter=false;

ShowPlots=true;

if nargin >2
    for ind=1:length(varargin)/2
        switch lower(varargin{2*ind-1})
            case 'sort'
                SortAlignments=varargin{2*ind};
            case 'filter'
                FilterAlignments=varargin{2*ind};
            case 'cutoff'
                Var_cutoff=varargin{2*ind};
            case 'subsets'
                SubsetMode=varargin{2*ind};
            case 'species'
                Species=varargin{2*ind};
            case 'freqfilter'
                freq_filter=true;
            case 'namesubsets'
                NameSubsets=varargin{2*ind};
            case 'showplots'
                ShowPlots=varargin{2*ind};
            case 'usersubsets'
                UserSubSets=varargin{2*ind};
        end
    end
end

if ~exist('Var_cutoff','var')
    if FilterAlignments
        Var_cutoff=1;
    end
else
    if ~FilterAlignments
        FilterAlignments=true();
    end
end

if exist('Var_cutoff','var')
    FilterAlignments=true();
end

numDataSets=length(CADS_object);
Alignment=cell(numDataSets,1);
Residue_Numbers=cell(numDataSets,1);

for i=1:numDataSets
    
    numSpecies=length(CADS_object(i).Alignment);
    numResidues=length(CADS_object(i).Alignment(1).Sequence);
    
    if isempty(CADS_object(i).Subsets)
        CADS_object(i).Subsets={1:numResidues};
    end
    
    %% Filter by Subsets
    if SubsetMode
        numSubsets=length(CADS_object(i).Subsets);
        Subsets=CADS_object(i).Subsets;
    else
        numSubsets=1;
        Subsets={1:numResidues};
    end
    if exist('UserSubSets','var')
        numSubsets=length(UserSubSets);
        Subsets=UserSubSets;
    end
    inSubset=cell(numSubsets,1);
    for j=1:numSubsets
        inSubset{j}=false(1,numResidues);
        inSubset{j}(Subsets{j})=true;
    end
    
    %% Filter by Species
    if Species > 0
        inAlignment=~ismember(cellstr(CADS_object(i).Alignment(Species).Sequence'),{'-','.',' '})';
    else
        inAlignment=true(1,numResidues);
    end
    
    %% Filter by entropy
    if FilterAlignments
        belowVar=CADS_object(i).Results(1).Variability < Var_cutoff;
    else
        belowVar=true(1,numResidues);
    end
    
    %% Filter by frequency
    if freq_filter
        [~,~,aboveFreq_c] = FilterVarPlot(CADS_object(i),varargin{:});
        aboveFreq=aboveFreq_c{1};
    else
        aboveFreq=true(1,numResidues);
    end
    
    %% Copy filtered sequences to Alignment, and record Residue Numbers, sorting as needed
    for j=1:numSubsets
        KeepRes=inSubset{j} & inAlignment & belowVar & aboveFreq;
%         Residue_Numbers{i}{j}={CADS_object(i).Keep(1).Alignment(KeepRes),...
%             CADS_object(i).Keep(2).Alignment(KeepRes)};
        if SortAlignments
            [~,I]=sort(CADS_object(i).Results(1).Variability(KeepRes));
%             Residue_Numbers{i}{j}{1}=Residue_Numbers{i}{j}{1}(:,I);
%             Residue_Numbers{i}{j}{2}=Residue_Numbers{i}{j}{2}(:,I);
        else
            I=1:sum(KeepRes);
        end
        for k=1:numSpecies
            Alignment{i}(j,k).Header=CADS_object(i).Alignment(k).Header;
            Alignment{i}(j,k).Sequence=CADS_object(i).Alignment(k).Sequence(KeepRes);
            Alignment{i}(j,k).Sequence=Alignment{i}(j,k).Sequence(I);
        end
        if ShowPlots
            seqalignviewer(Alignment{i}(j,:),'varname',...
                sprintf('%s : %s',CADS_object(i).Name,NameSubsets{j}));
        end
    end
end

end
