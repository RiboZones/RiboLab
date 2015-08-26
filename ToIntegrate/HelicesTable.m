function [ Helix_Table ] = HelicesTable(myMap,GroupSelectedResidues,GroupHelices,ColorCol,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

merge=true();

if nargin > 4
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'merge'
                merge=varargin{2*ind};
        end
    end
end

numMaps=length(myMap);
Helix_Table=cell(numMaps,1);

for i=1:numMaps
    gsr=vertcat(GroupSelectedResidues{i}{:});
    residue_list=vertcat(gsr{:});
    gh = vertcat(GroupHelices{i}{:});
    helices_list = vertcat(gh{:});
    color_list = vertcat(ColorCol{i}{:});
    
    [~,I]=ismember(residue_list,myMap(i).ItemNames);
    [~,II]=sort(I);
    
    Helix_Table{i}(:,1)=residue_list(II)';
    Helix_Table{i}(:,2)=helices_list(II)';
    Helix_Table{i}(:,3)=num2cell(color_list(II)');
    
end


if merge
    Helix_Table=vertcat(Helix_Table{:});
end




end

