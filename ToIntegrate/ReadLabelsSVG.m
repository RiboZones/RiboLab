function [ All_Labels,Text_Labels,Line_Labels ] = ReadLabelsSVG(filename,LabelType,MapName,varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

SVGdata=fileread(filename);

%% Text labels
ParsedText=regexp(SVGdata,['<text( id="[^"]*")? transform="matrix\((?<transform>[\d|\s|\.]+)\)"',...
    '( fill="[^"]+")? font-family="''(?<font_family>[^'']+)''" font-size="(?<font_size>[^"]+)"',...
    '>(?<LabelText>[^<]+)</text>'],'tokens');


numTextLabels=length(ParsedText);
Text_Labels_Struct=repmat(struct('ItemName','','LabelText','','X','','Y','','Font','','FontSize','','FontColor',[0,0,0],'Fill','#000000'),numTextLabels,1);
for i=1:numTextLabels
    switch lower(LabelType)
        case 'helix'
            Text_Labels_Struct(i).ItemName=['H_',ParsedText{i}{6}];
        case 'residue'
            Text_Labels_Struct(i).ItemName=['R_',ParsedText{i}{6}];
        case 'domain'
            Text_Labels_Struct(i).ItemName=['D_',ParsedText{i}{6}];
        otherwise
            Text_Labels_Struct(i).ItemName=['O_',ParsedText{i}{6}];
    end
    Text_Labels_Struct(i).LabelText=ParsedText{i}{6};
    Matrix=str2num(ParsedText{i}{2}); %#ok<ST2NM>
    Text_Labels_Struct(i).X=Matrix(5);
    Text_Labels_Struct(i).Y=Matrix(6);
    Text_Labels_Struct(i).Font=ParsedText{i}{4};
    Text_Labels_Struct(i).FontSize=str2double(ParsedText{i}{5});
    if isempty(ParsedText{i}{3}) || ~isempty(strfind(ParsedText{i}{3},'none'))
        Text_Labels_Struct(i).FontColor=[0,0,0];
        Text_Labels_Struct(i).Fill='#000000';
    else
        Fillvar=ParsedText{i}{3}(9:14);
        Text_Labels_Struct(i).FontColor=[hex2dec(Fillvar(1:2)),hex2dec(Fillvar(3:4)),hex2dec(Fillvar(5:6))]/256;
        Text_Labels_Struct(i).Fill=ParsedText{i}{3}(8:14);
    end
end


%% Line Labels
% ParsedLines=regexp(SVGdata,['<line fill="(?<fill>[^"]*)"( stroke="(?<stroke>[^"]*)")?( stroke-width="(?<stroke_width>[^"]*)")?',...
%     '( stroke-linejoin="(?<stroke_linejoin>[^"]*)")?( stroke-miterlimit="(?<stroke_miterlimit>[^"]*)")?',...
%     ' x1="(?<x1>[^"]*)" y1="(?<y1>[^"]*)" x2="(?<x2>[^"]*)" y2="(?<y2>[^"]*)"/>\r\n'],'names');

ParsedLines=regexp(SVGdata,['<line( fill="[^"]*")?( stroke="[^"]*")?( stroke-width="[^"]*")?',...
    '( stroke-linejoin="[^"]*")?( stroke-miterlimit="[^"]*")?',...
    ' x1="(?<x1>[^"]*)" y1="(?<y1>[^"]*)" x2="(?<x2>[^"]*)" y2="(?<y2>[^"]*)"/>'],'tokens');



numLineLabels=length(ParsedLines);
Line_Labels_Struct=repmat(struct('Fill','','Stroke','#000000','Stroke_Color',[0,0,0],'Stroke_Width','1',...
    'Stroke_Linejoin','round','Stroke_Miterlimit','10','X1',[],'Y1',[],'X2',[],'Y2',[]),numLineLabels,1);

for j=1:numLineLabels
    Line_Labels_Struct(j).X1=str2double(ParsedLines{j}{6});
    Line_Labels_Struct(j).Y1=str2double(ParsedLines{j}{7});
    Line_Labels_Struct(j).X2=str2double(ParsedLines{j}{8});
    Line_Labels_Struct(j).Y2=str2double(ParsedLines{j}{9});

    if isempty(ParsedLines{j}{1})
        Line_Labels_Struct(j).Fill='#000000';
    else
        d=regexp(ParsedLines{j}{1},'"([^"]+)"','tokens');
        Line_Labels_Struct(j).Fill=d{1};
    end
    
    if ~isempty(ParsedLines{j}{2})
        Line_Labels_Struct(j).Stroke=ParsedLines{j}{2}(10:16);
        stroke=ParsedLines{j}{2}(11:16);
        Line_Labels_Struct(j).Stroke_Color=[hex2dec(stroke(1:2)),hex2dec(stroke(3:4)),hex2dec(stroke(5:6))]/256;
    end
    
    if ~isempty(ParsedLines{j}{3})
        Line_Labels_Struct(j).Stroke_Width=ParsedLines{j}{3}(16:end-1);
    end
    
    if ~isempty(ParsedLines{j}{4})
        Line_Labels_Struct(j).Stroke_Linejoin=ParsedLines{j}{4}(19:end-1);
    end
    if ~isempty(ParsedLines{j}{5})
        Line_Labels_Struct(j).Stroke_Miterlimit=ParsedLines{j}{5}(21:end-1);
    end
    
end

if isempty(MapName)
    Text_Labels=Text_Labels_Struct;
    Line_Labels=Line_Labels_Struct;
else
    if size(MapName.TextLabels) == 0
        [~,I]=unique({Text_Labels_Struct(:).LabelText});
        MapName.TextLabels=Text_Labels_Struct(I);
        Text_Labels=Text_Labels_Struct(I);
    else
        mergelabelsnames=[{MapName.TextLabels.ItemName},{Text_Labels_Struct.ItemName}];
        [~,I]=unique(mergelabelsnames);
        MergeLabels=vertcat(MapName.TextLabels,Text_Labels_Struct);
        MapName.TextLabels=MergeLabels(I);
        Text_Labels=MergeLabels(I);
    end
    MapName.LineLabels=vertcat(MapName.LineLabels,Line_Labels_Struct);
    Line_Labels=MapName.LineLabels;
end


All_Labels.Text=Text_Labels;
All_Labels.Line=Line_Labels;

