function [ new_pdb, pdb] = UpdateBfactor(pdb,newProp,keep,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Cut=false;
LocalMax=max(newProp);

if nargin >3
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'Cut'
                Cut=varargin{2*ind};
            case 'Max'
                LocalMax=varargin{2*ind};
        end
    end
end

resSeq=[pdb.Model.Atom.resSeq];
KeepAtoms_A=ismember(resSeq,keep.PDB);
KeepAtoms_B=ismember(resSeq,keep.Alignment);
KeepAtoms=KeepAtoms_A & KeepAtoms_B;
new_pdb=pdb;
if Cut
    [~,loc]=ismember(resSeq(KeepAtoms),keep.Alignment);
    new_pdb.Model.Atom=new_pdb.Model.Atom(KeepAtoms);
    for i=1:length(new_pdb.Model.Atom)
        new_pdb.Model.Atom(i).tempFactor=newProp(loc(i));
    end
else
    [~,loc]=ismember(resSeq,keep.Alignment);
    for i=1:length(new_pdb.Model.Atom)
       if KeepAtoms(i)
           new_pdb.Model.Atom(i).tempFactor=newProp(loc(i));
       else
           new_pdb.Model.Atom(i).tempFactor=LocalMax;
       end
    end
end