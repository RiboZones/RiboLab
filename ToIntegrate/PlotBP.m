function [KeepRows,FilteredBP]=PlotBP(BP,Map3D_2D,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numModels=length(BP);
FilterMode='all';
DistCutoff=12;
PlotDots='combined';
remove_varargin=false(1,length(varargin));
DisplayPlots=true();

if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'FilterMode'
                FilterMode=varargin{2*ind};
            case 'DistCutoff'
                DistCutoff=varargin{2*ind};
            case 'IncludeItems'
                IncludeItems=varargin{2*ind};
                remove_varargin(2*ind)=true;
                remove_varargin(2*ind - 1)=true;
            case 'filename'
                file_name=varargin{2*ind};
                remove_varargin(2*ind)=true;
                remove_varargin(2*ind - 1)=true;
            case 'PlotDots'
                PlotDots=varargin{2*ind};
            case 'DisplayPlots'
                DisplayPlots=varargin{2*ind};
                
        end
    end
end
varargin(remove_varargin)=[];

if isempty(Map3D_2D)
    DisplayPlots=false();
end

Coord=cell(numModels,1);
ColorIndices=round(colon(1,63/(numModels-1),64));
FilteredBP=BP;
for i=1:numModels
    switch FilterMode
        case 'all'
            KeepRes=true(1,length(BP(i).Data));
        case 'above'
            Coord{i}=Map3D_2D(i).GetCoord(strtrim({BP(i).Data.BP1_Num;BP(i).Data.BP2_Num}'));
            d=sqrt(sum((Coord{i}{1}-Coord{i}{2}).^2,2));
            KeepRes= d >= DistCutoff;
        case 'below'
            Coord{i}=Map3D_2D(i).GetCoord(strtrim({BP(i).Data.BP1_Num;BP(i).Data.BP2_Num}'));
            d=sqrt(sum((Coord{i}{1}-Coord{i}{2}).^2,2));
            KeepRes= d < DistCutoff;
    end
    
    KeepRows=KeepRes;
    if sum(KeepRes) > 0
        
        if DisplayPlots
            if strcmp(Map3D_2D.ItemNames{end}(2),'_')
                PairedItems=[strcat({BP(i).Data(KeepRes).BP1_Chain},{'_'},{BP(i).Data(KeepRes).BP1_Num});...
                    strcat({BP(i).Data(KeepRes).BP2_Chain},{'_'},{BP(i).Data(KeepRes).BP2_Num})]';
            else
                PairedItems=strtrim({BP(i).Data(KeepRes).BP1_Num;BP(i).Data(KeepRes).BP2_Num}');
            end
            
            if exist('IncludeItems','var')
                inSet=ismember(PairedItems,IncludeItems);
                KeepRows=inSet(:,1) & inSet(:,2);
            else
                KeepRows=true(size(PairedItems,1),1);
            end
            if exist('file_name','var')
                filename=[file_name(1:end-4),'_',FilterMode,'_Lines.eps'];
                filenameDots=[file_name(1:end-4),'_',FilterMode,'_Dots.eps'];
            else
                filename=[BP(i).Name,'_',BP(i).Chain,'_',Map3D_2D.Name,'_',FilterMode,'_Lines.eps'];
                filenameDots=[BP(i).Name,'_',BP(i).Chain,'_',Map3D_2D.Name,'_',FilterMode,'_Dots.eps'];
            end
            Map3D_2D(i).PlotCoord('IncludeItems',PairedItems(KeepRows,:),...
                'shape','line','filename',filename,'ColorMapIndex',ColorIndices(i),...
                varargin{:});
            switch PlotDots
                case 'combined'
                    Map3D_2D(i).PlotCoord('IncludeItems',PairedItems(KeepRows,:),...
                        'shape','ellipse','filename',filenameDots,'ColorMapIndex',...
                        ColorIndices(i),varargin{:});
                case 'split'
                    for j=1:size(PairedItems,2)
                        Map3D_2D(i).PlotCoord('IncludeItems',PairedItems(KeepRows,j),...
                            'shape','ellipse','filename',[filenameDots(1:end-4),'_Set',num2str(j),'.eps'],...
                            'ColorMapIndex',ColorIndices(i),varargin{:});
                    end
                    
            end
        end
    end
    
    FilteredBP(i).Data=FilteredBP(i).Data(KeepRes);
    FilteredBP(i).Data=FilteredBP(i).Data(KeepRows);
    
end

end

