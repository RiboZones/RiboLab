function [Domain_Table,GroupSelectedResidues,GroupDomains,ColorCol]=DomainDefinitions(DomainsDef,MyMap,varargin)
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
    Sets=importdata(file);
    
    
    if gui
        delete(h)
    end
end

numMaps=length(MyMap);
SelectedResidues=cell(numMaps,1);
GroupSelectedResidues=cell(numMaps,1);
GroupDomains=cell(numMaps,1);
GroupDomains_AN=cell(numMaps,1);
ColorCol=cell(numMaps,1);
SeleDomains=cell(numMaps,1);
SeleDomains_AN=cell(numMaps,1);

numColors=size(Sets,1);
ColorIndices=round(colon(1,63/(numColors-1),64));

for Map_ind=1:numMaps
    
    [SelectedResidues{Map_ind},SeleDomains{Map_ind},SeleDomains_AN{Map_ind}]=SelectByEdge(DomainsDef([DomainsDef.mol_ind]==Map_ind),MyMap(Map_ind).ItemNames);
    GroupSelectedResidues{Map_ind}=cell(size(Sets,1),1);
    
    for i=1:numColors
        [q,I]=ismember(regexp(Sets{i},'[^,"]*','match'),{DomainsDef([DomainsDef.mol_ind]==Map_ind).Name});
        GroupSelectedResidues{Map_ind}{i}=SelectedResidues{Map_ind}(I(q));
        GroupDomains{Map_ind}{i} = SeleDomains{Map_ind}(I(q));
        GroupDomains_AN{Map_ind}{i} = SeleDomains_AN{Map_ind}(I(q));
        ColorCol{Map_ind}{i}=repmat(i,numel(vertcat(GroupSelectedResidues{Map_ind}{i}{:})),1) - 1;% We subtract one because Domains are currently 0 indexed, but MATLAB is 1 indexed.
        
        if DisplayPlots
            if MapOverRide
                MyMap2(Map_ind).PlotCoord('IncludeItems',vertcat(GroupSelectedResidues{Map_ind}{i}{:}),...
                    'filename',[MyMap2(Map_ind).Name,' Domains Group ',num2str(i),'.eps'],...
                    'ColorMapIndex',ColorIndices(i),varargin{:});
            else
                MyMap(Map_ind).PlotCoord('IncludeItems',vertcat(GroupSelectedResidues{Map_ind}{i}{:}),...
                    'filename',[MyMap(Map_ind).Name,' Domains Group ',num2str(i),'.eps'],...
                    'ColorMapIndex',ColorIndices(i),varargin{:});
            end
        end
    end
end
[ Domain_Table ] = DomainsTable(MyMap,GroupSelectedResidues,GroupDomains,GroupDomains_AN,ColorCol,varargin{:});

end