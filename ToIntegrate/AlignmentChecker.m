function [ output_args ] = AlignmentChecker(refSeq,AlignmentSet,Structure)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numAlignments=length(AlignmentSet);
Shannon_Entropy=cell(numAlignments,1);
for i=1:numAlignments
    [ ~, Shannon_Entropy{i}] = Seq_entropy(AlignmentSet{i},'Gap_mode','penalize') ;
    ColorVar({Shannon_Entropy{i}'});
    disp(mean(Shannon_Entropy{i}))
    distances = seqpdist(AlignmentSet{i})
    tree = seqlinkage(distances,'average',AlignmentSet{i})
    phytreetool(tree)

end
% disp(42)

end

