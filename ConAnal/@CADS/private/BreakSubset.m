function [V,Gc,GLabels] = BreakSubset(CADS_object,VarInterest,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

FullLength=CADS_object(1).Settings.Subsets.Combined;

numDataSets=length(VarInterest);

V=cell(numDataSets,1);
Gc=cell(numDataSets,1);
GLabels=cell(numDataSets,1);

sample_num=0;
for i=1:numDataSets
    if FullLength
        sample_num=sample_num+1;
        if iscell(VarInterest{i})
            V{i}{1,1}=VarInterest{i}{1};
        else
            V{i}{1,1}=VarInterest{i};
        end
        Gc{i}{1,1}=sample_num*ones(length(V{i}{1}),1);
        GLabels{i}{1,1}=cellstr(repmat([CADS_object(i).Name,' ','Full'],length(V{i}{1}),1));
        offset=1;
    else
        offset=0;
    end
    for j=1:length(CADS_object(i).Subsets)
        sample_num=sample_num+1;
        if iscell(VarInterest{i})
            V{i}{j+offset,1}=VarInterest{i}{j+offset};
        else
            V{i}{j+offset,1}=VarInterest{i}(CADS_object(i).Subsets{j});
        end
        Gc{i}{j+offset,1}=sample_num*ones(length(V{i}{j+offset}),1);
        
        try
             subset_name=CADS_object(i).Settings.Subsets.SubsetNames{j};
        catch
            CADS_object(i).Settings.Subsets.SubsetNames{j}=sprintf('Subset %d',j);
            subset_name=CADS_object(i).Settings.Subsets.SubsetNames{j};
        end
        
        GLabels{i}{j+offset,1}=cellstr(repmat([CADS_object(i).Name,' ',subset_name],length(V{i}{j+offset}),1));    
    end
    
    CADS_object(i).Settings.Subsets.VariableValues=VarInterest{i};
    
end  

end
