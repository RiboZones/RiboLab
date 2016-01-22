function [ pdb_model_struct ] = cif_model( cif_obj )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
atom_struct = struct('AtomSerNo',[],'AtomName',[],'altLoc',[],...
    'resName',[],'chainID',[],'resSeq',[],'iCode',[],'X',[],...
    'Y',[],'Z',[],'occupancy',[],'tempFactor',[],'segID',[],...
    'element',[],'charge',[],'AtomNameStruct',[]);
terminal_struct = struct('SerialNo',[],'resName',[],'chainID',[],...
    'resSeq',[],'iCode',[]);
hetero_atom_struct = struct('AtomSerNo',[],'AtomName',[],'altLoc',[],...
    'resName',[],'chainID',[],'resSeq',[],'iCode',[],'X',[],...
    'Y',[],'Z',[],'occupancy',[],'tempFactor',[],'segID',[],...
    'element',[],'charge',[],'AtomNameStruct',[]);

pdb_model_struct=struct('Atom',atom_struct,'Terminal',terminal_struct,...
    'HeterogenAtom',hetero_atom_struct);

group_PDB=cif_obj.subsref(struct('type','.','subs','atom_site.group_PDB'));
AtomSerNo=str2doubleq(cif_obj.subsref(struct('type','.','subs','atom_site.id')));
AtomName=cif_obj.subsref(struct('type','.','subs','atom_site.label_atom_id'));
%AtomName_char=char([cif_obj.subsref(struct('type','.','subs','atom_site.label_atom_id'));'    ']);
AtomName_char=char(cif_obj.subsref(struct('type','.','subs','atom_site.label_atom_id')));

%altLoc=cif_obj.subsref(struct('type','.','subs','atom_site.id'));
% Need to come back and support altLoc sometime, but must find an example
% file first.
resName=cif_obj.subsref(struct('type','.','subs','atom_site.label_comp_id'));
chainID=cif_obj.subsref(struct('type','.','subs','atom_site.auth_asym_id'));
resSeq=str2doubleq(cif_obj.subsref(struct('type','.','subs','atom_site.label_seq_id')));
iCode=cif_obj.subsref(struct('type','.','subs','atom_site.pdbx_PDB_ins_code'));
X=str2doubleq(cif_obj.subsref(struct('type','.','subs','atom_site.Cartn_x')));
Y=str2doubleq(cif_obj.subsref(struct('type','.','subs','atom_site.Cartn_y')));
Z=str2doubleq(cif_obj.subsref(struct('type','.','subs','atom_site.Cartn_z')));
occupancy=str2doubleq(cif_obj.subsref(struct('type','.','subs','atom_site.occupancy')));
tempFactor=str2doubleq(cif_obj.subsref(struct('type','.','subs','atom_site.B_iso_or_equiv')));
%segID=cif_obj.subsref(struct('type','.','subs','atom_site.auth_seq_id'));
element=cif_obj.subsref(struct('type','.','subs','atom_site.type_symbol'));
charge=cif_obj.subsref(struct('type','.','subs','atom_site.pdbx_formal_charge'));
%AtomNameStruct=cif_obj.subsref(struct('type','.','subs','atom_site.id'));

numAtoms=0;
numHetAtoms=0;
for i=1:length(AtomSerNo)
    switch group_PDB{i}
        case 'ATOM'
            numAtoms=numAtoms+1;
            pdb_model_struct.Atom(numAtoms).AtomSerNo=AtomSerNo(i);
            pdb_model_struct.Atom(numAtoms).AtomName=AtomName{i};
            pdb_model_struct.Atom(numAtoms).altLoc='';
            pdb_model_struct.Atom(numAtoms).resName=resName{i};
            pdb_model_struct.Atom(numAtoms).chainID=chainID{i};
            pdb_model_struct.Atom(numAtoms).resSeq=resSeq(i);
            if strcmp(iCode{i},'?')
                iCode{i}='';
            end
            pdb_model_struct.Atom(numAtoms).iCode=iCode{i};
            pdb_model_struct.Atom(numAtoms).X=X(i);
            pdb_model_struct.Atom(numAtoms).Y=Y(i);
            pdb_model_struct.Atom(numAtoms).Z=Z(i);
            pdb_model_struct.Atom(numAtoms).occupancy=occupancy(i);
            pdb_model_struct.Atom(numAtoms).tempFactor=tempFactor(i);
            pdb_model_struct.Atom(numAtoms).segID='?';
            pdb_model_struct.Atom(numAtoms).element=element{i};
            pdb_model_struct.Atom(numAtoms).charge=charge{i};
            pdb_model_struct.Atom(numAtoms).AtomNameStruct.wholeAtomName=AtomName_char(i,:);
            pdb_model_struct.Atom(numAtoms).AtomNameStruct.chemSymbol=element{i};
            x=AtomName_char(i,length(element{i})+1:end);
            if length(x) >= 1
                pdb_model_struct.Atom(numAtoms).AtomNameStruct.remoteInd=strtrim(x(1));
            end
            if length(x) >= 2 
                pdb_model_struct.Atom(numAtoms).AtomNameStruct.branch=strtrim(x(2));
            end
        case 'HETATM'
            numHetAtoms=numHetAtoms+1;
            pdb_model_struct.HeterogenAtom(numHetAtoms).AtomSerNo=AtomSerNo(i);
            pdb_model_struct.HeterogenAtom(numHetAtoms).AtomName=AtomName{i};
            pdb_model_struct.HeterogenAtom(numHetAtoms).altLoc='';
            pdb_model_struct.HeterogenAtom(numHetAtoms).resName=resName{i};
            pdb_model_struct.HeterogenAtom(numHetAtoms).chainID=chainID{i};
            pdb_model_struct.HeterogenAtom(numHetAtoms).resSeq=resSeq(i);
            if strcmp(iCode{i},'?')
                iCode{i}='';
            end
            pdb_model_struct.HeterogenAtom(numHetAtoms).iCode=iCode{i};
            pdb_model_struct.HeterogenAtom(numHetAtoms).X=X(i);
            pdb_model_struct.HeterogenAtom(numHetAtoms).Y=Y(i);
            pdb_model_struct.HeterogenAtom(numHetAtoms).Z=Z(i);
            pdb_model_struct.HeterogenAtom(numHetAtoms).occupancy=occupancy(i);
            pdb_model_struct.HeterogenAtom(numHetAtoms).tempFactor=tempFactor(i);
            pdb_model_struct.HeterogenAtom(numHetAtoms).segID='?';
            pdb_model_struct.HeterogenAtom(numHetAtoms).element=element{i};
            pdb_model_struct.HeterogenAtom(numHetAtoms).charge=charge{i};
            pdb_model_struct.Atom(numAtoms).AtomNameStruct.wholeAtomName=AtomName_char(i,:);
            pdb_model_struct.Atom(numAtoms).AtomNameStruct.chemSymbol=element{i};
            x=AtomName_char(i,length(element{i})+1:end);
            if length(x) >= 1
                pdb_model_struct.Atom(numAtoms).AtomNameStruct.remoteInd=x(1);
            end
            if length(x) >= 2 
                pdb_model_struct.Atom(numAtoms).AtomNameStruct.branch=x(2);
            end
    end
end
%Ter ignore for now


end

