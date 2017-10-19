function [ NewAlignment ] = AlignmentAdd( Alignment1, Alignment2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numSpecies=length(Alignment1);

if numSpecies ~= length(Alignment2)
    error('Alignments do not contain the same number of species.');
end

for i=1:numSpecies
    NewAlignment(i).Header=Alignment1(i).Header;
    NewAlignment(i).Sequence=[Alignment1(i).Sequence,Alignment2(i).Sequence];
    NewAlignment(i).Sequence=regexprep(NewAlignment(i).Sequence,'~','-');
end