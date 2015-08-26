function VarPDBWrite(CADS_object,index)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    index=1;
end
newpdb=cell(1,length(CADS_object));
pdb=cell(1,length(CADS_object));
LocalMax=zeros(1,length(CADS_object));

for i=1:length(CADS_object)
    LocalMax(i)=max(CADS_object(i).Results(index).Variability);
end
GlobalMax=max(LocalMax);

for i=1:length(CADS_object)
    [newpdb{i},pdb{i}] = UpdateBfactor(CADS_object(i).PDB(index).PDB,...
        CADS_object(i).Results(index).Variability,CADS_object(i).Keep(index),...
        'Max',GlobalMax);
    pdbwrite([CADS_object(i).Name,'_',CADS_object(i).Species{index},'_var.pdb'],newpdb{i})
    pdbwrite([CADS_object(i).Name,'_',CADS_object(i).Species{index},'.pdb'],pdb{i})
end

