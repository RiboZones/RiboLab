function [ TaxID,QueryString ] = UniProt2TaxID(uniprot_xml_file)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

V = xml_parseany(fileread(uniprot_xml_file));

numSpecies=length(V.entry);
TaxID=zeros(1,numSpecies);
Query=cell(1,numSpecies);
for i=1:numSpecies
    TaxID(i)=str2double(V.entry{i}.organism{1}.dbReference{1}.ATTRIBUTE.id);    
    Query{i}=[' OR (txid',num2str(TaxID(i)),'[Organism])'];
end

Query{1}(1:3)=[];
QueryString=horzcat(Query{:});

end


