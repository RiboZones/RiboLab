function [ ResultsSets ] = CoVarBatch( RV_Lab_Structs, DomainPartition , varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Set_Names={'B','A','E'};
Mol_Name='LSU_3D';


if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'Mol_Name'
                Mol_Name=varargin{2*ind};
            case 'Set_Names'
                Set_Names=varargin{2*ind};
        end
    end
end

ResultsSets=struct('CoVarEntropy_Table',{},'FileName',{},'DataType',{});

%% Calculate conserved single direction basepairs


% Calculate for whole alignment, for each species. In this case, each
% species should pretty much come out the same.

for i=1:length(Set_Names)
    A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
        'DyadEntropy','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
        true,'FreqFilterMode',true);
    
    newSet=struct('CoVarEntropy_Table',{{}},'FileName',{''},'DataType',{''});
    newSet.CoVarEntropy_Table=A.CoVarEntropy_Table;
    newSet.FileName=[A.RiboLabMap.Name,'_SinglePair_CoVarEntropy','.csv'];
    newSet.DataType = 'SinglePair_U';
    newSet.CoVarEntropy_Table(:,4)=repmat({newSet.DataType},size(newSet.CoVarEntropy_Table,1),1);
    ResultsSets = [ResultsSets, newSet];
    %A.CoVarEntropy_Table(:,3)=repmat({'DarkBlue'},size(A.CoVarEntropy_Table,1),1);
end


% Calculate for individual domains, for each species.

for i=1:length(Set_Names)
    A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
        'DyadEntropy','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
        true,'FreqFilterMode',true,'AlignmentFilter',DomainPartition.(Set_Names{i}));
    
    newSet=struct('CoVarEntropy_Table',{{}},'FileName',{''},'DataType',{''});
    newSet.CoVarEntropy_Table=A.CoVarEntropy_Table;
    newSet.FileName=[A.RiboLabMap.Name,'_SinglePair_CoVarEntropy_',Set_Names{i},'.csv'];
    newSet.DataType = ['SinglePair_',Set_Names{i}];
    newSet.CoVarEntropy_Table(:,4)=repmat({newSet.DataType},size(newSet.CoVarEntropy_Table,1),1);
    
    ResultsSets = [ResultsSets, newSet];
end

% Calculate cross domains, for each combination.

for i=1:length(Set_Names)
    Set_Names_Diff=setdiff(Set_Names,Set_Names{i});
    for j=1:length(Set_Names_Diff)
        A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
            'DyadEntropy','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
            true,'FreqFilterMode',true,'AlignmentFilter',DomainPartition.(Set_Names_Diff{j}));
        
        newSet=struct('CoVarEntropy_Table',{{}},'FileName',{''},'DataType',{''});
        newSet.CoVarEntropy_Table=A.CoVarEntropy_Table;
        newSet.FileName=[A.RiboLabMap.Name,'_SinglePair_CoVarEntropy_',Set_Names_Diff{j},'.csv'];
        newSet.DataType = ['SinglePair_',Set_Names_Diff{j}];
        newSet.CoVarEntropy_Table(:,4)=repmat({newSet.DataType},size(newSet.CoVarEntropy_Table,1),1);
        
        ResultsSets = [ResultsSets, newSet];
    end
end




%% Calculate conserved both direction basepairs
% Calculate for whole alignment, for each species.

for i=1:length(Set_Names)
    A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
        'DyadEntropy','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
        true,'FreqFilterMode',true,'CombineSymmetry',true);
    
    newSet=struct('CoVarEntropy_Table',{{}},'FileName',{''},'DataType',{''});
    newSet.CoVarEntropy_Table=A.CoVarEntropy_Table;
    newSet.FileName=[A.RiboLabMap.Name,'_SymmetryPair_CoVarEntropy','.csv'];
    newSet.DataType = 'SymmetryPair_U';
    newSet.CoVarEntropy_Table(:,4)=repmat({newSet.DataType},size(newSet.CoVarEntropy_Table,1),1);
    ResultsSets = [ResultsSets, newSet];
end


% Calculate for individual domains, for each species.

for i=1:length(Set_Names)
    A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
        'DyadEntropy','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
        true,'FreqFilterMode',true,'AlignmentFilter',DomainPartition.(Set_Names{i}),'CombineSymmetry',true);
    
    newSet=struct('CoVarEntropy_Table',{{}},'FileName',{''},'DataType',{''});
    newSet.CoVarEntropy_Table=A.CoVarEntropy_Table;
    newSet.FileName=[A.RiboLabMap.Name,'_SymmetryPair_CoVarEntropy_',(Set_Names{i}),'.csv'];
    newSet.DataType = ['SymmetryPair_',Set_Names{i}];
    newSet.CoVarEntropy_Table(:,4)=repmat({newSet.DataType},size(newSet.CoVarEntropy_Table,1),1);
    ResultsSets = [ResultsSets, newSet];
end

% Calculate cross domains, for each combination.

for i=1:length(Set_Names)
    Set_Names_Diff=setdiff(Set_Names,Set_Names{i});
    for j=1:length(Set_Names_Diff)
        A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
            'DyadEntropy','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
            true,'FreqFilterMode',true,'AlignmentFilter',DomainPartition.(Set_Names_Diff{j}),...
            'CombineSymmetry',true);
        
        newSet=struct('CoVarEntropy_Table',{{}},'FileName',{''},'DataType',{''});
        newSet.CoVarEntropy_Table=A.CoVarEntropy_Table;
        newSet.FileName=[A.RiboLabMap.Name,'_SymmetryPair_CoVarEntropy_',Set_Names_Diff{j},'.csv'];
        newSet.DataType = ['SymmetryPair_',Set_Names_Diff{j}];
        newSet.CoVarEntropy_Table(:,4)=repmat({newSet.DataType},size(newSet.CoVarEntropy_Table,1),1);
        ResultsSets = [ResultsSets, newSet];
    end
end



%% Calculate conserved strong basepairs
% Calculate for whole alignment, for each species.

for i=1:length(Set_Names)
    A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
        'ByTypes','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
        true,'FreqFilterMode',false,'CombineSymmetry',true,'BasePairClasses',...
        {{'CG','GC','AU','UA','GU','UG','GA','AG','UU','AC','CA','CU','UC'}});
    
    newSet=struct('CoVarEntropy_Table',{{}},'FileName',{''},'DataType',{''});
    newSet.CoVarEntropy_Table=A.CoVarEntropy_Table;
    newSet.FileName=[A.RiboLabMap.Name,'_StrongBasePair_CoVarEntropy','.csv'];
    newSet.DataType = 'StrongBasePair_U';
    newSet.CoVarEntropy_Table(:,4)=repmat({newSet.DataType},size(newSet.CoVarEntropy_Table,1),1);
    ResultsSets = [ResultsSets, newSet];
end


% Calculate for individual domains, for each species.

for i=1:length(Set_Names)
    A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
        'ByTypes','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
        true,'FreqFilterMode',false,'AlignmentFilter',DomainPartition.(Set_Names{i}),...
        'CombineSymmetry',true','BasePairClasses',{{'CG','GC','AU','UA','GU','UG','GA','AG','UU','AC','CA','UC','CU'}});
    
    newSet=struct('CoVarEntropy_Table',{{}},'FileName',{''},'DataType',{''});
    newSet.CoVarEntropy_Table=A.CoVarEntropy_Table;
    newSet.FileName=[A.RiboLabMap.Name,'_StrongBasePair_CoVarEntropy_',(Set_Names{i}),'.csv'];
    newSet.DataType = ['StrongBasePair_',Set_Names{i}];
    newSet.CoVarEntropy_Table(:,4)=repmat({newSet.DataType},size(newSet.CoVarEntropy_Table,1),1);
    ResultsSets = [ResultsSets, newSet];
end

% Calculate cross domains, for each combination.

for i=1:length(Set_Names)
    Set_Names_Diff=setdiff(Set_Names,Set_Names{i});
    for j=1:length(Set_Names_Diff)
        A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
            'ByTypes','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
            true,'FreqFilterMode',false,'AlignmentFilter',DomainPartition.(Set_Names_Diff{j}),...
            'CombineSymmetry',true','BasePairClasses',{{'CG','GC','AU','UA','GU','UG','GA','AG','UU','AC','CA','UC','CU'}});
        
        newSet=struct('CoVarEntropy_Table',{{}},'FileName',{''},'DataType',{''});
        newSet.CoVarEntropy_Table=A.CoVarEntropy_Table;
        newSet.FileName=[A.RiboLabMap.Name,'_StrongBasePair_CoVarEntropy_',Set_Names_Diff{j},'.csv'];
        newSet.DataType = ['StrongBasePair_',Set_Names_Diff{j}];
        newSet.CoVarEntropy_Table(:,4)=repmat({newSet.DataType},size(newSet.CoVarEntropy_Table,1),1);
        ResultsSets = [ResultsSets, newSet];
    end
end

%
% %% Calculate conserved any two bases
% % Calculate for whole alignment, for each species.
%
% for i=1:length(Set_Names)
%     A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
%         'ByTypes','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
%         true,'FreqFilterMode',false,'CombineSymmetry',true,'BasePairClasses',...
%         {{'AA','AC','AG','AU','CA','CC','CG','CU','GA','GC','GG','GU','UA','UC','UG','UU'}});
%
%     A.CoVarEntropy_Table(:,3)=repmat({'Carrot Orange'},size(A.CoVarEntropy_Table,1),1);
%
%
%     fid=fopen([A.RiboLabMap.Name,'_AnyBasePair_CoVarEntropy','.csv'],'wt');
%     fprintf(fid, '%s,%s,%s\n','resNum','DataCol','ColorCol');
%     for j=1:size(A.CoVarEntropy_Table,1);
%         fprintf(fid, '%s,%s,%s\n',A.CoVarEntropy_Table{j,1},num2str(A.CoVarEntropy_Table{j,2}),...
%             A.CoVarEntropy_Table{j,3});
%     end
%     fclose(fid);
% end
%
%
% % Calculate for individual domains, for each species.
%
% for i=1:length(Set_Names)
%     A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
%         'ByTypes','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
%         true,'FreqFilterMode',false,'AlignmentFilter',DomainPartition.(Set_Names{i}),...
%         'CombineSymmetry',true','BasePairClasses',{{'AA','AC','AG','AU','CA','CC','CG','CU','GA','GC','GG','GU','UA','UC','UG','UU'}});
%
%     A.CoVarEntropy_Table(:,3)=repmat({'Casablanca'},size(A.CoVarEntropy_Table,1),1);
%
%
%     fid=fopen([A.RiboLabMap.Name,'_AnyBasePair_CoVarEntropy_',(Set_Names{i}),'.csv'],'wt');
%     fprintf(fid, '%s,%s,%s\n','resNum','DataCol','ColorCol');
%     for j=1:size(A.CoVarEntropy_Table,1);
%         fprintf(fid, '%s,%s,%s\n',A.CoVarEntropy_Table{j,1},num2str(A.CoVarEntropy_Table{j,2}),...
%             A.CoVarEntropy_Table{j,3});
%     end
%     fclose(fid);
% end
%
% %% Calculate high gap sites
% % Calculate for whole alignment, for each species.
%
% for i=1:length(Set_Names)
%     A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
%         'ByTypes','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
%         true,'FreqFilterMode',false,'CombineSymmetry',true,'BasePairClasses',...
%         {{'A-','-A','G-','-G','C-','-C','U-','-U'}});
%
%     A.CoVarEntropy_Table(:,3)=repmat({'Thunderbird'},size(A.CoVarEntropy_Table,1),1);
%
%
%     fid=fopen([A.RiboLabMap.Name,'_GapBase_CoVarEntropy','.csv'],'wt');
%     fprintf(fid, '%s,%s,%s\n','resNum','DataCol','ColorCol');
%     for j=1:size(A.CoVarEntropy_Table,1);
%         fprintf(fid, '%s,%s,%s\n',A.CoVarEntropy_Table{j,1},num2str(A.CoVarEntropy_Table{j,2}),...
%             A.CoVarEntropy_Table{j,3});
%     end
%     fclose(fid);
% end
%
%
% % Calculate for individual domains, for each species.
%
% for i=1:length(Set_Names)
%     A=CoVarEntropyStruct(RV_Lab_Structs.(Set_Names{i}).(Mol_Name),'CoVarMode',...
%         'ByTypes','MergeSingles',false,'WriteToFile',false,'RemoveUnProcessed',...
%         true,'FreqFilterMode',false,'AlignmentFilter',DomainPartition.(Set_Names{i}),...
%         'CombineSymmetry',true','BasePairClasses',{{'A-','-A','G-','-G','C-','-C','U-','-U'}});
%
%     A.CoVarEntropy_Table(:,3)=repmat({'Geraldine'},size(A.CoVarEntropy_Table,1),1);
%
%
%     fid=fopen([A.RiboLabMap.Name,'_GapBase_CoVarEntropy_',(Set_Names{i}),'.csv'],'wt');
%     fprintf(fid, '%s,%s,%s\n','resNum','DataCol','ColorCol');
%     for j=1:size(A.CoVarEntropy_Table,1);
%         fprintf(fid, '%s,%s,%s\n',A.CoVarEntropy_Table{j,1},num2str(A.CoVarEntropy_Table{j,2}),...
%             A.CoVarEntropy_Table{j,3});
%     end
%     fclose(fid);
% end


numResults=length(ResultsSets);
colorGrad=computeHexGrad(numResults);

for i=1:numResults
    ResultsSets(i).CoVarEntropy_Table(:,5)=repmat(colorGrad(i),size(ResultsSets(i).CoVarEntropy_Table,1),1);
    fid=fopen(ResultsSets(i).FileName,'wt');
    fprintf(fid, '%s,%s,%s,%s,%s\n','resNum','DataCol','ModeBasePair','DataType','ColorCol');
    for j=1:size( ResultsSets(i).CoVarEntropy_Table,1);
        fprintf(fid, '%s,%s,%s,%s,%s\n', ResultsSets(i).CoVarEntropy_Table{j,1},...
            num2str( ResultsSets(i).CoVarEntropy_Table{j,2}),...
            ResultsSets(i).CoVarEntropy_Table{j,3}{1},ResultsSets(i).CoVarEntropy_Table{j,4},...
            ResultsSets(i).CoVarEntropy_Table{j,5});
    end
    fclose(fid);
end

ResultsSets=ResultsSets';
end


