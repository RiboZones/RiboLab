function Analyze(CADS_object,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%DisplayPlots=true();

if isempty(CADS_object(1).Settings)
    Settings.Onion.NewCenter=[-32.3240,123.0920,161.9990];
    Settings.Onion.ShellBoundaries=[0, 20+realmin,40+realmin,60+realmin,80+realmin,...
        100+realmin,120+realmin,140+realmin,Inf];
    Settings.Onion.VariabilityBins='standard';
    
    Settings.Alignment.EntropyMethod='Shannon';
    Settings.Alignment.Classes=[];
    Settings.Alignment.Gaps=false();
    Settings.Alignment.Gap_mode='ignore';
    Settings.Alignment.Ambiguous='Prorate';
    Settings.Alignment.Normalize=false();
    Settings.Alignment.P21_frac='n/a';
    
    Settings.Structure.ContactCutoff=3.4;
    Settings.Structure.RMSEmethod='C-alpha';
    Settings.Structure.SkipFilterMap=false();
    
    Settings.Subsets.Combined=true();
    Settings.Subsets.VariableNames='Variability';
    Settings.Subsets.VariableValues={};
    Settings.Subsets.DisplayPlots=false();
    Settings.Subsets.SubsetNames={};
    
else
    Settings=CADS_object.Settings;
    if ~isfield(Settings.Alignment,'Classes')
        Settings.Alignment.Classes=[];
    end
    if ~isfield(Settings.Alignment,'EntropyMethod')
        Settings.Alignment.EntropyMethod='Shannon';
    end
end
if nargin >1
    for ind=1:length(varargin)/2
        switch lower(varargin{2*ind-1})
            case 'newcenter'
                Settings.Onion.NewCenter=varargin{2*ind};
            case 'shellboundaries'
                Settings.Onion.ShellBoundaries=varargin{2*ind};
            case 'variabilitybins'
                Settings.Onion.VariabilityBins=varargin{2*ind};
    
            case 'entropymethod'
                Settings.Alignment.EntropyMethod=varargin{2*ind};
            case 'classfile'
                data=importdata(varargin{2*ind});
                data.data(isnan(data.data))=0;
                Settings.Alignment.Classes=data.data;
            case 'gaps'
                Settings.Alignment.Gaps=varargin{2*ind};
            case 'gapmode'
                Settings.Alignment.Gap_mode=varargin{2*ind};
            case 'ambiguous'
                Settings.Alignment.Ambiguous=varargin{2*ind};
            case 'normalize'
                Settings.Alignment.Normalize=varargin{2*ind};
            case 'p21frac'
                Settings.Alignment.P21_frac=varargin{2*ind};
                
            case 'contactcutoff'
                Settings.Structure.ContactCutoff=varargin{2*ind};
            case 'rmsemethod'
                Settings.Structure.RMSEmethod=varargin{2*ind};
            case 'skipfiltermap'
                Settings.Structure.SkipFilterMap=varargin{2*ind};
            
            case 'combined'
                Settings.Subsets.Combined=varargin{2*ind};
            case 'variablenames'
                Settings.Subsets.VariableNames=varargin{2*ind};
            case 'variablevalues'
                Settings.Subsets.VariableValues=varargin{2*ind};
            case 'displayplots'
                Settings.Subsets.DisplayPlots=varargin{2*ind};
            case 'subsetnames'
                Settings.Subsets.SubsetNames=varargin{2*ind};
            
        end
    end
end


for Pro_ind=1:length(CADS_object)
    CADS_object(Pro_ind).Settings=Settings;
    
    try 
        Variability=Entropy(CADS_object(Pro_ind),varargin{:});
        variability=Variability{1};
    catch
        variability='unknown';
    end
    names=CADS_object(Pro_ind).Species;
    CAOut=cell(length(CADS_object));
    
    if ~isempty(names)
        Proteins(length(names))=Protein('blank');
        CAOut{Pro_ind}(length(names))=ConAnalOutput();
        MapUC=cell(1,length(names));
        
        for model=1:length(names)
            FAM=FullAtomModel([CADS_object(Pro_ind).Name,'_',names{model}]);                                       % Instantiate
            FAM.PopulateFAM(CADS_object(Pro_ind).PDB(model).PDB);
            Proteins(model)=Protein(FAM.Name);
            Proteins(model).PopulateProtein(FAM);
            if ~isempty(CADS_object(Pro_ind).Alignment)
                Proteins(model).addConsensusSequence(seqconsensus(CADS_object(Pro_ind).Alignment,'gaps','all'));
                Proteins(model).addVariability(variability);
            end
            CAOut{Pro_ind}(model)=ConAnalOutput(Proteins(model),CADS_object(Pro_ind).Alignment,variability);
        end
        CADS_object(Pro_ind).Results=CAOut{Pro_ind};
    end
    if isempty(CADS_object(Pro_ind).Subsets) && isnumeric(variability)
        CADS_object(Pro_ind).Subsets={1:length(variability)};
    end
    
end
try CADS_object.RMSE(varargin{:});catch;end
try CADS_object.SubsetAnalysis(varargin{:},'DisplayOpt','off');catch;end
if ~Settings.Structure.SkipFilterMap
    try CADS_object.FilterMap(varargin{:});catch;end
end
if Settings.Subsets.DisplayPlots
    try Map3Dto2D(CADS_object,'UpdateFilteredMap',false(),varargin{:});catch;end
end
end
