function [ Filtered_Alignments_Sp, Residue_Numbers ] = AlignmentFilter(CADS_object,Subsets,varargin)

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Var_cutoff=1;
SortAlignments=false;

if nargin >2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'Var_cutoff'
                Var_cutoff=varargin{2*ind};
            case 'Sort'
                SortAlignments=varargin{2*ind};
        end
    end
end

numDataSets=length(CADS_object);

if mod(length(Subsets),numDataSets)
    error('Number of Subsets must be a multiple of Number of DataSets')
else
    numSubsets=length(Subsets)/numDataSets;
end

Whole_Alignments=cell(1,numDataSets);
Filtered_Alignments=cell(numDataSets,numSubsets);
Filtered_Alignments_Sp=cell(numDataSets,numSubsets);
Residue_Numbers=cell(numDataSets,numSubsets);

for i=1:numDataSets
    Whole_Alignments{i}=cell2mat({CADS_object(i).Alignment(:).Sequence}');
    for j=1:numSubsets
        inSubset=false(1,length(Whole_Alignments{i}));
        inSubset(Subsets{2*(i-1)+j})=true;
        Filtered_Alignments{i,j}=Whole_Alignments{i}(:,inSubset & ...
            CADS_object(i).Results(1).Variability < Var_cutoff);
        Residue_Numbers{i,j}={CADS_object(i).Keep(1).Alignment(inSubset & ...
                CADS_object(i).Results(1).Variability < Var_cutoff),...
        CADS_object(i).Keep(2).Alignment(inSubset & ...
                CADS_object(i).Results(2).Variability < Var_cutoff)};
        if SortAlignments
            [~,I]=sort(CADS_object(i).Results(1).Variability(inSubset & ...
                CADS_object(i).Results(1).Variability < Var_cutoff));
            Filtered_Alignments{i,j}=Filtered_Alignments{i,j}(:,I);
            Residue_Numbers{i,j}{1}=Residue_Numbers{i,j}{1}(:,I);            
            Residue_Numbers{i,j}{2}=Residue_Numbers{i,j}{2}(:,I);
        end
        for k=1:length(CADS_object(i).Alignment);
            Filtered_Alignments_Sp{i,j}(k).Header=CADS_object(i).Alignment(k).Header;
            Filtered_Alignments_Sp{i,j}(k).Sequence=Filtered_Alignments{i,j}(k,:);

        end
        
        
        multialignviewer(Filtered_Alignments_Sp{i,j})
    end
end

