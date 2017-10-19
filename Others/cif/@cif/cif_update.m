function [ cif_obj ] = cif_update( cif_obj, pymol_cif_obj, new_name )
%CIF_UPDATE Takes a barebones cif file from PyMOL, and updates 
% x, y, z, coordinates in cif_obj. 

%new_cif = cif(pymol_cif_file);

for ii = 1:numel(cif_obj.cifdat)
    switch cif_obj.cifdat(ii).name
        case 'atom_site.Cartn_x'
            cif_obj.cifdat(ii).val = subsref2(pymol_cif_obj,'atom_site.Cartn_x');
        case 'atom_site.Cartn_y'
           cif_obj.cifdat(ii).val = subsref2(pymol_cif_obj,'atom_site.Cartn_y');
        case 'atom_site.Cartn_z'
           cif_obj.cifdat(ii).val = subsref2(pymol_cif_obj,'atom_site.Cartn_z');
        otherwise
            
    end
end

cif_obj.cifdat(1).val=new_name;

end
function B=subsref2(obj,str)
for ii = 1:numel(obj.cifdat)
    if strcmp(str, obj.cifdat(ii).name)
        B = obj.cifdat(ii).val;
        break;
    end
end
end