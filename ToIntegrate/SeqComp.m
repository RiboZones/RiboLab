function [ Merge_DS,DS_Table ] = SeqComp( Whole,Domain, DomainsDef, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Entropy_Cutoff = 0.47;
Domain_Color = 'Purple';
DomainCodes={'B','A','E'};

if nargin > 3
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'Entropy_Cutoff'
                Entropy_Cutoff=varargin{2*ind};
            case 'Domain_Color'
                Domain_Color=varargin{2*ind};
            case 'DomainCodes'
                DomainCodes=varargin{2*ind};
        end
    end
end

Domain_Entropies=cell2mat(Domain.Entropy_Table(1:length(Domain.RiboLabCads_rRNA(1).Alignment(1).Sequence),2));
numDomainCodes=length(DomainCodes);

DS_Table=cell(1,numDomainCodes);
isEmpty=false(1,numDomainCodes);
for i=1:numDomainCodes
    Different_Consensus=~strcmp(Domain.Conservation_Table(2:end,3),...
        cellstr(regexprep(seqconsensus(Whole.RiboLabCads_rRNA(1).Alignment(DomainsDef.(DomainCodes{i})),'Alphabet','NT','Gaps','all'),'T','U')'));
    
    Domain_Specific = ( Domain_Entropies <= Entropy_Cutoff ) & Different_Consensus;
    
    DS_Table{i}=[Domain.ResidueList(Domain_Specific), num2cell(Domain_Entropies(Domain_Specific)),repmat({Domain_Color},sum(Domain_Specific),1)];
    
    isEmpty(i)=isempty(DS_Table{i});
    %xlswrite([Whole.RiboLabMap.Name,'_',DomainCodes{i},'_DomainSpecific','.xlsx'],...
    %[{'resNum','DataCol','ColorCol'};DS_Table{i}]);
end

%%Merge_DS = vertcat(DS_Table{:});
%%[~,I]=unique(Merge_DS(:,1));
%%Merge_DS=Merge_DS(sort(I),:);
Merge_DS=DS_Table(~isEmpty);
if length(Merge_DS) > 1
    [~,IA]=intersect(Merge_DS{1}(:,1),Merge_DS{2}(:,1),'stable');
    Merge_DS=Merge_DS{1}(IA,:);
else
    Merge_DS=Merge_DS{1};
end

xlswrite([Whole.RiboLabMap.Name,'_','True','_DomainSpecific','.xlsx'],...
    [{'resNum','DataCol','ColorCol'};Merge_DS]);
end
