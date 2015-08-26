function [Helix_Table,GroupSelectedResidues,GroupHelices,ColorCol]=HelixDefinitions(HelicesDef,MyMap,varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

MapOverRide=false();
DisplayPlots=true();
AskFile=true();

if nargin > 1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'MapOverRide'
                MapOverRide=true();
                MyMap2=varargin{2*ind};
            case 'DisplayPlots'
                DisplayPlots=varargin{2*ind};
            case 'ColorFile'
                [PathName,FileName,Ext] = fileparts(varargin{2*ind});
                FileName=[FileName,Ext];
                AskFile=false();
                gui=false;
        end
    end
end

if AskFile
    [FileName,PathName] = uigetfile({'*.csv';'*.*'},...
        'Select the CSV File','MultiSelect', 'off');
    gui=true;
end
if isequal(FileName,0) || isequal(PathName,0)
    skip=true;
else
    skip=false;
end


if ~skip
    if gui
        h=PleaseWait();
    end
    %     newID=[PathName,FileName(1:end-4)];
    file=fullfile(PathName,FileName);
    %Sets=importdata(file);
    fid = fopen(file);
    Sets = textscan(fid, '%s');
    Sets = Sets{1};
    fclose(fid);
    
    
    if gui
        delete(h)
    end
end

numMaps=length(MyMap);
SelectedResidues=cell(numMaps,1);
GroupSelectedResidues=cell(numMaps,1);
GroupHelices=cell(numMaps,1);
ColorCol=cell(numMaps,1);
SeleHelices=cell(numMaps,1);

numColors=size(Sets,1);
ColorIndices=round(colon(1,63/(numColors-1),64));

for Map_ind=1:numMaps
    
    [SelectedResidues{Map_ind},SeleHelices{Map_ind}]=SelectByEdge(HelicesDef([HelicesDef.mol_ind]==Map_ind),MyMap(Map_ind).ItemNames);
    GroupSelectedResidues{Map_ind}=cell(size(Sets,1),1);
    
    for i=1:numColors
        [q,I]=ismember(regexp(Sets{i},'[^,"]*','match'),{HelicesDef([HelicesDef.mol_ind]==Map_ind).Name});
        GroupSelectedResidues{Map_ind}{i}=SelectedResidues{Map_ind}(I(q));
        GroupHelices{Map_ind}{i} = SeleHelices{Map_ind}(I(q));
        ColorCol{Map_ind}{i}=repmat(i,numel(vertcat(GroupSelectedResidues{Map_ind}{i}{:})),1);
        
        if DisplayPlots
            if MapOverRide
                MyMap2(Map_ind).PlotCoord('IncludeItems',vertcat(GroupSelectedResidues{Map_ind}{i}{:}),...
                    'filename',[MyMap2(Map_ind).Name,' Helices Group ',num2str(i),'.eps'],...
                    'ColorMapIndex',ColorIndices(i),varargin{:});
            else
                MyMap(Map_ind).PlotCoord('IncludeItems',vertcat(GroupSelectedResidues{Map_ind}{i}{:}),...
                    'filename',[MyMap(Map_ind).Name,' Helices Group ',num2str(i),'.eps'],...
                    'ColorMapIndex',ColorIndices(i),varargin{:});
            end
        end
    end
end
[ Helix_Table ] = HelicesTable(MyMap,GroupSelectedResidues,GroupHelices,ColorCol,varargin{:});

end