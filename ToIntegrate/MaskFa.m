function [ MaskedAlignment, PerCounts] = MaskFa( Alignment,file_name,cutoff )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Sequences = vertcat(Alignment.Sequence);

for i=1:size(Sequences,2)
    B(i)=basecount(Sequences(:,i),'gaps',true);
end
NG = 1-[B.Gaps]/size(Sequences,1); %% Percent not Gaps


Keep = NG >= cutoff;

for j=1:size(Sequences,1)
    MaskedAlignment(j)=Alignment(j);
    MaskedAlignment(j).Sequence= MaskedAlignment(j).Sequence(Keep);
    C(j)=basecount(Sequences(j,:));
end
CCounts=[C.A;C.C;C.G;C.T]';

PerCounts=round(100*CCounts./repmat(sum(CCounts,2),1,4));

%fastawrite([file_name,'_',num2str(cutoff),'.fa'],MaskedAlignment);

seqalignviewer(MaskedAlignment);
distances = seqpdist(MaskedAlignment,'Method','Jukes-Cantor');
tree = seqlinkage(distances,'UPGMA',MaskedAlignment);
phytreeviewer(tree);

end

