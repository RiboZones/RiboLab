function [ ConservationTable ] = ConservationTable( CADS_obj , varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
ItemNamePrefix='';
WriteFile=true;
if nargin >1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'prefix'
                ItemNamePrefix=varargin{2*ind};
            case 'WriteFile'
                WriteFile=varargin{2*ind};
        end
    end
end

numCads=length(CADS_obj);
ConservationTable = cell (numCads,1);

for i = 1 : numCads
    numSamples= length(CADS_obj(i).ItemNames);
    ConservationTable{i}=cell(numSamples+1,9);
    ConservationTable{i}{1,1}='resNum';
    ConservationTable{i}(2:end,1) = strcat(ItemNamePrefix,CADS_obj(i).ItemNames);
    ConservationTable{i}{1,2}='resName';
    ConservationTable{i}(2:end,2)=cellstr(CADS_obj(i).Full.Sequence');
    ConservationTable{i}{1,3} = 'Consensus';
    ConservationTable{i}(2:end,3)= cellstr(regexprep(seqconsensus(CADS_obj(i).Alignment,...
        'Alphabet','NT','Gaps','all'),'T','U')');
    ConservationTable{i}(1,4:8) = {'A','C','G','U','Gaps'};
    ConservationTable{i}(2:end,4:8) = num2cell(seqprofile(CADS_obj(i).Alignment,...
        'Alphabet','NT','Gaps','all')');
    ConservationTable{i}{1,9} = 'Shannon';
    [~,H]=Seq_entropy(CADS_obj(i).Alignment,'Gap_mode','prorate');
    ConservationTable{i}(2:end,9) = num2cell(H);
    if WriteFile
        xlswrite([CADS_obj(i).Name,'_','ConservationTable','.xlsx'],ConservationTable{i});
    end
end

