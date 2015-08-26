function Plot2DMap(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

PlotMode='definitions';
FilterMode='all';

if nargin > 1
    for ind=1:length(varargin)/2
        switch lower(varargin{2*ind-1})
            case 'plotmode'
                PlotMode=varargin{2*ind};
            case 'bpstruct'
                BP=varargin{2*ind};
            case '2'
                PlotSymbols=varargin{2*ind};
            case '3'
                SubsetMode=varargin{2*ind};
            case 'filtermode'
                FilterMode=varargin{2*ind};
        end
    end
end

numCads=length(CADS_object);
switch PlotMode
    case 'definitions'
        for cads_ind=1:numCads
            numSpecies=length(CADS_object(cads_ind).Map3D_2D);
            for Species_ind=1:numSpecies
                numSubsets=length(CADS_object(cads_ind).Subsets);
                for Subset_ind=1:numSubsets
                    file_name=[CADS_object(cads_ind).Name,'_',...
                        CADS_object(cads_ind).Species{Species_ind},'_',...
                        CADS_object(cads_ind).Settings.Subsets.SubsetNames{Subset_ind},...
                        '_definition.eps'];
                    CADS_object(cads_ind).Map3D_2D(Species_ind).PlotCoord('IncludeItems',...
                        CADS_object(cads_ind).ItemNames(CADS_object(cads_ind).Subsets{Subset_ind}),...
                        'filename',file_name,varargin{:});
                end
            end
        end
        
    case 'BP'
        for cads_ind=1:numCads
            numSpecies=length(CADS_object(cads_ind).Map3D_2D);
            for Species_ind=1:numSpecies
                numSubsets=length(CADS_object(cads_ind).Subsets);
                for Subset_ind=1:numSubsets
                    file_name=[CADS_object(cads_ind).Name,'_',...
                        CADS_object(cads_ind).Species{Species_ind},'_',...
                        CADS_object(cads_ind).Settings.Subsets.SubsetNames{Subset_ind},...
                        '_',FilterMode,'_BasePairs.eps'];
                    
                    if ~exist('BP','var')
                       BP=ContactMap2BP(CADS_object(cads_ind),varargin{:}); 
                    end
                    PlotBP(BP,CADS_object(cads_ind).Map3D_2D(Species_ind),...
                        'IncludeItems',CADS_object(cads_ind).ItemNames(CADS_object(cads_ind).Subsets{Subset_ind}),...
                        'filename',file_name,varargin{:})
                    
                end
            end
        end
    case 'Stacking'
        for cads_ind=1:numCads
            numSpecies=length(CADS_object(cads_ind).Map3D_2D);
            for Species_ind=1:numSpecies
                numSubsets=length(CADS_object(cads_ind).Subsets);
                for Subset_ind=1:numSubsets
                    file_name=[CADS_object(cads_ind).Name,'_',...
                        CADS_object(cads_ind).Species{Species_ind},'_',...
                        CADS_object(cads_ind).Settings.Subsets.SubsetNames{Subset_ind},...
                        '_',FilterMode,'_Stacking.eps'];
                    
                    PlotBP(BP,CADS_object(cads_ind).Map3D_2D(Species_ind),...
                        'IncludeItems',CADS_object(cads_ind).ItemNames(CADS_object(cads_ind).Subsets{Subset_ind}),...
                        'filename',file_name,varargin{:})
                    
                end
            end
        end
    case 'ContactMap'
        for cads_ind=1:numCads
            numSpecies=length(CADS_object(cads_ind).Map3D_2D);
            
            
            for Species_ind=1:numSpecies
                BP=ContactMap2BP(CADS_object(cads_ind),'Species',Species_ind,varargin{:});
                
                numSubsets=length(CADS_object(cads_ind).Subsets);
                for Subset_ind=1:numSubsets
                    file_name=[CADS_object(cads_ind).Name,'_',...
                        CADS_object(cads_ind).Species{Species_ind},'_',...
                        CADS_object(cads_ind).Settings.Subsets.SubsetNames{Subset_ind},...
                        '_',FilterMode,'_ContactMap'];
                    
                    
%                     d=vertcat(CADS_object.Results(Species_ind).FilteredMap.Y{:,3});
                    TrimmedNames=cell(size(CADS_object.Results(Species_ind).FilteredMap(Subset_ind).Y,1));
                    for i=1:size(CADS_object.Results(Species_ind).FilteredMap(Subset_ind).Y,1)
                        TrimmedNames{i}=cellstr(CADS_object.Results(Species_ind).FilteredMap(Subset_ind).Y{i,3}(:,5:end));
                    end
                    
                        wholeset=CADS_object(cads_ind).ItemNames(CADS_object(cads_ind).Subsets{Subset_ind});
                        CADS_object(cads_ind).Map3D_2D(Species_ind).PlotCoord('IncludeItems',...
                            intersect(wholeset,unique(strtrim(vertcat(TrimmedNames{:})))),...
                            'shape','ellipse','filename',[file_name,'_Dots.eps']);
                        
                    if isstruct(BP)
                        numRealPairs=length(str2num(char({BP.Data.Index}))); %#ok<ST2NM>
                        BP(1).Data=BP(1).Data(1:numRealPairs);
                        PlotBP(BP,CADS_object(cads_ind).Map3D_2D(Species_ind),...
                            'IncludeItems',CADS_object(cads_ind).Target(Species_ind).ItemNames(CADS_object(cads_ind).Subsets{Subset_ind}),...
                            'filename',[file_name,'.eps'],'PlotDots',false(),varargin{:})
                        
                    else
                        
                    end
                    
                end
            end
        end
        
        
end

end

