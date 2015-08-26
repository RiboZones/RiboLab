function [All_Table]=SuperLabels(Maps)

%species={'TT','HM','EC'};
species={'TT'};
%molecules={'23S','5S'};
molecules={'16S'};
SubUnit='SSU';
MapType='struct';
LabelTypes={'Domain_Labels','Helix_Labels','Residue_Labels','Res_Stick_Labels'};
LabelFlags={'domain','helix','residue','42'};

TextHeader={'LabelText','X','Y','Font','FontSize','Fill';'varchar(500)',...
    '''real(8,3)''','''real(8,3)''','varchar(100)','''real(6,3)''','char(7)'};
LineHeader={'X1','Y1','X2','Y2','Fill','Stroke','StrokeWidth','StrokeLineJoin','StrokeMiterLimit';...
'''real(8,3)''','''real(8,3)''','''real(8,3)''','''real(8,3)''','char(7)',...
'char(7)','''real(6,3)''','char(5)','''real(6,3)'''};
numSpecies=length(species);
numMolecules=length(molecules);
All_Table=cell(numSpecies,1);

for i = 1:numSpecies      %EC,HM,TT
    
    for j = 1:numMolecules %23S, 5S
        Maps.(species{i}).New(j).TextLabels=[];
        Maps.(species{i}).New(j).LineLabels=[];
        for k = 1:length(LabelTypes)  % {'domain','helix','residue','42';} 
            ReadLabelsSVG([molecules{j},'/',species{i},'_',molecules{j},'_',...
                LabelTypes{k},'.svg'],LabelFlags{k},Maps.(species{i}).New(j));
        end
        if j == numMolecules
            ReadLabelsSVG([species{i},'_',SubUnit,'_',MapType,...
                '_Species_Label','.svg'],'42',Maps.(species{i}).New(end)); %Read in the file
        end
        All_Table{i}{j}=Maps.(species{i}).New(j).TableLabels();
    end
    d=[All_Table{i}{:}];
    
    vertcat(d.Line);
    xlswrite([species{i},'_',SubUnit,'_',MapType,'_TextLabels.xlsx'],[TextHeader;vertcat(d.Text)]);    
    xlswrite([species{i},'_',SubUnit,'_',MapType,'_LineLabels.xlsx'],[LineHeader;vertcat(d.Line)]);

    
end
