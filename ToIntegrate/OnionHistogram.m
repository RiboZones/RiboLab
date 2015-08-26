function [ OutputArray ] = OnionHistogram( onion_obj,RiboLabMap, Variable_Interest, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
OperationMode='mean';
numLayers=length(onion_obj.Model.Layers);

OutputArray=cell(1,numLayers);

if nargin > 3
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'OperationMode'
                OperationMode=varargin{2*ind};
        end
    end
end


for i=1:numLayers
    LayerResidues=onion_obj.Model.Layers{i};
    %     numLayerResidues=length(LayerResidues.ItemNames);
    ResNames=regexprep(LayerResidues.ItemNames,'[ ]','');
    [~,I]=ismember(ResNames,RiboLabMap.ItemNames);
    VarInt=Variable_Interest(I(I>0),:);
    switch OperationMode
        case 'sum'
            OutputArray{i}=sum(cell2mat(VarInt),1);
        case 'mean'
            OutputArray{i}=mean(cell2mat(VarInt),1);
        otherwise
            error('Case not recognized');
    end
end

OutputArray = removeEmptyRows(OutputArray');

end

function OutputArray = removeEmptyRows(InputArray)
numLayers=length(InputArray);
removeRow=false(1,numLayers);
for i=1:numLayers
    removeRow(i)=isempty(InputArray{i});
end
OutputArray=InputArray(~removeRow);
end