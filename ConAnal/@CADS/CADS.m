classdef CADS < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name='un-named'
        ItemNames={}
        EntropyType='t-SE(20)'
        Species={}
        Full=struct('Header','','Sequence','')
        PDB
        Alignment=struct('Header','','Sequence','')
        Keep=struct('Alignment',[],'PDB',[])
        Subsets={}
        SubsetsTarget={}
        Results
        Target
        Map3D_2D
        Stats
    end
    properties (SetObservable, AbortSet)
        Settings
    end
    
    %     methods (Static)
    %         function handlePropEvents(src,evnt)
    %             switch src.Name % switch on the property name
    %                 case 'PropOne'
    %                     % PropOne has triggered an event
    %                     ...
    %                 case 'PropTwo'
    %                 % PropTwo has triggered an event
    %                 ...
    %             end
    %         end
    %     end
    
    methods
        function CADS_object = CADS(name)
            if nargin > 0
                if iscell(name)
                    CADS_object(1).Name = name{1};
                    CADS_object(1).Results=ConAnalOutput(CADS_object(1).Name);
                    CADS_object(1).PDB=PDBentry(CADS_object(1).Name);
                    CADS_object(1).Target=PDBentry(CADS_object(1).Name);
                    CADS_object(1).Map3D_2D=Map2D(CADS_object(1).Name);
                    for i=2:length(name)
                        CADS_object(i) = CADS(name{i});
                    end
                else
                    CADS_object.Name = name;
                    CADS_object.Results=ConAnalOutput(name);
                    CADS_object.PDB=PDBentry(name);
                    CADS_object.Target=PDBentry(name);
                    CADS_object.Map3D_2D=Map2D(name);
                end
            end
        end
        
        function AddPDB(CADS_object,PDB_object,model_ind)
            if nargin < 3
                model_ind=1;
            end
            
            numCads=length(CADS_object);
            
            if length(PDB_object) < numCads 
                PDB_object=SplitByMolID(PDB_object);
            end
            for i=1:numCads
                
                try
                    if isempty(CADS_object(i).PDB(model_ind))
                        CADS_object(i).PDB=PDBentry();
                    end
                catch
                end
                
                switch class(PDB_object)
                    case 'PDBentry'
                        CADS_object(i).PDB(model_ind)=PDB_object(i);
                    case 'struct'
                        CADS_object(i).PDB(model_ind).PDBfromStruct(PDB_object(i))
                    case 'char'
                        CADS_object(i).PDB(model_ind).ImportPDB(PDB_object(i))%% array of chars? 
                    case 'cell'
                        CADS_object(i).PDB(model_ind).ImportPDB(PDB_object{i})
                end
                CADS_object(i).PDB(model_ind).Process()
                try
                    name=regexp(reshape(CADS_object(i).PDB(model_ind).PDB.Source',1,[]),...
                        'ORGANISM_SCIENTIFIC: ([^;]+);','tokens','once');
                    CADS_object(i).Species{model_ind}=name{1};
                catch
                end
                
                [urs,I]=unique(CADS_object(i).PDB(model_ind).UniqueResSeq);
                D=regexp(urs,'[\w]_[\s]*([\w]+)','tokens');
                d=vertcat(D{:});
                if isempty(d)
                    e={''};
                else
                    e=vertcat(d{:});
                end
                CADS_object(i).ItemNames=e;
                CADS_object(i).Keep(model_ind).PDB=e;
                CADS_object(i).Keep(model_ind).Alignment=e;
                CADS_object(i).Subsets{model_ind}=colon(1,length(I));
                try
                    rn={CADS_object(i).PDB(model_ind).PDB.Model.Atom(I).resName};
                    seq=aminolookup(rn(~ismember(rn,{'HOH','MG','NA','CL','ZN'})));
                    if length(seq)==1
                        CADS_object(i).Full(model_ind).Sequence=seq{1};
                        CADS_object(i).Full(model_ind).Header=CADS_object.Species{model_ind};
                        CADS_object(i).Alignment(model_ind).Sequence=seq{1};
                        CADS_object(i).Alignment(model_ind).Header=CADS_object.Species{model_ind};
                    end
                catch
                end
                CADS_object(i).Subsets{model_ind}(ismember(rn,{'HOH','MG','NA','CL','ZN'}))=[];
            end
        end
        
        function Alignment = AddAlignment(CADS_object,Alignment_Mode,Alignment)
            switch Alignment_Mode
                case 'built-in'
                    if length( CADS_object.Alignment) < 3
                        [~,align]=nwalign(CADS_object.Alignment(1).Sequence,CADS_object.Alignment(2).Sequence);
                        CADS_object.Alignment(1).Sequence=align(1,:);
                        CADS_object.Alignment(2).Sequence=align(3,:);
                        
                        
                    else
                        CADS_object.Alignment=multialign(CADS_object.Alignment);
                    end
                    for i=1:length(CADS_object.Keep)
                        W=zeros(1,length(CADS_object.Alignment(1).Sequence));
                        W(regexp(CADS_object.Alignment(i).Sequence,'\w'))=CADS_object.Keep(i).Alignment;
                        CADS_object.Keep(i).Alignment=W;
                    end
                    CADS_object.Subsets={colon(1,length(CADS_object.Alignment(1).Sequence))};
                case 'premade'
                    for i=1:length(Alignment)
                        Alignment(i).Sequence=regexprep(Alignment(i).Sequence,'~','-');
                    end
                    CADS_object.Alignment=Alignment;
            end
            
            
        end
        
        function AddTarget(CADS_object,Target,model_ind)
            if nargin < 3
                model_ind=1;
            end
            numCads=length(CADS_object);
            for i=1:numCads
                try
                    if isempty(CADS_object(i).Target)
                        CADS_object(i).Target=PDBentry();
                    end
                catch
                end
                CADS_object(i).Target(model_ind)=Target;
            end
        end
        
        
        function Add3D_2DMap(CADS_object,Map3D_2D,model_ind)
            if nargin < 3
                model_ind=1;
            end
            try
                if isempty(CADS_object.Map3D_2D)
                    CADS_object.Map3D_2D=Map2D();
                end
            catch
            end
            CADS_object.Map3D_2D(model_ind)=Map3D_2D;
            
        end
        
        
        
        function CADS_object2 = Copy(CADS_object)
            for i=1:length(CADS_object)
                CADS_object2(i)=CADS([CADS_object(i).Name,'_copy']);
                CADS_object2(i).EntropyType=CADS_object(i).EntropyType;
                CADS_object2(i).Species=CADS_object(i).Species;
                CADS_object2(i).Full=CADS_object(i).Full;
                CADS_object2(i).PDB=CADS_object(i).PDB;
                CADS_object2(i).Alignment=CADS_object(i).Alignment;
                CADS_object2(i).Keep=CADS_object(i).Keep;
                CADS_object2(i).Subsets=CADS_object(i).Subsets;
                CADS_object2(i).Settings=CADS_object(i).Settings;
                CADS_object2(i).Target=CADS_object(i).Target;
                CADS_object2(i).Map3D_2D=CADS_object(i).Map3D_2D;
                CADS_object2(i).SubsetsTarget=CADS_object(i).SubsetsTarget;
                CADS_object2(i).ItemNames=CADS_object(i).ItemNames;
            end
        end
        
        Analyze(CADS_object,varargin)
        [rmse, residuals, Keep] = RMSE(CADS_object,varargin)
        [Stats] = SubsetAnalysis(CADS_object,varargin)
        KeepFilter=FilterMap(CADS_object,varargin)
        Map3Dto2D(CADS_object,varargin)
        
        %         [Pro,d]=OnionPlot(CADS_object,varargin)
        [Keep,F]=PlotVar(CADS_object,varargin)
        Ramachandran=PlotRamachandran(CADS_object,varargin)
        [Alignment,Residue_Numbers]=PlotAlignment(CADS_object,varargin)
        
        [Propdistro,AAdistro,CutAlignments,PropMatrix]=PropDistro(CADS_object,varargin)
        VarPDBWrite(CADS_object,index)
        [ Table, Keep, F ] = EntropyFiltering(CADS_object,ClassFileNames,varargin)
        
        % 2D Map function
        Plot2DMap(CADS_object,varargin)
        
    end
    
end

