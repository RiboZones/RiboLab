function [ NewAlignment ] = AlignmentSplice( Alignment1, Alignment2, ReplaceCols1, ReplaceCols2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numSpecies=length(Alignment1);

if numSpecies ~= length(Alignment2)
    error('Alignments do not contain the same number of species.');
end

for i=1:numSpecies
    NewAlignment(i).Header=Alignment1(i).Header;
    NewAlignment(i).Sequence=[Alignment1(i).Sequence(1:ReplaceCols1(1) - 1),...
        Alignment2(i).Sequence(ReplaceCols2(1):ReplaceCols2(2)),...
        Alignment1(i).Sequence(ReplaceCols1(2) + 1:end)];
    NewAlignment(i).Sequence=regexprep(NewAlignment(i).Sequence,'~','-');
end