function [ RV_Lab_Structs, H_CoVar, F_CoVar,Dyads ] = CoVarEntropyStruct( RV_Lab_Structs, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

BP_Types={'cww'};
CoVarMode='ByTypes';
WriteToFile=false;
MergeSingles=true;
ScaleFactor=2;
RemoveUnProcessed=false;
FreqFilterMode=false;
F_cutoff = 0.501;
TwoColorMode=false;
SecondColor='green';
SwitchPoint=0;
DataSetName=[RV_Lab_Structs(1).RiboLabMap.Name,'_CoVarEntropy'];
SimpleMerge=false;

if nargin > 1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'BP_Types'
                BP_Types=varargin{2*ind};
            case 'CoVarMode'
                CoVarMode=varargin{2*ind};
            case 'WriteToFile'
                WriteToFile=varargin{2*ind};
            case 'MergeSingles'
                MergeSingles=varargin{2*ind};
            case 'ScaleFactor'
                ScaleFactor=varargin{2*ind};
            case 'RemoveUnProcessed'
                RemoveUnProcessed=varargin{2*ind};
            case 'FreqFilterMode'
                FreqFilterMode=varargin{2*ind};
            case 'F_cutoff'
                F_cutoff=varargin{2*ind};
            case 'AlignmentFilter'
                AlignmentFilter=varargin{2*ind};
            case 'TwoColorMode'
                TwoColorMode=varargin{2*ind};
            case 'SecondColor'
                SecondColor=varargin{2*ind};
            case 'SwitchPoint'
                SwitchPoint=varargin{2*ind};
             case 'Name'
                DataSetName=varargin{2*ind};
            case 'SimpleMerge'
                SimpleMerge=varargin{2*ind};
        end
    end
end

for jjj=1:length(RV_Lab_Structs)
    if exist('AlignmentFilter','var')
        Alignment = RV_Lab_Structs(jjj).RiboLabCads_rRNA(1).Alignment(AlignmentFilter);
    else
        Alignment = RV_Lab_Structs(jjj).RiboLabCads_rRNA(1).Alignment;
    end

    RV_Lab_Structs(jjj).ConsensusSeq=seqconsensus(Alignment);

    [H_CoVar, F_CoVar,MostFreqBasePair,Dyads{jjj}]=CoVarEntropy(Alignment,RV_Lab_Structs(jjj).FR3D_Interaction_Tables,BP_Types,CoVarMode,varargin{:});

    if MergeSingles
        lenSeq=length(Alignment(1).Sequence);
        [~,H]=Seq_entropy(Alignment,'Gap_mode','prorate',varargin{:});

        H=H(1:lenSeq);
        Hadj=zeros(1,lenSeq);
        if SimpleMerge
            Hadj(H_CoVar{1} < 0) = H(H_CoVar{1} < 0);
            Hadj(H_CoVar{1} > 0) = ScaleFactor * H_CoVar{1}(H_CoVar{1} > 0);
        else
            Hadj=H;
            Hadj(H_CoVar{1} >= 0) = min([H(H_CoVar{1} >= 0); ScaleFactor * H_CoVar{1}(H_CoVar{1} >= 0)]);
        end
    else
        Hadj=H_CoVar{1};
    end

    if FreqFilterMode
        Fmax = compute_F_max(F_CoVar);

        Hadj(Fmax < F_cutoff)=-1;
    end

    RV_Lab_Structs(jjj).CoVarEntropy_Table=[RV_Lab_Structs(jjj).ResidueList(1:length(Hadj)),...
        num2cell(Hadj'),MostFreqBasePair{1}'];

    if (RemoveUnProcessed)
        RemoveRows=[RV_Lab_Structs(jjj).CoVarEntropy_Table{:,2}] < 0;
        RV_Lab_Structs(jjj).CoVarEntropy_Table(RemoveRows,:)=[];
    end

    if (WriteToFile)
        if jjj==1
            fid=fopen([DataSetName,'.csv'],'wt');
        end
        if TwoColorMode
            fprintf(fid, '%s,%s,%s,%s,%s\n','resNum','DataCol','ModeBasePair','TwoColorMode','SwitchPoint');
            RV_Lab_Structs(jjj).CoVarEntropy_Table{1,4}='black';
            RV_Lab_Structs(jjj).CoVarEntropy_Table{2,4}=SecondColor;
            RV_Lab_Structs(jjj).CoVarEntropy_Table{1,5}=SwitchPoint;

            for j=1:size(RV_Lab_Structs(jjj).CoVarEntropy_Table,1)
                fprintf(fid, '%s,%s,%s,%s,%s\n',RV_Lab_Structs(jjj).CoVarEntropy_Table{j,1},...
                    num2str(RV_Lab_Structs(jjj).CoVarEntropy_Table{j,2}),...
                    RV_Lab_Structs(jjj).CoVarEntropy_Table{j,1},RV_Lab_Structs(jjj).CoVarEntropy_Table{j,4},...
                    num2str(RV_Lab_Structs(jjj).CoVarEntropy_Table{j,5}));
            end
        else
            fprintf(fid, '%s,%s,%s\n','resNum','DataCol','ModeBasePair');
            for j=1:size(RV_Lab_Structs(jjj).CoVarEntropy_Table,1)
                fprintf(fid, '%s,%s,%s\n',RV_Lab_Structs(jjj).CoVarEntropy_Table{j,1},...
                    num2str(RV_Lab_Structs(jjj).CoVarEntropy_Table{j,2}),RV_Lab_Structs(jjj).CoVarEntropy_Table{j,3}{1});
            end
        end
        if jjj==length(RV_Lab_Structs)
            fclose(fid);
        end
    end
end
end

function Fmax = compute_F_max(F_CoVar)

numPoints = length(F_CoVar{1});
Fmax = zeros(1,numPoints);


for j = 1:numPoints
    if ~isempty(F_CoVar{1}{j})
        Fmax(j)=max(F_CoVar{1}{j});
    end
end

end
