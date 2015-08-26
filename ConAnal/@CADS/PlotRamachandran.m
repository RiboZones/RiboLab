function Ramachandran=PlotRamachandran(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numDataSets=length(CADS_object);
SubsetMode=false();

if nargin >2
    for ind=1:length(varargin)/2
        switch lower(varargin{2*ind-1})
            case 'subsets'
                SubsetMode=varargin{2*ind};
        end
    end
end

numSubsets_guess=length(CADS_object(1).Subsets);
Ramachandran=cell(numDataSets,numSubsets_guess);

for i=1:numDataSets
    
    resSeqA=[CADS_object(i).PDB(1).PDB.Model.Atom.resSeq];
    resSeqB=[CADS_object(i).PDB(2).PDB.Model.Atom.resSeq];
    numSubsets=length(CADS_object(i).Subsets);
    for j=1:numSubsets
        if ~SubsetMode
            KeepA=ismember(resSeqA,CADS_object(i).Keep(1).PDB);
            KeepB=ismember(resSeqB,CADS_object(i).Keep(2).PDB);
        else
            KeepA=ismember(resSeqA,intersect(CADS_object(i).Keep(1).Alignment(CADS_object(i).Subsets{j}),...
                CADS_object(i).Keep(1).PDB));
            KeepB=ismember(resSeqB,intersect(CADS_object(i).Keep(2).Alignment(CADS_object(i).Subsets{j}),...
                CADS_object(i).Keep(2).PDB));
        end
        newA=CADS_object(i).PDB(1).PDB;
        newB=CADS_object(i).PDB(2).PDB;
        newA.Model.Atom=newA.Model.Atom(KeepA);
        newB.Model.Atom=newB.Model.Atom(KeepB);
        MaxAtomSerNo=max([newA.Model.Atom.AtomSerNo]);
        for k=1:length(newB.Model.Atom)
            newB.Model.Atom(k).AtomSerNo=newB.Model.Atom(k).AtomSerNo+MaxAtomSerNo;
        end
        newC=newA;
        newC.Model.Atom=[newA.Model.Atom,newB.Model.Atom];
        Ramachandran{i,j}=ramachandran(newC,'chain','all','glycine',...
            'true','regions','true','plot','Separate');
    end
end
end