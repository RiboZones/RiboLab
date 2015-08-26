function [ Alignment_Table ] = AlignmentTable(aln_data,ItemNames,myMap,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% merge=true();
% 
% if nargin > 2
%     for ind=1:length(varargin)/2
%         switch varargin{2*ind-1}
%             case 'merge'
%                 merge=varargin{2*ind};
%         end
%     end
% end

numalns=length(aln_data);
Alignment_Table=cell(numalns,1);

for i=1:numalns
%     res_obj(i)=Residues(PDB_obj(i).Name);
%     res_obj(i).GroupResidues(PDB_obj(i));
%     pa_obj(i)=PseudoAtoms(PDB_obj(i).Name);
%     pa_obj(i).CenterOfMass(res_obj(i),'Whole')
    
    residue_list=ItemNames;
    thermal_list=aln_data{numalns};
    
    [inMap,I]=ismember(residue_list,myMap(i).ItemNames);
    [~,II]=sort(I(I~=0));            
    r=residue_list(inMap);
    t=thermal_list(inMap);
    [~,III]=ismember(r(II),myMap(i).ItemNames); 
    
    Alignment_Table{i}(:,1)=myMap(i).ItemNames';
    Alignment_Table{i}(III,2)=num2cell(t(II)');
    
end


% if merge
%     Alignment_Table=vertcat(Alignment_Table{:});
% end




end
