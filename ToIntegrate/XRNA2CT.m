function [ CT_struct ] = XRNA2CT( xrna_file, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Assumes consecutive for now. Assume
%bases are all numbers.
%New version supports multiple strands.
index=0;
WriteToFile=false();
ResidueSubet={};
if nargin > 1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'WriteToFile'
                WriteToFile=varargin{2*ind};
             case 'ResidueSubet'
                ResidueSubet=varargin{2*ind};
        end
    end
end

%% Parse textfile
textfile=fileread(xrna_file);
ParsedStrands=regexp(textfile,'<RNAMolecule Name=''(?<molName>[^'']+)''>','names');
StartNucIDs=regexp(textfile,'<NucListData StartNucID=''(?<StartNucID>[^'']+)''[^>]*>','names');

ParsedStrandsIndices=regexp(textfile,'<RNAMolecule Name=''(?<molName>[^'']+)''>');
ParsedStrandsIndices=[ParsedStrandsIndices, length(textfile)];
numStrands=length(ParsedStrands);
ParsedBasePairs=cell(numStrands,1);
ParsedBases=cell(numStrands,1);
KeepParsedBases=cell(numStrands,1);
StrandStarts=cell(numStrands,1);
StrandEnds=cell(numStrands,1);
ResidueList=cell(numStrands,1);
%% Calculate original residues and base pairs
for i=1:numStrands
    %Loop through strands
    ParsedBasePairs{i}=regexp(textfile(ParsedStrandsIndices(i):ParsedStrandsIndices(i+1)),['<BasePairs nucID=''(?<nucID>[\d]+)''\s',...
        'length=''(?<length>[\d]+)''\sbpNucID=''(?<bpNucID>[\d]+)''\s(bpName='')*([\w\d]*)*(''\s)?/>'],'tokens');
    ParsedBases{i}=regexp(textfile(ParsedStrandsIndices(i):ParsedStrandsIndices(i+1)),'(?<Letter>[ACGUT]) (?<X>[^\s]+) (?<Y>[^\s]+)','names');
    ResidueList{i}=regexprep(strcat([ParsedStrands(i).molName,':'],cellstr(num2str((1:length(ParsedBases{i}))' + str2num(StartNucIDs(i).StartNucID)-1))),'\s','');
end
ConcatResidueList=vertcat(ResidueList{:});

%% Residue List Filter
if isempty(ResidueSubet)
    KeptResidueList=ConcatResidueList;
else
    KeptResidueList=ConcatResidueList(ismember(ConcatResidueList,ResidueSubet));
end

%% Calculate strand starts, ends, and ParsedBases based on optional filtered data.
for i=1:numStrands
    KeepParsedBases{i} = ParsedBases{i}(ismember(ResidueList{i},KeptResidueList));
    if i==1
        StrandStarts{i}=num2str(1);
        StrandEnds{i}=num2str(length(KeepParsedBases{i}));
    else
        StrandStarts{i}=num2str(1 + str2num(StrandEnds{i - 1}));
        StrandEnds{i}=num2str(str2num(StrandEnds{i - 1}) + length(KeepParsedBases{i}));
    end
end


%% Calculate base pairs
BasePairList=cell(1,2);
for i=1:numStrands
    %Loop through each helix in each strand
    numHelicies=length(ParsedBasePairs{i});
    for j=1:numHelicies
        nucID=[ParsedStrands(i).molName,':',ParsedBasePairs{i}{j}{1}];
        Helix_length=str2double(ParsedBasePairs{i}{j}{2});
        if ~isempty(ParsedBasePairs{i}{j}{5})
            bpNucID=[ParsedBasePairs{i}{j}{5},':',ParsedBasePairs{i}{j}{3}];
        else
            bpNucID=[ParsedStrands(i).molName,':',ParsedBasePairs{i}{j}{3}];
        end
        
        for k=1:Helix_length
            [~,In]=ismember(nucID,KeptResidueList);
            [~,Ib]=ismember(bpNucID,KeptResidueList);
            if In > 0 && Ib > 0
                BasePairList(index + 1, :) = {KeptResidueList{In + k - 1}, KeptResidueList{Ib - k + 1}};
                index = index + 1;
            end
        end
    end
end

%% Compute CT file structure
numBasePairs=size(BasePairList,1);
numBases=length(KeptResidueList);
[~,DataSetName_piece]=fileparts(xrna_file);
CT_struct.Name = DataSetName_piece;
CT_struct.Length = numBases;

pb=[KeepParsedBases{:}];
Letters = vertcat(pb.Letter);
for i=1:numBases
    
    CT_struct.Data(i).BaseNumber=i;
    CT_struct.Data(i).Base=Letters(i);
    if ismember(num2str(i),StrandStarts)
        CT_struct.Data(i).PrevIndex=0;
    else
        CT_struct.Data(i).PrevIndex=i-1;
    end
    if ismember(num2str(i),StrandEnds)
        CT_struct.Data(i).NextIndex=0;
    else
        CT_struct.Data(i).NextIndex=i+1;
    end
    
    [~,found_index]=ismember(KeptResidueList{i},BasePairList);
    if found_index == 0
        base_paired=0;
    elseif found_index <= numBasePairs
        bp=BasePairList(found_index,2);
        [~,base_paired]=ismember(bp,KeptResidueList);
    elseif found_index > numBasePairs
        bp=BasePairList(found_index - numBasePairs ,1);
        [~,base_paired]=ismember(bp,KeptResidueList);
    end
    
    CT_struct.Data(i).BasePaired=base_paired;
    CT_struct.Data(i).NaturalNumber=KeptResidueList{i};
end

%% Write to file
if (WriteToFile)
    fid=fopen([CT_struct.Name,'_CT','.ct'],'wt');
    fprintf(fid, '%d %s\n',CT_struct.Length,CT_struct.Name);
    for i=1:numBases;
        fprintf(fid, '%d %s %d %d %d %s\n',CT_struct.Data(i).BaseNumber,...
            CT_struct.Data(i).Base,CT_struct.Data(i).PrevIndex,...
            CT_struct.Data(i).NextIndex,CT_struct.Data(i).BasePaired,...
            CT_struct.Data(i).NaturalNumber);
    end
    fclose(fid);
end


end




