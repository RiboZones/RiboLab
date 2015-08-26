function [ output_args ] =  Map3Dto2D(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

useFilteredMap=true();
% Species_ind=1;
% Subset_ind=1;
AtomFilterType='anything';
% cutoff=3.5;
UpdateFilteredMap=true();
MapbyVar=false();


if nargin >1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'Filtered'
                useFilteredMap=varargin{2*ind};
                %             case 'Species'
                %                 Species_ind=varargin{2*ind};
                %             case 'Subset'
                %                 Subset_ind=varargin{2*ind};
            case 'AtomFilterType'
                AtomFilterType=varargin{2*ind};
            case 'MapOverRide'
                NewMap=varargin{2*ind};
            case 'UpdateFilteredMap'
                UpdateFilteredMap=varargin{2*ind};
            case 'MapbyVar'
                MapbyVar=varargin{2*ind};
        end
    end
end


% if length(CADS_object) > 1
%     error('multiple datasets are not supported at this time. please loop separetely.')
% end

numDataSets=length(CADS_object);
for Pro_ind=1:numDataSets
    % disp(42)
    for Species_ind=1:length(CADS_object(Pro_ind).Map3D_2D)
        
        
        if useFilteredMap
            if UpdateFilteredMap
                CADS_object(Pro_ind).FilterMap(varargin{:});
            end
            Maps=CADS_object(Pro_ind).Results(Species_ind).FilteredMap;
        else
            Maps=CADS_object(Pro_ind).Results(Species_ind).Map;
        end
        
        for Subset_ind=1:length(Maps)
            if regexp(CADS_object(Pro_ind).Map3D_2D(Species_ind).ItemNames{1},'[\w]_')
                Contact_res=regexprep(unique(vertcat(Maps(Subset_ind).contacts{:})),'[\s]*','');
            else
                d=char(unique(vertcat(Maps(Subset_ind).contacts{:})));
                Contact_res=strtrim(cellstr(d(:,3:end)));
            end
            
            
            s=[strrep([CADS_object(Pro_ind).Name,'_',CADS_object(Pro_ind).Species{Species_ind},...
                '_',CADS_object(Pro_ind).Settings.Subsets.SubsetNames{Subset_ind}],' ','_'),'.eps'];
            if ~strcmpi(AtomFilterType,'anything')
                s=[s(1:end-4),'_',AtomFilterType,'.eps'];
            end
            
            file_name=strrep(s,':','');
            
            if MapbyVar
                BP=ContactMap2BP(CADS_object(Pro_ind));
                %            d=char(unique(vertcat(Maps(Subset_ind).contacts{:})));
                %            Contact_res=strtrim(cellstr(d(:,3:end)));
                [~,I]=ismember({BP.Data(:).BP1_Num}',CADS_object(Pro_ind).Keep(Species_ind).Alignment);
                Vars=CADS_object(Pro_ind).Results(Species_ind).Variability(I);
                [sortedVars,sortI]=sort(Vars);
                %             Procontacts={BP.Data(sortI).BP1_Num}';
                %             RNAcontacts={BP.Data(sortI).BP2_Num}';
                [Contact_res,sortRNA]=unique({BP.Data(sortI).BP2_Num}','first');
                ColorFlag={'ColorMode','gradient','VarInterest',{{-1*sortedVars(sortRNA),[-1*log2(20),0]}}};
                newvarargin=[ColorFlag{:},varargin{:}];
            else
                newvarargin=varargin;
            end
            
            if exist('NewMap','var')
                NewMap(Species_ind).PlotCoord('IncludeItems',Contact_res,...
                    'filename',file_name,newvarargin{:});
            else
                CADS_object(Pro_ind).Map3D_2D(Species_ind).PlotCoord('IncludeItems',Contact_res,...
                    'filename',file_name,newvarargin{:});
            end
        end
        
    end
end
end
