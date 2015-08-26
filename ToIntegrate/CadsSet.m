function [ Cads_object,A ] = CadsSet( file_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

A=PDBentry('TempObject');

A.ImportPDB(file_name);
A.Process();
%if byChain
%    pdb_set=A.SplitByChain;
%else
    pdb_set=A.SplitByMolID;
%end
names={pdb_set.Name};

Cads_object=CADS(names);

Cads_object.AddPDB(pdb_set);

end

