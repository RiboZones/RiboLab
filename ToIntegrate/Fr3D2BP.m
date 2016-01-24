function [BP_Struct] = Fr3D2BP(fred_text_file,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

FR3Dstyle='newCombined';

if nargin > 1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'FR3Dstyle'
                FR3Dstyle=varargin{2*ind};
        end
    end
end

textfile=fileread(fred_text_file);

switch FR3Dstyle
    case 'old'
        BP=regexp(textfile,['(?<Index>[0-9]+\s)(?<BP1_Name>[ACGUT])[\s]*(?<BP1_Num>',...
            '[^\(]+)\((?<BP1_Chain>[\w])\)\s-\s(?<BP2_Name>[ACGUT])[\s]*(?<BP2_Num>[^\(]+)',...
            '\((?<BP2_Chain>[\w])\)[\s]*-[\s]*(?<BP_Type>[^\s]+)[\s]*-[\s]*',...
            '(?<BP_Nesting>[0-9]+)'],'names');
    case 'newSingle'
        FR3D_Struct=regexp(textfile,['"(?<PDBID1>[\w\d]{4})\|(?<ModelNum1>[\d]*)\|(?<BP1_Chain>[\w\d])',...
            '\|(?<BP1_Name>[\w\d]+)\|(?<BP1_Num>[\d]+)\|?(?<AtomName1>[\w\d]*)?',...
            '\|?(?<AltID1>[\w\d]*)?\|?(?<iCode1>[\w\d]*)?\|?(?<SymOp1>[\w\d]*)?","(?<BP_Type>[^,]+)"',...
            ',"(?<PDBID2>[\w\d]{4})\|(?<ModelNum2>[\d]*)\|(?<BP2_Chain>[\w\d])',...
            '\|(?<BP2_Name>[\w\d]+)\|(?<BP2_Num>[\d]+)\|?(?<AtomName2>[\w\d]*)?',...
            '\|?(?<AltID2>[\w\d]*)?\|?(?<iCode2>[\w\d]*)?\|?(?<SymOp2>[\w\d]*)?"'],...
            'names');
        for j = 1:length(FR3D_Struct)
            BP(j).Index=num2str(j);
            BP(j).BP1_Name=FR3D_Struct(j).BP1_Name;
            BP(j).BP1_Num=[FR3D_Struct(j).BP1_Num,FR3D_Struct(j).iCode1];
            BP(j).BP1_Chain=FR3D_Struct(j).BP1_Chain;
            BP(j).BP2_Name=FR3D_Struct(j).BP2_Name;
            BP(j).BP2_Num=[FR3D_Struct(j).BP2_Num,FR3D_Struct(j).iCode2];
            BP(j).BP2_Chain=FR3D_Struct(j).BP2_Chain;
            BP(j).BP_Type=FR3D_Struct(j).BP_Type;
        end
    case 'newCombined'
        FR3D_Struct=regexp(textfile,['"?(?<PDBID1>[\w\d]{4})\|(?<ModelNum1>[\d]*)\|(?<BP1_Chain>[\w\d]+)',...
            '\|(?<BP1_Name>[\w\d]+)\|(?<BP1_Num>[\d]+)\|?(?<AtomName1>[\w\d]*)?',...
            '\|?(?<AltID1>[\w\d]*)?\|?(?<iCode1>[\w\d]*)?\|?(?<SymOp1>[\w\d]*)?"?',...
            ',"?(?<BasePairType>[^,]*)"?,"?(?<BaseStackingType>[^,]*)"?,"?(?<BasePhosphateType>[^,]*)"?,"?(?<BaseRiboseType>[^,]*)"?',...
            ',"?(?<PDBID2>[\w\d]{4})\|(?<ModelNum2>[\d]*)\|(?<BP2_Chain>[\w\d]+)',...
            '\|(?<BP2_Name>[\w\d]+)\|(?<BP2_Num>[\d]+)\|?(?<AtomName2>[\w\d]*)?',...
            '\|?(?<AltID2>[\w\d]*)?\|?(?<iCode2>[\w\d]*)?\|?(?<SymOp2>[\w\d]*)?"?'],...
            'names');
        BPindex=0;
        for j = 1:length(FR3D_Struct)
            if ~isempty(FR3D_Struct(j).BasePairType)
                BPindex = BPindex + 1;
                BP(BPindex).Index=num2str(BPindex);
                BP(BPindex).BP1_Name=FR3D_Struct(j).BP1_Name;
                BP(BPindex).BP1_Num=[FR3D_Struct(j).BP1_Num,FR3D_Struct(j).iCode1];
                BP(BPindex).BP1_Chain=FR3D_Struct(j).BP1_Chain;
                BP(BPindex).BP2_Name=FR3D_Struct(j).BP2_Name;
                BP(BPindex).BP2_Num=[FR3D_Struct(j).BP2_Num,FR3D_Struct(j).iCode2];
                BP(BPindex).BP2_Chain=FR3D_Struct(j).BP2_Chain;
                BP(BPindex).BP_Type=FR3D_Struct(j).BasePairType;
            end
            if ~isempty(FR3D_Struct(j).BaseStackingType)
                BPindex = BPindex + 1;
                BP(BPindex).Index=num2str(BPindex);
                BP(BPindex).BP1_Name=FR3D_Struct(j).BP1_Name;
                BP(BPindex).BP1_Num=[FR3D_Struct(j).BP1_Num,FR3D_Struct(j).iCode1];
                BP(BPindex).BP1_Chain=FR3D_Struct(j).BP1_Chain;
                BP(BPindex).BP2_Name=FR3D_Struct(j).BP2_Name;
                BP(BPindex).BP2_Num=[FR3D_Struct(j).BP2_Num,FR3D_Struct(j).iCode2];
                BP(BPindex).BP2_Chain=FR3D_Struct(j).BP2_Chain;
                BP(BPindex).BP_Type=FR3D_Struct(j).BaseStackingType;
            end
            if ~isempty(FR3D_Struct(j).BasePhosphateType)
                BPindex = BPindex + 1;
                BP(BPindex).Index=num2str(BPindex);
                BP(BPindex).BP1_Name=FR3D_Struct(j).BP1_Name;
                BP(BPindex).BP1_Num=[FR3D_Struct(j).BP1_Num,FR3D_Struct(j).iCode1];
                BP(BPindex).BP1_Chain=FR3D_Struct(j).BP1_Chain;
                BP(BPindex).BP2_Name=FR3D_Struct(j).BP2_Name;
                BP(BPindex).BP2_Num=[FR3D_Struct(j).BP2_Num,FR3D_Struct(j).iCode2];
                BP(BPindex).BP2_Chain=FR3D_Struct(j).BP2_Chain;
                BP(BPindex).BP_Type=FR3D_Struct(j).BasePhosphateType;
            end
            if ~isempty(FR3D_Struct(j).BaseRiboseType)
                BPindex = BPindex + 1;
                BP(BPindex).Index=num2str(BPindex);
                BP(BPindex).BP1_Name=FR3D_Struct(j).BP1_Name;
                BP(BPindex).BP1_Num=[FR3D_Struct(j).BP1_Num,FR3D_Struct(j).iCode1];
                BP(BPindex).BP1_Chain=FR3D_Struct(j).BP1_Chain;
                BP(BPindex).BP2_Name=FR3D_Struct(j).BP2_Name;
                BP(BPindex).BP2_Num=[FR3D_Struct(j).BP2_Num,FR3D_Struct(j).iCode2];
                BP(BPindex).BP2_Chain=FR3D_Struct(j).BP2_Chain;
                BP(BPindex).BP_Type=FR3D_Struct(j).BaseRiboseType;
            end
        end
end
chain_list=unique({BP.BP1_Chain});
[~,datasetname]=fileparts(fred_text_file);
for i=1:length(chain_list)
    BP_Struct(i).Chain=chain_list{i};
    BP_Struct(i).Data=BP(ismember({BP.BP1_Chain},chain_list{i}));
    BP_Struct(i).Name=[datasetname,'_',chain_list{i}];
end

end
