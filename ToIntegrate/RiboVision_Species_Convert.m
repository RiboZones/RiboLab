function [ output_args ] = RiboVision_Species_Convert( rv_file, speciesCodes, Alignment, ItemListA, ItemListB )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

textfile=fileread(rv_file);
ParsedSelections=regexp(textfile,'(?<resNum>[^,]+),(?<helixName>[^\W]+)','names');
if strcmp(ParsedSelections(1).resNum,'resNum');
    ParsedSelections(1)=[];
end
% if isempty(ParsedSelections)
%     % May mean no color specified
%     ParsedSelections=regexp(textfile,'create (?<seleName>[^,]+), (?<moleName>[^\W]+) and \((?<resi>[^\)]+)\)','names');
%     nocolors=true;
% else
%     nocolors=false;
% end

IndicesA=regexp(Alignment(1).Sequence,'[^-~]');
IndicesB=regexp(Alignment(2).Sequence,'[^-~]');

[~,corename]=fileparts(rv_file);

fid=fopen([corename,'_',speciesCodes{2},'.csv'],'wt');
fprintf(fid, 'resNum,HelixName\n');

OutputSelections=cell(1,length(ParsedSelections));

for i=1:length(ParsedSelections)
    SeleSplits=strsplit(ParsedSelections(i).resNum,';');
    OutputResidue=cell(2,length(SeleSplits));
    for j=1:length(SeleSplits)
        %         x=strcat(prefix{1},SeleSplits{j});
        resplit=strsplit(strtrim(SeleSplits{j}),':');
        numsplit=regexp(resplit{2},'[\w\d]+','match');
        for k=1:2
            [~,I]=ismember([resplit{1},':',numsplit{k}],ItemListA);
            if I > 0
                Pos=IndicesA(I);
                [~,II]=ismember(Pos,IndicesB);
                if II <=0 && k == 1
                    % If do not find an exact match, just take the next
                    % nucleotide
                    NextNuc=find(IndicesB>Pos, 1, 'first' );
                    OutputResidue(k,j)=ItemListB(NextNuc);
                    %OutputResidue{j}='x';
                elseif II<=0 && k == 2
                    % If do not find an exact match, just take the previous
                    % nucleotide
                    PrevNuc=find(IndicesB<Pos, 1, 'last' );
                    OutputResidue(k,j)=ItemListB(PrevNuc);
                    %OutputResidue{j}='x';
                else
                    OutputResidue(k,j)=ItemListB(II);
                end
            end
        end
        if I == 0
            continue
        end
        x=strsplit(OutputResidue{1,j},':');
        y=strsplit(OutputResidue{2,j},':');
        
        if j == 1
            OutputSelections{i}=[x{1},':(',x{2},'-',y{2},')'];
        else
            OutputSelections{i}=[OutputSelections{i},';',x{1},':(',x{2},'-',y{2},')'];
        end
    end
    %     OutputSelections(i).moleName=newMoleculeName;
    %     OutputSelections(i).seleName=regexprep(OutputSelections(i).seleName,speciesCodes{1},speciesCodes{2});
    %OutputSelections(i).color=['n_',OutputSelections(i).color];
    
    %     %Print original in new file
    %     fprintf(fid,'create %s, %s and (%s)\n',ParsedSelections(i).seleName,ParsedSelections(i).moleName,ParsedSelections(i).resi);
    %     fprintf(fid,'color %s, %s\n',ParsedSelections(i).color,ParsedSelections(i).seleName);
    %     fprintf(fid,'show cartoon, %s\n',ParsedSelections(i).seleName);
    %     fprintf(fid,'#show surface, %s\n\n\n',ParsedSelections(i).seleName);
    
    %Print converted in new file
    fprintf(fid,'%s,%s\n',OutputSelections{i},ParsedSelections(i).helixName);
    %     fprintf(fid,'color %s, %s\n',OutputSelections(i).color,OutputSelections(i).seleName);
    %     fprintf(fid,'show cartoon, %s\n',OutputSelections(i).seleName);
    %     fprintf(fid,'#show surface, %s\n\n\n',OutputSelections(i).seleName);
    
end


fclose(fid);
end

