function    pdb_compound = cif_compound( cif_obj,assembly )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    assembly=1;
end

entity_id=cif_obj.subsref(struct('type','.','subs','entity.id'));
label_entity_id=cif_obj.subsref(struct('type','.','subs','atom_site.label_entity_id'));

pdbx_description=cif_obj.subsref(struct('type','.','subs','entity.pdbx_description'));
chainID=cif_obj.subsref(struct('type','.','subs','atom_site.auth_asym_id'));
label_asym_id=cif_obj.subsref(struct('type','.','subs','atom_site.label_asym_id'));
%assembly_id=cif_obj.subsref(struct('type','.','subs','pdbx_struct_assembly_gen.assembly_id'));
asym_id_list=cif_obj.subsref(struct('type','.','subs','pdbx_struct_assembly_gen.asym_id_list'));

% Fragment, Synonym, Subunit, EC, engineered, mutation are not currently
% supported. These are not currently used in my programs.

numIDs=length(entity_id);
compound=cell(3*numIDs,1);

for i=1:numIDs
    
    try 
        I=ismember(label_entity_id,entity_id{i});
    catch
        I=1;
    end
    x=unique(label_asym_id(I));
    if isnumeric(assembly)
        if iscell(asym_id_list)
            selected=ismember(x,strsplit(asym_id_list{assembly},','));
        else
             selected=ismember(x,strsplit(asym_id_list,','));
        end
    else
        selected=true(1,length(x));
    end
    if sum(selected) % If not found in assembly, just skip this mol id.
        compound{3*(i-1)+1}=['MOL_ID: ',entity_id{i},';'];
        compound{3*(i-1)+2}=['MOLECULE: ',pdbx_description{i},';'];
        [~,II]=ismember(x(selected),label_asym_id);
        c=chainID(II);
        s=sprintf('%s, ',c{:});
        compound{3*(i-1)+3}=['CHAIN: ',s(1:end-2),';'];
    else
        compound{3*(i-1)+1}='';
        compound{3*(i-1)+2}='';
        compound{3*(i-1)+3}='';
        
    end
end
pdb_compound=char(compound);
end

