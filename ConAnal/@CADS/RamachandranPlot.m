function Ramachandran=RamachandranPlot(CADS_object,Subsets)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numDataSets=length(CADS_object);

if mod(length(Subsets),numDataSets)
    error('Number of Subsets must be a multiple of Number of DataSets')
else
    numSubsets=length(Subsets)/numDataSets;
%     numSamples=numSubsets*numDataSets;
end
Ramachandran=cell(numDataSets,numSubsets);

for i=1:numDataSets
    
    resSeqA=[CADS_object(i).PDB(1).Model.Atom.resSeq];
    resSeqB=[CADS_object(i).PDB(2).Model.Atom.resSeq];
    for j=1:numSubsets
        if nargin==1
            KeepA=ismember(resSeqA,CADS_object(i).Keep(1).PDB);
            KeepB=ismember(resSeqB,CADS_object(i).Keep(2).PDB);
        else
            KeepA=ismember(resSeqA,intersect(CADS_object(i).Keep(1).Alignment(Subsets{2*(i-1)+j}),...
                CADS_object(i).Keep(1).PDB));
            KeepB=ismember(resSeqB,intersect(CADS_object(i).Keep(2).Alignment(Subsets{2*(i-1)+j}),...
                CADS_object(i).Keep(2).PDB));
        end
        newA=CADS_object(i).PDB(1);
        newB=CADS_object(i).PDB(2);
        newA.Model.Atom=newA.Model.Atom(KeepA);
        newB.Model.Atom=newB.Model.Atom(KeepB);
        MaxAtomSerNo=max([newB.Model.Atom.AtomSerNo]);
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