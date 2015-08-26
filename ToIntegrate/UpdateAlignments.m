function [ A ] = UpdateAlignments( RV_Lab_Struct, Alignment_File, FR3D_File, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numSamples=length(RV_Lab_Struct);
UpdateCoVar=false;
WriteFiles=true;

if nargin > 3
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'UpdateCoVar'
                UpdateCoVar=varargin{2*ind};
            case 'WriteFiles'
                WriteFiles=varargin{2*ind};
        end
    end
end

for i=1:numSamples
    RV_Lab_Struct(i).AlignmentFile=Alignment_File;
    A=fastaread(RV_Lab_Struct(i).AlignmentFile);
    A=RV_Lab_Struct(i).RiboLabCads_rRNA(1).AddAlignment('premade',A);
    FindSpecies=regexprep(lower(RV_Lab_Struct(i).RiboLabCads_rRNA(1).Species),'[\s_]','');
    LookSpecies=lower(regexprep({A.Header},'[\s_]',''));
    [~,Species_Ind]=ismember(FindSpecies,LookSpecies);
    B=RV_Lab_Struct(i).RiboLabCads_rRNA(1).PlotAlignment('species',Species_Ind,'ShowPlots',false);
    RV_Lab_Struct(i).RiboLabCads_rRNA(1).Alignment=B{1};
    
    H=Seq_entropy(RV_Lab_Struct(i).RiboLabCads_rRNA(1).Alignment,'Gap_mode','prorate');
    numSamples = length(H{1});
    ConservationTable=cell(numSamples+1,9);
    ConservationTable{1,1}='resNum';
    ConservationTable(2:end,1) = RV_Lab_Struct(i).ResidueList(1:length(H{1}));
    ConservationTable{1,2}='resName';
    ConservationTable(2:end,2)=cellstr(RV_Lab_Struct(i).RiboLabCads_rRNA(1).Alignment(Species_Ind).Sequence');
    ConservationTable{1,3} = 'Consensus';
    ConservationTable(2:end,3)= cellstr(regexprep(seqconsensus(RV_Lab_Struct(i).RiboLabCads_rRNA(1).Alignment,...
        'Alphabet','NT','Gaps','all'),'T','U')');
    ConservationTable(1,4:8) = {'A','C','G','U','Gaps'};
    ConservationTable(2:end,4:8) = num2cell(seqprofile(RV_Lab_Struct(i).RiboLabCads_rRNA(1).Alignment,...
        'Alphabet','NT','Gaps','all')');
    ConservationTable{1,9} = 'Shannon';
    ConservationTable(2:end,9) = num2cell(H{1});
    
    RV_Lab_Struct(i).Conservation_Table=ConservationTable;
    
    RV_Lab_Struct(i).Entropy_Table=[RV_Lab_Struct(i).ResidueList(1:length(H{1})),num2cell(H{1}')];
    RV_Lab_Struct(i).Entropy_Table=vertcat(RV_Lab_Struct(i).Entropy_Table, ...
        [RV_Lab_Struct(i).ResidueList(length(H{1})+1:end),repmat({'\N'},...
        length(RV_Lab_Struct(i).ResidueList(length(H{1})+1:end)),1)]);
    if(WriteFiles)
        %Entropy File
        fid=fopen([RV_Lab_Struct(i).RiboLabMap.Name,'_Entropy','.csv'],'wt');
        fprintf(fid, '%s,%s\n','resNum','DataCol');
        for j=1:size(RV_Lab_Struct(i).Entropy_Table,1);
            fprintf(fid, '%s,%s\n',RV_Lab_Struct(i).Entropy_Table{j,1},num2str(RV_Lab_Struct(i).Entropy_Table{j,2}));
        end
        fclose(fid);
        
        %Conservation Table
        fid2=fopen([RV_Lab_Struct(i).RiboLabMap.Name,'_ConservationTable','.csv'],'wt');
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s\n',RV_Lab_Struct(i).Conservation_Table{1,:});
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s\n','"varchar(11)"','"varchar(3)"','"char(1)"',...
            '"real(5,4)"','"real(5,4)"','"real(5,4)"','"real(5,4)"','"real(5,4)"','"real(5,4)"');
        for j=2:size(RV_Lab_Struct(i).Conservation_Table,1);
            fprintf(fid, '%s,%s,%s,%f,%f,%f,%f,%f,%f\n',RV_Lab_Struct(i).Conservation_Table{j,:});
        end
        fclose(fid2);
    end
    %xlswrite([DataSetName_path,'\',get(handles.DataSetName,'String'),'_ConservationTable','.xlsx'],...
    % };result.Conservation_Table(2:end,:)]);
    
    
    if (UpdateCoVar)
        %This mode is unfished right now.
        H_CoVar=CoVarEntropy(RV_Lab_Struct(i).RiboLabCads_rRNA(1).Alignment,FR3D_Interaction_Tables,{'cww'},'ByTypes');
        RV_Lab_Struct(i).CoVarEntropy_Table=[RV_Lab_Struct(i).ResidueList(1:length(H_CoVar{1})),num2cell(H_CoVar{1}')];
        RV_Lab_Struct(i).CoVarEntropy_Table=vertcat(RV_Lab_Struct(i).CoVarEntropy_Table, ...
            [RV_Lab_Struct(i).ResidueList(length(H_CoVar{1})+1:end),repmat({'\N'},...
            length(RV_Lab_Struct(i).ResidueList(length(H_CoVar{1})+1:end)),1)]);
    end
end
end

