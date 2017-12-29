function [ A ] = UpdateAlignment_simple( cads_rRNA, Alignment_File, remove_found_species )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numSamples=length(cads_rRNA);
%UpdateCoVar=false;
%WriteFiles=true;

%if nargin > 3
    %for ind=1:length(varargin)/2
        %switch varargin{2*ind-1}
           % case 'UpdateCoVar'
              %  UpdateCoVar=varargin{2*ind};
           % case 'WriteFiles'
               % WriteFiles=varargin{2*ind};
       % end
    %end
%end

for i=1:numSamples
    %cads_rRNA(i).AlignmentFile=Alignment_File;
    A=fastaread(Alignment_File);
    A=cads_rRNA(i).AddAlignment('premade',A);
    FindSpecies=regexprep(lower(cads_rRNA(i).Species),'[\s_]','');
    LookSpecies=lower(regexprep({A.Header},'[\s_]',''));
    [~,Species_Ind]=ismember(FindSpecies,LookSpecies);
    B=cads_rRNA(i).PlotAlignment('species',Species_Ind,'ShowPlots',false);
    aln=B{1};
    
    if (exist('remove_found_species','var')) && remove_found_species
        aln(Species_Ind)=[];
    end
    cads_rRNA(i).Alignment=aln;
%     H=Seq_entropy(cads_rRNA(i).RiboLabCads_rRNA(1).Alignment,'Gap_mode','prorate');
%     numSamples = length(H{1});
%     ConservationTable=cell(numSamples+1,9);
%     ConservationTable{1,1}='resNum';
%     ConservationTable(2:end,1) = cads_rRNA(i).ResidueList(1:length(H{1}));
%     ConservationTable{1,2}='resName';
%     ConservationTable(2:end,2)=cellstr(cads_rRNA(i).RiboLabCads_rRNA(1).Alignment(Species_Ind).Sequence');
%     ConservationTable{1,3} = 'Consensus';
%     ConservationTable(2:end,3)= cellstr(regexprep(seqconsensus(cads_rRNA(i).RiboLabCads_rRNA(1).Alignment,...
%         'Alphabet','NT','Gaps','all'),'T','U')');
%     ConservationTable(1,4:8) = {'A','C','G','U','Gaps'};
%     ConservationTable(2:end,4:8) = num2cell(seqprofile(cads_rRNA(i).RiboLabCads_rRNA(1).Alignment,...
%         'Alphabet','NT','Gaps','all')');
%     ConservationTable{1,9} = 'Shannon';
%     ConservationTable(2:end,9) = num2cell(H{1});
%     
%     cads_rRNA(i).Conservation_Table=ConservationTable;
    
%     cads_rRNA(i).Entropy_Table=[cads_rRNA(i).ResidueList(1:length(H{1})),num2cell(H{1}')];
%     cads_rRNA(i).Entropy_Table=vertcat(cads_rRNA(i).Entropy_Table, ...
%         [cads_rRNA(i).ResidueList(length(H{1})+1:end),repmat({'\N'},...
%         length(cads_rRNA(i).ResidueList(length(H{1})+1:end)),1)]);
%     if(WriteFiles)
%         %Entropy File
%         fid=fopen([cads_rRNA(i).RiboLabMap.Name,'_Entropy','.csv'],'wt');
%         fprintf(fid, '%s,%s\n','resNum','DataCol');
%         for j=1:size(cads_rRNA(i).Entropy_Table,1);
%             fprintf(fid, '%s,%s\n',cads_rRNA(i).Entropy_Table{j,1},num2str(cads_rRNA(i).Entropy_Table{j,2}));
%         end
%         fclose(fid);
%         
%         %Conservation Table
%         fid2=fopen([cads_rRNA(i).RiboLabMap.Name,'_ConservationTable','.csv'],'wt');
%         fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s\n',cads_rRNA(i).Conservation_Table{1,:});
%         fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s\n','"varchar(11)"','"varchar(3)"','"char(1)"',...
%             '"real(5,4)"','"real(5,4)"','"real(5,4)"','"real(5,4)"','"real(5,4)"','"real(5,4)"');
%         for j=2:size(cads_rRNA(i).Conservation_Table,1);
%             fprintf(fid, '%s,%s,%s,%f,%f,%f,%f,%f,%f\n',cads_rRNA(i).Conservation_Table{j,:});
%         end
%         fclose(fid2);
%     end
    %xlswrite([DataSetName_path,'\',get(handles.DataSetName,'String'),'_ConservationTable','.xlsx'],...
    % };result.Conservation_Table(2:end,:)]);
    
    
%     if (UpdateCoVar)
%         %This mode is unfished right now.
%         H_CoVar=CoVarEntropy(cads_rRNA(i).RiboLabCads_rRNA(1).Alignment,FR3D_Interaction_Tables,{'cww'},'ByTypes');
%         cads_rRNA(i).CoVarEntropy_Table=[cads_rRNA(i).ResidueList(1:length(H_CoVar{1})),num2cell(H_CoVar{1}')];
%         cads_rRNA(i).CoVarEntropy_Table=vertcat(cads_rRNA(i).CoVarEntropy_Table, ...
%             [cads_rRNA(i).ResidueList(length(H_CoVar{1})+1:end),repmat({'\N'},...
%             length(cads_rRNA(i).ResidueList(length(H_CoVar{1})+1:end)),1)]);
%     end
end
end

