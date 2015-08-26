function [ Map ] = PDBentry2Map2D(PDBEntry, PDBEntry_Target,Map3D_2D,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

AtomFilterType='anything';
cutoff=3.5;

if nargin > 4
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'AtomFilterType'
                AtomFilterType=varargin{2*ind};
            case 'cutoff'
                cutoff=varargin{2*ind};
        end
    end
end

numMaps=length(PDBEntry);
Map=cell(numMaps,1);

ColorIndices=round(colon(1,63/(numMaps-1),64));
for i=1:numMaps
    
    Map{i}=MapContacts(PDBEntry(i),PDBEntry_Target,'42',cutoff,[],...
        'AtomFilterType',AtomFilterType,'IncludeResTarget',Map3D_2D.ItemNames);
    d=char(unique(vertcat(Map{i}.contacts{:})));   
    Contact_res=strtrim(cellstr(d(:,3:end)));
    s=[strrep(PDBEntry(i).Name,' ','_'),'.eps'];

    if ~strcmpi(AtomFilterType,'anything')
        s=[s(1:end-4),'_',AtomFilterType,'.eps'];
    end
    file_name=strrep(s,':','');
    Map3D_2D.PlotCoord('IncludeItems',Contact_res,'filename',file_name,...
        'ColorMapIndex',ColorIndices(i),varargin{:}) 
    
end

