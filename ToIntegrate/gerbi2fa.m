function [ FastaFile ] = gerbi2fa( file )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
table_format = fileread(file);

SequenceData=regexp(table_format,'(?<Species_Abv>[\w\d]{8,8})\t(?<Accession>[\w\d]+)\t(?<Species_Name>[^\t]+)\t(?<Sequence>[^\n]+)','names');
FastaFile=struct();

for i=1:length(SequenceData)
    FastaFile(i).Header=[SequenceData(i).Species_Name,'|',SequenceData(i).Species_Abv,'|',SequenceData(i).Accession];
    FastaFile(i).Sequence=regexprep(SequenceData(i).Sequence,'\.','-');
end

fastawrite(regexprep(file,'\.txt','\.fa'),FastaFile)
