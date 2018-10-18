classdef Map2D < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name='un-named'
        ItemNames
        X
        Y
        Other
        TextLabels
        LineLabels
        FontSize
    end
    
    methods
        function map_object = Map2D(name,fullfilepath,varargin)
            if nargin > 0
                map_object.Name  = name;
            end
            if nargin > 1
                map_object.AddMap(fullfilepath,varargin{:});
                map_object.Transform(varargin{:});
                map_object.PlotCoord(varargin{:},'filename',[map_object.Name,...
                    '_Def.eps']);
                %                 map_object.CountourLine(varargin{:},'filename',[map_object.Name,...
                %                     '_Def_Contour.eps']);
            end
        end
        
        function AddMap(map_object,fullfilepath,varargin)
            height_fig=792;
            map_object.FontSize='3.9';
            moleculeName='23S';
            
            if nargin > 1
                for ind=1:length(varargin)/2
                    switch varargin{2*ind-1}
                        case 'height_fig'
                            height_fig=varargin{2*ind};
                        case 'DataPointNames'
                            DataPointNames=varargin{2*ind};
                        case 'FontSize'
                            map_object.FontSize=varargin{2*ind};
                        case 'LetterGroup'
                            LetterGroup=varargin{2*ind};
                        case 'moleculeName'
                            moleculeName=varargin{2*ind};
                    end
                end
            end
            
            [~,~,file_ext] = fileparts(fullfilepath);
            switch file_ext
                case '.csv'
                    textfile=fileread(fullfilepath);
                    ParsedText=regexp(textfile,'(?<ItemName>[\d\w]+),(?<Letter>\w),(?<X>[^,]+),(?<Y>[^,\s]+)','names');
                    numTextLabels=length(ParsedText);
                    Text_Labels_Struct=repmat(struct('ItemName','','LabelText','','X','','Y','','Font','MyriadPro-Regular','FontSize',num2str(map_object.FontSize),'FontColor',[0,0,0],'Fill','#000000'),numTextLabels,1);
                    
                    for i=1:numTextLabels
                        Text_Labels_Struct(i).Matrix=[1,0,0,1,str2double(ParsedText(i).X),str2double(ParsedText(i).Y)];
                        Text_Labels_Struct(i).X=Text_Labels_Struct(i).Matrix(5);
                        Text_Labels_Struct(i).Y=Text_Labels_Struct(i).Matrix(6);
                        Text_Labels_Struct(i).ItemName=ParsedText(i).ItemName;
                        Text_Labels_Struct(i).LabelText=ParsedText(i).Letter;
                    end
                    
                case '.xrna'
                    textfile=fileread(fullfilepath);
                    ParsedText=regexp(textfile,'(?<Letter>[ACGUT]) (?<X>[^\s]+) (?<Y>[^\s]+)','names');
                    numTextLabels=length(ParsedText);
                    Text_Labels_Struct=repmat(struct('ItemName','','LabelText','','X','','Y','','Font','MyriadPro-Regular','FontSize',num2str(map_object.FontSize),'FontColor',[0,0,0],'Fill','#000000'),numTextLabels,1);
                    
                    if exist('DataPointNames','var') && ischar(DataPointNames) && exist(DataPointNames,'file')
                        textfile=fileread(DataPointNames);
                        DataPointNames=regexp(textfile,'[\w]*','match');
                    end
                    
                    if ~exist('DataPointNames','var') || isempty(DataPointNames)
                        DataPointNames=strtrim(cellstr(num2str((1:numTextLabels)')));
                        DataPointNames=cellstr([repmat([moleculeName,':'],length(DataPointNames),1),char(DataPointNames)]);

                    end
                    
                    for i=1:numTextLabels
                        Text_Labels_Struct(i).Matrix=[1,0,0,1,str2double(ParsedText(i).X),str2double(ParsedText(i).Y)];
                        Text_Labels_Struct(i).X=Text_Labels_Struct(i).Matrix(5);
                        Text_Labels_Struct(i).Y=Text_Labels_Struct(i).Matrix(6);
                        Text_Labels_Struct(i).ItemName=DataPointNames{i};
                        Text_Labels_Struct(i).LabelText=ParsedText(i).Letter;
                        Text_Labels_Struct(i).Letter=Text_Labels_Struct(i).LabelText;
                    end
                    
                    
                case '.svg'
                    SVGdata=fileread(fullfilepath);
                    if exist('LetterGroup','var')
                        D=regexp(SVGdata,['<g id="',LetterGroup,'">((?!</g>).)*'],'tokens');
                        SVGdata=D{1}{1};
                    end
                    ParsedText=regexp(SVGdata,['<text( id="[^"]*")? transform="matrix\((?<transform>[\d|\s|\.]+)\)" ',...
                        'fill="(?<fill>[^"]+)" font-family="''?(?<font_family>[^''"]+)''?" font-size="(?<font_size>[^"]+)"',...
                        '>(?<LabelText>[ACUG])</text>'],'tokens');
                    numTextLabels=length(ParsedText);
                    Text_Labels_Struct=repmat(struct('ItemName','','LabelText','','X','','Y','','Font','','FontSize','','FontColor',[0,0,0],'Fill','#000000'),numTextLabels,1);
                    
                    
                    if exist('DataPointNames','var') && ischar(DataPointNames) && exist(DataPointNames,'file')
                        textfile=fileread(DataPointNames);
                        DataPointNames=regexp(textfile,'[\w]*','match');
                    end
                    
                    if ~exist('DataPointNames','var')|| isempty(DataPointNames)
                        DataPointNames=strtrim(cellstr(num2str((1:numTextLabels)')));
                    end
                    
                    for i=1:numTextLabels
                        Text_Labels_Struct(i).Matrix=str2num(ParsedText{i}{2}); %#ok<ST2NM>
                        Text_Labels_Struct(i).X=Text_Labels_Struct(i).Matrix(5) + 1.262;               %Correction for font 3.9
                        Text_Labels_Struct(i).Y=height_fig-Text_Labels_Struct(i).Matrix(6) + 1.1445;   %Correction for font 3.9
                        Text_Labels_Struct(i).ItemName=DataPointNames{i};
                        Text_Labels_Struct(i).LabelText=ParsedText{i}{6};
                        Text_Labels_Struct(i).Letter=Text_Labels_Struct(i).LabelText;
                        Text_Labels_Struct(i).Font=ParsedText{i}{4};
                        Text_Labels_Struct(i).FontSize=str2double(ParsedText{i}{5});
                        fill=ParsedText{i}{3}(2:end);
                        if strcmp(fill,'none') || isempty(fill)
                            Text_Labels_Struct(i).FontColor=[0,0,0];
                        else
                            Text_Labels_Struct(i).FontColor=[hex2dec(fill(1:2)),hex2dec(fill(3:4)),hex2dec(fill(5:6))]/256;
                        end
                        Text_Labels_Struct(i).Fill=ParsedText{i}{3};
                    end
            end
            
            map_object.AddMapStruct(Text_Labels_Struct);
        end
        
        function AddMapStruct(map_object,DataStruct)
            map_object.ItemNames={DataStruct(:).ItemName}';
            map_object.X=[DataStruct(:).X]';
            map_object.Y=[DataStruct(:).Y]';
            map_object.Other=DataStruct;
            
        end
        
        function ResidueList = AddMapStructureFile(map_object,file_name,MoleculeChainMap)
            %MapData=importdata(file_name);
%             fid=fopen(file_name,'r','n','UTF-8');
%             MapData=textscan(fid,'%s %s %s %s','delimiter',',');
%             fclose(fid);
            MapData = readtable(file_name);
            numDataPoints=size(MapData,1);
            map_object.ItemNames=cell(numDataPoints,1);
            map_object.X=zeros(numDataPoints,1);
            map_object.Y=zeros(numDataPoints,1);
            map_object.FontSize=MapData.FontSize(1);
            for i=1:numDataPoints
                mol_name=regexp(MapData.resNum{i},'([^:]+):','tokens');
                if strcmp(mol_name{1}{1},'5.8S')
                    chainID=MoleculeChainMap.(['mol_','5p8S']);
                elseif (length(mol_name{1}{1})==5 &&  sum(unicode2native(mol_name{1}{1})==[97 82 78 65 26])==5)
                    chainID=MoleculeChainMap.(['mol_','aRNAg']);
                else
                    chainID=MoleculeChainMap.(['mol_',regexprep(mol_name{1}{1},'-','_')]);
                end
                map_object.ItemNames{i}=regexprep(MapData.resNum{i},'([^:]+):',[chainID,'_']);
                map_object.X(i)=MapData.X(i);
                map_object.Y(i)=MapData.Y(i);
                map_object.Other(i,1).Letter=MapData.unModResName{i};
            end
            ResidueList = MapData.resNum;
        end
        
        function Transform(map_object,varargin)
            molecule='23S';
            %             alignResi='562';
            scale_fact=0.5;
            noTransform=false();
            
            if nargin > 1
                for ind=1:length(varargin)/2
                    switch varargin{2*ind-1}
                        case 'molecule'
                            molecule=varargin{2*ind};
                            
                        case 'alignResi'
                            alignResi=varargin{2*ind};
                        case 'toPos'
                            toPos=varargin{2*ind};
                        case 'scale_fact'
                            scale_fact=varargin{2*ind};
                        case 'noTransform'
                            noTransform=varargin{2*ind};
                    end
                end
            end
            
            if noTransform
                return
            end
            
            if ~exist('toPos','var')
                switch lower(molecule)
                    case '23s'
                        toPos=[356.5340,408.675];
                    case '16s'
                        toPos=[312.96,379.8110];
                    case '5s'
                        toPos=[106.226,198.2240];
                end
            end
            
            if ~exist('alignResi','var')
                switch lower(molecule)
                    case '23s'
                        alignResi='562';
                    case '16s'
                        alignResi='1400';
                    case '5s'
                        alignResi='20';
                end
            end
            map_object.X=map_object.X*scale_fact;
            map_object.Y=map_object.Y*scale_fact;
            
            [~,I]=ismember(alignResi,map_object.ItemNames);
            map_object.X=map_object.X + (toPos(1) - map_object.X(I));
            map_object.Y=map_object.Y + (toPos(2) - map_object.Y(I));
            
        end
        
        function TransformAuto(map_object)
            map_object.X=map_object.X + (1.2615);
            map_object.Y=map_object.Y + (1.1447);
        end
        
        function ContourLine(map_object,varargin)
            map_object.PlotCoord('shape','contour','x_corr',-.442,'y_corr',1.27,varargin{:}); %% Not sure what causes the need for these corrections.
        end
        
        function PrintCoord(map_object,IncludeItems)
            if nargin > 1
                [~,I]=ismember(IncludeItems,map_object.ItemNames);
                disp([map_object.X(I),map_object.Y(I)])
            else
                disp([map_object.X,map_object.Y])
            end
        end
        
        function Coord=GetCoord(map_object,IncludeItems)
            if nargin > 1
                numPoints=size(IncludeItems,2);
                Coord=cell(numPoints,1);
                
                for j=1:numPoints
                    %                 Keep=false(length(map_object.ItemNames),1);
                    [~,II]=ismember(IncludeItems(:,j),map_object.ItemNames);
                    Keep=II;
                    Keep(Keep==0)=[];
                    if Keep==0
                        Coord{j}=[];
                        
                    else
                        Coord{j}=[map_object.X(Keep),map_object.Y(Keep)];
                    end;
                end
            else
                Coord=[map_object.X,map_object.Y];
            end
        end
        function toStructureFile(myMap)
            fid=fopen([myMap.Name,'_StructureFile','.csv'],'wt');
            
            fprintf(fid, '%s,%s,%s,%s\n','resNum','resName','X','Y');
            for j=1:length(myMap.ItemNames);
                fprintf(fid, '%s,%s,%s,%s\n',myMap.ItemNames{j},...
                    myMap.Other(j).LabelText,num2str(myMap.X(j)),num2str(792-myMap.Y(j)));
            end
            fclose(fid);
            
        end
        function [Table]=BasicTable(myMap,ResidueList)
            
            %             startIndex=0;
            numResi=length(vertcat(myMap.ItemNames));
            
            Table=cell(numResi,7);
            Table(:,1)=num2cell(1:numResi);
            if nargin > 1
                split=regexp(ResidueList,':','split');
            else
                split=regexp(ResidueList,'_','split');
            end
            v=vertcat(split{:});
            Table(:,2)=v(:,1);
            Table(:,3)=v(:,2);
            if isfield(myMap.Other,'Letter')
                Table(:,4)={myMap.Other.Letter}';
                Table(:,5)={myMap.Other.Letter}';
            else
                Table(:,4)={myMap.Other.LabelText}';
                Table(:,5)={myMap.Other.LabelText}';
            end
            %Table(:,5)=vertcat(regexprep(myMap.ItemNames,'_[\w\d]+',''));
           % d=regexp(unique(UniqueResSeq),'(.+)_[\s]*([\w]+)','tokens');
            %d=[d{:}];
            %residue_Chain_list=vertcat(d{:});
           % residue_list=residue_Chain_list(:,2);
           % xtalindex=1:length(residue_list);
           % if strfind(myMap.ItemNames{end},'_')>0
           %     residue_list=strcat(residue_Chain_list(:,1),'_',...
            %        residue_Chain_list(:,2));
            %end
            %[inMap,I]=ismember(residue_list,myMap.ItemNames);
            %[~,II]=sort(I(I~=0));
            %r=residue_list(inMap);
            %[~,III]=ismember(r(II),myMap.ItemNames);
            
            
            %xtal_index=cell(length(myMap.ItemNames),1);
            %xtal_index(III)=num2cell(xtalindex(II));
            Table(:,6)=num2cell(myMap.X);
            Table(:,7)=num2cell(myMap.Y);
            %Table(:,8)=xtal_index;
            
        end
        
        function [All_Table,TextTable,LineTable]=TableLabels(map_object,varargin)
            
            numTextLabels=length(map_object.TextLabels);
            TextTable=cell(numTextLabels,6);
            TextTable(:,1)={map_object.TextLabels(:).LabelText};
            TextTable(:,2)={map_object.TextLabels(:).X};
            TextTable(:,3)={map_object.TextLabels(:).Y};
            TextTable(:,4)={map_object.TextLabels(:).Font};
            TextTable(:,5)={map_object.TextLabels(:).FontSize};
            TextTable(:,6)={map_object.TextLabels(:).Fill};
            
            numLineLabels=length(map_object.LineLabels);
            LineTable=cell(numLineLabels,9);
            LineTable(:,1)={map_object.LineLabels(:).X1};
            LineTable(:,2)={map_object.LineLabels(:).Y1};
            LineTable(:,3)={map_object.LineLabels(:).X2};
            LineTable(:,4)={map_object.LineLabels(:).Y2};
            LineTable(:,5)={map_object.LineLabels(:).Fill};
            LineTable(:,6)={map_object.LineLabels(:).Stroke};
            LineTable(:,7)={map_object.LineLabels(:).Stroke_Width};
            LineTable(:,8)={map_object.LineLabels(:).Stroke_Linejoin};
            LineTable(:,9)={map_object.LineLabels(:).Stroke_Miterlimit};
            
            All_Table.Text=TextTable;
            All_Table.Line=LineTable;
            
        end
        
        function PlotLabels(map_object,varargin)
            width_fig=612;
            height_fig=792;
            Orientation='portrait';
            
            width_shape=10;
            height_shape=10;
            
            
            
            
            if nargin > 1
                for ind=1:length(varargin)/2
                    switch varargin{2*ind-1}
                        case 'Orientation'
                            Orientation=varargin{2*ind};
                    end
                end
            end
            
            
            
            
            
            if strcmpi(Orientation,'landscape')
                if width_fig < height_fig
                    old_width_fig=width_fig;
                    width_fig=height_fig;
                    height_fig=old_width_fig;
                end
            end
            %             x_corr=0;
            %             y_corr=0;
            
            numLabels=length(map_object.TextLabels);
            h=figure();
            set(h,'Units','points')
            set(h,'Position',[2200,-50,width_fig,height_fig])
            
            for i=1:numLabels
                Ah{i}=annotation('textbox',[(map_object.TextLabels(i).X)/width_fig,...
                    (height_fig-map_object.TextLabels(i).Y)/height_fig,width_shape/width_fig,...
                    height_shape/height_fig],'String',map_object.TextLabels(i).LabelText,'LineStyle',...
                    'none','Margin',0,'HorizontalAlignment','center',...
                    'VerticalAlignment','bottom','FontSize',map_object.TextLabels(i).FontSize,...
                    'Color',map_object.TextLabels(i).FontColor);
            end
            %             map_object.PlotCoord('shape','text')
        end
        
        function PlotCoord(map_object,varargin)
            width_fig=612;
            height_fig=792;
            width_shape=3.333;
            height_shape=3.333;
            LetterHeight=4.239;
            %             TextLabels=map_object.ItemNames;
            IncludeItems=map_object.ItemNames;
            NewFontSize=8;
            shape='ellipse';
            Orientation='portrait';
            ColorMapType='jet';
            ColorMode='MonoChrome';
            EnableColorBar=true();
            MaxItems=500;
            %             ColorValue=[1,1,1];
            %             ColorMapIndex=1;
            
            if nargin > 1
                for ind=1:length(varargin)/2
                    switch varargin{2*ind-1}
                        case 'EnableColorBar'
                            EnableColorBar=varargin{2*ind};
                        case 'width_fig'
                            width_fig=varargin{2*ind};
                        case 'height_fig'
                            height_fig=varargin{2*ind};
                        case 'width_shape'
                            width_shape=varargin{2*ind};
                        case 'height_shape'
                            height_shape=varargin{2*ind};
                        case 'LetterHeight'
                            LetterHeight=varargin{2*ind};
                        case 'x_corr'
                            x_corr=varargin{2*ind};
                        case 'y_corr'
                            y_corr=varargin{2*ind};
                        case 'shape'
                            shape=varargin{2*ind};
                            %                         case 'TextLabels'
                            %                             TextLabels=varargin{2*ind};
                        case 'IncludeItems'
                            IncludeItems=varargin{2*ind};
                        case 'LineWidth'
                            LineWidth=varargin{2*ind};
                        case 'DesiredFontSize'
                            NewFontSize=varargin{2*ind};
                        case 'filename'
                            file_name=varargin{2*ind};
                        case 'Orientation'
                            Orientation=varargin{2*ind};
                        case 'ColorMap'
                            ColorMapType=varargin{2*ind};
                        case 'ColorMode'
                            ColorMode=varargin{2*ind};
                        case 'ColorValue'
                            ColorValue=varargin{2*ind};
                        case 'ColorMapIndex'
                            ColorMapIndex=varargin{2*ind};
                        case 'VarInterest'
                            if iscell(varargin{2*ind})
                                VarInterest=varargin{2*ind}{1};
                                m=varargin{2*ind}{2};
                            else
                                VarInterest=varargin{2*ind};
                                m=minmax(VarInterest);
                            end
                            GradientMap=round(63*(VarInterest - m(1))/(m(2)-m(1)) + 1);
                        case 'MaxItems'
                            MaxItems=varargin{2*ind};
                    end
                end
            end
            
            if strcmpi(Orientation,'landscape')
                if width_fig < height_fig
                    old_width_fig=width_fig;
                    width_fig=height_fig;
                    height_fig=old_width_fig;
                end
            end
            
            switch shape
                case {'line','contour'}
                    width_shape=0;
                    height_shape=0;
            end
            
            
            
            if ~exist('x_corr','var')
                switch Orientation
                    case 'landscape'
                        x_corr=-0.6620-width_shape/2; % (old map, new way)
                    case 'portrait'
                        x_corr=-.965-width_shape/2; % (New map)
                end
            end
            
            if ~exist('y_corr','var')
                switch Orientation
                    case 'landscape'
                        y_corr= 0.9-height_shape/2;
                    case 'portrait'
                        y_corr=1.8-height_shape/2 ;
                end
            end
            
            numPoints=size(IncludeItems,2);
            if ~numPoints
                return
            end
            Coord=cell(numPoints,1);
            
            for j=1:numPoints
                %                 Keep=false(length(map_object.ItemNames),1);
                [inMap,II]=ismember(IncludeItems(:,j),map_object.ItemNames);
                Keep=II;
                Keep(Keep==0)=[];
                if Keep==0
                    Coord{j}=[];
                    
                else
                    Coord{j}=[map_object.X(Keep),map_object.Y(Keep)];
                end
                %Worry about 0 indices later
                
            end
            Ah=cell(size(Keep,1),1);
            if ~exist('LineWidth','var')
                LineWidth=0.5*ones(size(Keep,1),1);
            end
            
            %Figure Out Color
            seleColor=cell(size(Coord{1},1),1);
            h1=figure();
            ColorMap=colormap(ColorMapType);
            switch lower(ColorMode)
                
                case 'monochrome'
                    if exist('ColorValue','var')
                        seleColor=repmat({ColorValue},size(Coord{1},1),1);
                    elseif exist('ColorMapIndex','var')
                        if isnan(ColorMapIndex)
                            seleColor=repmat({[0,0,0]},size(Coord{1},1),1);
                        else
                            seleColor=repmat({ColorMap(ColorMapIndex,:)},size(Coord{1},1),1);
                        end
                    else
                        seleColor=repmat({[0,0,0]},size(Coord{1},1),1);
                    end
                case 'gradient'
                    if ~exist('GradientMap','var')
                        
                        seleColor=mat2cell(ColorMap(round(colon(1,63/(size(Coord{1},1)-1),64)),:),...
                            ones(size(Coord{1},1),1));
                    else
                        if size(GradientMap,2) > size(Coord{1},1)
                            GradientMap=GradientMap(1,inMap);
                        end
                        seleColor=mat2cell(ColorMap(GradientMap,:),...
                            ones(size(Coord{1},1),1));
                        
                    end
                    
            end
            
            
            d=[Coord{:}];
            if size(d,2)==2
                [~,~,J]=unique(d,'rows');
                LineRows=d(sort(J),:);
            elseif size(d,2)==4
                LineRows=d(sum(d==d(:,[3,4,1,2]),2)~=4,:);
            else
                error('What???')
            end
            
            if strcmp(shape,'contour')
                LineRows=[map_object.X(1:end-1),map_object.Y(1:end-1),map_object.X(2:end),map_object.Y(2:end)];
            end
            
            numSets=ceil(size(LineRows,1)/MaxItems);
            h=zeros(numSets,1);
            
            if ~exist('file_name','var')
                file_name='foo.eps';
            end
            if iscell(file_name)
                file_name=[file_name{:}];
            end
            [epspath,epsfile,epsext]=fileparts(file_name);
            if numSets > 1
                epspath=fullfile(epspath,epsfile);
                mkdir(epspath);
            end
            
            for setnum=1:numSets
                if setnum==1
                    h(1)=h1;
                else
                    h(setnum)=figure();
                end
                set(h(setnum),'Units','points')
                set(h(setnum),'Position',[2200,-50,width_fig,height_fig])
                
                if EnableColorBar && exist('GradientMap','var') && strcmpi(ColorMode,'gradient') %other logic
                    hc=colorbar();
                    ColorMap2=((m(1):(m(2)-m(1))*0.2:m(2))-m(1))/(m(2)-m(1))*63+1;
                    %     num2str(round(10*(m(1):(m(2)-m(1))*0.2:m(2)))'/10);
                    set(hc,'YTickLabel',num2str(round(10*(m(1):(m(2)-m(1))*0.2:m(2)))'/10))
                    set(hc,'YTick',ColorMap2)
                end
                
                if setnum==numSets
                    seleset=MaxItems*(setnum-1)+1:size(LineRows,1);
                else
                    seleset=MaxItems*(setnum-1)+1:MaxItems*setnum;
                end
                
                for i=seleset
                    switch shape
                        case {'ellipse','rectangle'}
                            for j=1:length(LineRows(i,:))/2
                                annotation(shape,'Position',[(LineRows(i,2*j-1)+x_corr)/width_fig,...
                                    (LineRows(i,2*j)+y_corr)/height_fig,width_shape/width_fig,...
                                    height_shape/height_fig],'LineWidth',LineWidth(i),...
                                    'Color',seleColor{i});
                            end
                        case 'line'
                            Ah{i}=annotation(shape,[(LineRows(i,1)+x_corr)/width_fig,...
                                (LineRows(i,3)+x_corr)/width_fig],[(LineRows(i,2)+y_corr)/height_fig,...
                                (LineRows(i,4)+y_corr)/height_fig],'LineWidth',LineWidth(i),...
                                'Color',seleColor{i});
                        case 'contour'
                            Ah{i}=annotation('line',[(LineRows(i,1)+x_corr)/width_fig,...
                                (LineRows(i,3)+x_corr)/width_fig],[(LineRows(i,2)+y_corr)/height_fig,...
                                (LineRows(i,4)+y_corr)/height_fig],'LineWidth',2.7);
                        case 'text'
                            FontSizeCorrFact=1-NewFontSize/8;
                            Ah{i}=annotation('textbox',[(Coord{1}(i,1)+x_corr + FontSizeCorrFact*width_shape/2 )/width_fig,...
                                (Coord{1}(i,2)+y_corr + FontSizeCorrFact*height_shape)/height_fig,width_shape/width_fig,...
                                height_shape/height_fig],'String',TextLabels{i},'LineStyle',...
                                'none','Margin',0,'HorizontalAlignment','center',...
                                'VerticalAlignment','bottom','FontSize',8,...
                                'Color',seleColor{i});
                    end
                end
                %print('-deps ','-zbuffer',file_name)
                
                try
                    if numSets > 1
                        hgexport(h(setnum), fullfile(epspath,[epsfile,'_set',num2str(setnum),epsext]));
                    else
                        hgexport(h(setnum), fullfile(epspath,[epsfile,epsext]));
                    end
                catch
                    if numSets > 1
                        hgexport(h(setnum), fullfile(epspath,[epsfile,'_set',num2str(setnum),epsext]));
                    else
                        hgexport(h(setnum), fullfile(epspath,[epsfile,epsext]));
                    end
                end
            end
            
        end
        
        [ Map ] = PDBentry2Map2D(PDBEntry, PDBEntry_Target,map_object,varargin)
    end
    
end

