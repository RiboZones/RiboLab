function [ BP_Struct ] = CT2BP( CT_file, RiboLabMap, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Assume single stranded for now. Assumes consecutive for now. Assume
%bases are all numbers.

WriteToFile=false();
index=0;

if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'WriteToFile'
                WriteToFile=varargin{2*ind};
        end
    end
end

textfile=fileread(CT_file);
ParsedText=regexp(textfile,'(?<BaseNumber>[\w\d]+) (?<Base>[\w]+) (?<PrevIndex>[\d]+) (?<NextIndex>[\d]+) (?<BasePaired>[\w\d]+) (?<NaturalNumber>[^\s]+)','names');
numBases=length(ParsedText);

[~,DataSetName]=fileparts(CT_file);
BP_Struct.Name=DataSetName;
BP_Struct.Chain='unknown';

b=str2num(char({ParsedText.BasePaired})); %#ok<ST2NM>
numBasePairs=sum(b>0); %This is double, will need DeDupping.


for i=1:numBases
    if ~strcmp(ParsedText(i).BasePaired,'0')
        BP_Struct.Data(index+1).Index=index+1;
        BP_Struct.Data(index+1).BP1_Name=ParsedText(i).Base;
        BP_Struct.Data(index+1).BP1_Num=regexprep(RiboLabMap.ItemNames{str2double(ParsedText(i).BaseNumber)},'_','');
        BP_Struct.Data(index+1).BP1_Chain='';
        BP_Struct.Data(index+1).BP2_Name=ParsedText(str2double(ParsedText(i).BasePaired)).Base;
        BP_Struct.Data(index+1).BP2_Num=regexprep(RiboLabMap.ItemNames{str2double(ParsedText(i).BasePaired)},'_','');
        BP_Struct.Data(index+1).BP2_Chain='';
        BP_Struct.Data(index+1).BP_Type='unkwn';
        index=index+1;
    end
end

BP_Struct=DeDupBP(BP_Struct);

if (WriteToFile)
    FR3D_Interaction_Tables=BP2Table(BP_Struct,'TableFormat','CustomData','ItemList',RiboLabMap.ItemNames,'Merge',false);
    fid=fopen([DataSetName,'_BasePairs','.csv'],'wt');
    for i=1:size(FR3D_Interaction_Tables{1},1);
        fprintf(fid, '%s,%s,%s,%s\n',FR3D_Interaction_Tables{1}{i,:});
    end
    fclose(fid);
end


end

% Names={'BasePairs','Stacking','BaseSugar','BasePhosphate'};
% for i=1:length(Names)
%     xlswrite([DataSetName_path,'\',get(handles.DataSetName,'String'),'_',Names{i},'.xlsx'],...
%         result.FR3D_Interaction_Tables{i}(:,1:4));
% end