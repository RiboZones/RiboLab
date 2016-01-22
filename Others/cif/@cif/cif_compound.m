function    pdb_compound = cif_compound( cif_obj )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

entity_id=cif_obj.subsref(struct('type','.','subs','entity.id'));
label_entity_id=cif_obj.subsref(struct('type','.','subs','atom_site.label_entity_id'));

pdbx_description=cif_obj.subsref(struct('type','.','subs','entity.pdbx_description'));
chainID=cif_obj.subsref(struct('type','.','subs','atom_site.auth_asym_id'));
label_asym_id=cif_obj.subsref(struct('type','.','subs','atom_site.label_asym_id'));


% Fragment, Synonym, Subunit, EC, engineered, mutation are not currently
% supported. These are not currently used in my programs. 

numIDs=length(entity_id);
compound=cell(3*numIDs,1);

for i=1:numIDs
    compound{3*(i-1)+1}=['MOL_ID: ',entity_id{i},';'];
    compound{3*(i-1)+2}=['MOLECULE: ',pdbx_description{i},';'];
    
    I=ismember(label_entity_id,entity_id{i});
    x=unique(chainID(I));
    s=sprintf('%s, ',x{:});

    compound{3*(i-1)+3}=['CHAIN: ',s(1:end-2),';'];
end
pdb_compound=char(compound);
end

