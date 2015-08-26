function [ CT_struct ] = BP2CT( BP_Struct, RiboLabMap, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Assume single stranded for now. Assumes consecutive for now. Assume
%bases are all numbers.
index=0;
WriteToFile=false();

if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'WriteToFile'
                WriteToFile=varargin{2*ind};
        end
    end
end

numBasePairs=length(BP_Struct.Data);
numBases=length(RiboLabMap.ItemNames);

BasePairList=zeros(numBasePairs,2);
for i=1:numBasePairs
    BasePairList(i, :) = [ str2double(BP_Struct.Data(i).BP1_Num), str2double(BP_Struct.Data(i).BP2_Num)];
end

CT_struct.Name = BP_Struct.Name;
CT_struct.Length = numBases;

for i=1:numBases   
    CT_struct.Data(i).BaseNumber=i;
    CT_struct.Data(i).Base=RiboLabMap.Other(i).Letter;
    CT_struct.Data(i).PrevIndex=i-1;
    CT_struct.Data(i).NextIndex=i+1;
    [~,found_index]=ismember(i,BasePairList);
    if found_index == 0
        base_paired=0;
    elseif found_index <= numBasePairs
        base_paired=BasePairList(found_index,2);
    elseif found_index > numBasePairs
        base_paired=BasePairList(found_index - numBasePairs ,1);
    end
    CT_struct.Data(i).BasePaired=base_paired;
    CT_struct.Data(i).NaturalNumber=i;
end

if (WriteToFile)
    fid=fopen([CT_struct.Name,'_CT','.ct'],'wt');
    fprintf(fid, '%d %s\n',CT_struct.Length,CT_struct.Name);
    for i=1:numBases;
        fprintf(fid, '%d %s %d %d %d %d\n',CT_struct.Data(i).BaseNumber,...
            CT_struct.Data(i).Base,CT_struct.Data(i).PrevIndex,...
            CT_struct.Data(i).NextIndex,CT_struct.Data(i).BasePaired,...
            CT_struct.Data(i).NaturalNumber);
    end
    fclose(fid);
end


end

