function [ Domain_Table ] = DomainsTable(myMap,GroupSelectedResidues,GroupDomains,GroupDomains_AN,ColorCol,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

merge=true();

if nargin > 5
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'merge'
                merge=varargin{2*ind};
        end
    end
end

numMaps=length(myMap);
Domain_Table=cell(numMaps,1);

for i=1:numMaps
    gsr=vertcat(GroupSelectedResidues{i}{:});
    residue_list=vertcat(gsr{:});
    gh = vertcat(GroupDomains{i}{:});
    domains_list = vertcat(gh{:});
    color_list = vertcat(ColorCol{i}{:});
    ghn = vertcat(GroupDomains_AN{i}{:});
    number_list = vertcat(ghn{:});
    [~,I]=ismember(residue_list,myMap(i).ItemNames);
    [~,II]=sort(I);
    
    Domain_Table{i}(:,1)=residue_list(II)';
    Domain_Table{i}(:,2)=domains_list(II)';
    Domain_Table{i}(:,3)=number_list(II)';
    Domain_Table{i}(:,4)=num2cell(color_list(II)');
    
end


if merge
    Domain_Table=vertcat(Domain_Table{:});
end




end

