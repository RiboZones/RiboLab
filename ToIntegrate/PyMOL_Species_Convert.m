function [ output_args ] = PyMOL_Species_Convert( pml_file, prefix, speciesCodes, newMoleculeName, Alignment, ItemListA, ItemListB )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

textfile=fileread(pml_file);
ParsedSelections=regexp(textfile,'create (?<seleName>[^,]+), (?<moleName>[^\W]+) and \((?<resi>[^\)]+)[^c]+color\s(?<color>[^,]+)','names');

IndicesA=regexp(Alignment(1).Sequence,'[^-]');
IndicesB=regexp(Alignment(2).Sequence,'[^-]');

[~,corename]=fileparts(pml_file);

fid=fopen([corename,'_',speciesCodes{2},'.pml'],'wt');
%fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s\n',RV_Lab_Struct(i).Conservation_Table{1,:});

for i=1:length(ParsedSelections)
    OriginalResidue=regexp(ParsedSelections(i).resi,'([\d]*)','match');
    OutputSelections(i)=ParsedSelections(i);
    OutputResidue=cell(1,length(OriginalResidue));
    for j=1:length(OriginalResidue)
        x=strcat(prefix{1},OriginalResidue{j});
        [~,I]=ismember(x,ItemListA);
        Pos=IndicesA(I);
        [~,II]=ismember(Pos,IndicesB);
        if II <=0
            % If do not find an exact match, just take the previous
            % nucleotide
            PrevNuc=find(IndicesB<Pos, 1, 'last' );
            OutputResidue{j}=regexprep(ItemListB(PrevNuc),prefix{2},'');
            %OutputResidue{j}='x';
        else
            OutputResidue{j}=regexprep(ItemListB(II),prefix{2},'');
        end
        OutputSelections(i).resi=regexprep(OutputSelections(i).resi,OriginalResidue{j},OutputResidue{j});
        
    end
    OutputSelections(i).moleName=newMoleculeName;
    OutputSelections(i).seleName=regexprep(OutputSelections(i).seleName,speciesCodes{1},speciesCodes{2});
    OutputSelections(i).color=['n_',OutputSelections(i).color];
    
    %Print original in new file
    fprintf(fid,'create %s, %s and (%s)\n',ParsedSelections(i).seleName,ParsedSelections(i).moleName,ParsedSelections(i).resi);
    fprintf(fid,'color %s, %s\n',ParsedSelections(i).color,ParsedSelections(i).seleName);
    fprintf(fid,'show cartoon, %s\n',ParsedSelections(i).seleName);
    fprintf(fid,'#show surface, %s\n\n\n',ParsedSelections(i).seleName);
    
    %Print converted in new file
    fprintf(fid,'create %s, %s and (%s)\n',OutputSelections(i).seleName,OutputSelections(i).moleName,OutputSelections(i).resi);
    fprintf(fid,'color %s, %s\n',OutputSelections(i).color,OutputSelections(i).seleName);
    fprintf(fid,'show cartoon, %s\n',OutputSelections(i).seleName);
    fprintf(fid,'#show surface, %s\n\n\n',OutputSelections(i).seleName);
    
end


fclose(fid);
end

