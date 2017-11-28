function [ BP_Seq ] = CTstruct2BPseq( CT_struct, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Assume single stranded for now. Assumes consecutive for now. Assume
%bases are all numbers.

WriteToFile=false();
Path='.';

if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'WriteToFile'
                WriteToFile=varargin{2*ind};
            case 'Path'
                Path=varargin{2*ind};
        end
    end
end


numBases=length(CT_struct.Data);

DataSetName=CT_struct.Name;
BP_Seq.Name=DataSetName;
BP_Seq.Chain='unknown';

for i=1:numBases
    BP_Seq.Data(i).BP1_Name=CT_struct.Data(i).Base;
    BP_Seq.Data(i).BP1_Num=CT_struct.Data(i).BaseNumber;
    BP_Seq.Data(i).BP2_Num=CT_struct.Data(i).BasePaired;
end

if (WriteToFile)
    fid=fopen(fullfile(Path,[DataSetName,'.bpseq']),'wt');
    a=cellstr(num2str([BP_Seq.Data.BP1_Num]'));
    b=cellstr(num2str([BP_Seq.Data.BP2_Num]'));
    for i=1:numBases;
        fprintf(fid, '%s %s %s\n',a{i},BP_Seq.Data(i).BP1_Name,b{i});
    end
    fclose(fid);
end


end
