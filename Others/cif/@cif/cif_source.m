function    pdb_source = cif_source( cif_obj )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


entity_id=cif_obj.subsref(struct('type','.','subs','entity_src_nat.entity_id'));
pdbx_organism_scientific=cif_obj.subsref(struct('type','.','subs','entity_src_nat.pdbx_organism_scientific'));
pdbx_ncbi_taxonomy_id=cif_obj.subsref(struct('type','.','subs','entity_src_nat.pdbx_ncbi_taxonomy_id'));
strain=cif_obj.subsref(struct('type','.','subs','entity_src_nat.strain'));

numIDs=length(entity_id);
source_struct=cell(4*numIDs,1);
line_num=0;

for i=1:numIDs
    source_struct{4*(i-1)+1}=['MOL_ID: ',entity_id{i},';'];
    source_struct{4*(i-1)+2}=['ORGANISM_SCIENTIFIC: ',pdbx_organism_scientific{i},';'];
    source_struct{4*(i-1)+3}=['ORGANISM_TAXID: ',pdbx_ncbi_taxonomy_id{i},';'];
    source_struct{4*(i-1)+4}=['STRAIN: ',strain{i},';'];  
end
pdb_source=char(source_struct);
end

