function [KeepRows,FilteredBP]=PlotBPbyType(BP,Map3D_2D,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% FilterMode='all';
Symmetric=false();

merge_mode=true();
% 
if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'Symmetric'
                Symmetric=varargin{2*ind};
%             case 'DistCutoff'
%                 DistCutoff=varargin{2*ind};
            case 'MergeMode'
                merge_mode=varargin{2*ind};
        end
    end
end

BPmerge.Chain={BP.Chain};
BPmerge.Data=[BP.Data];
BPmerge.Name={BP.Name};

if merge_mode
    BP=BPmerge;
end


BP_Types=unique(lower({BP.Data.BP_Type}));

KeepRows=cell(length(BP_Types),1);
FilteredBP=cell(length(BP_Types),1);

for i=1:length(BP_Types)
    newBP=BP;
    if Symmetric
        sele_type=ismember(lower({BP.Data.BP_Type}),{BP_Types{i},BP_Types{i}(end:-1:1)});
    else 
        sele_type=ismember(lower({BP.Data.BP_Type}),BP_Types{i});
    end
    
    %if ~ismember(BP_Types{i}(end:-1:1),BP_Types(1:i))
        newBP.Data=newBP.Data(sele_type);
        newBP.Name=[newBP.Name,'_',BP_Types{i}];
        [KeepRows{i},FilteredBP{i}]=PlotBP(newBP,Map3D_2D,varargin{:});
    %end
end

end

