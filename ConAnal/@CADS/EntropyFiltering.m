function [ Table, Keep, F ] = EntropyFiltering(CADS_object,ClassFileNames,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numClassSets=length(ClassFileNames);
numDataSets=size(CADS_object,2);
Keep=cell(numClassSets,1);
KeepFilter=cell(numClassSets,1);
F=cell(numClassSets,1);

analyze_flag=true();
% species_ind=1;
% filter_by_distance=true();

if nargin >1
    for ind=1:length(varargin)/2
        switch lower(varargin{2*ind-1})
            case 'freqfilterlist'
                FreqFilterList=varargin{2*ind};
            case 'analyze'
                analyze_flag=varargin{2*ind};
%             case 'species'
%                 species_ind=varargin{2*ind};
%             case 'filterbydistance'
%                 filter_by_distance=varargin{2*ind};
        end
    end
end


% numDataSets=length(CADS_object);
% Alignment=cell(numDataSets,1);
% Residue_Numbers=cell(numDataSets,1);

Table=cell(numClassSets,1);

for class_ind=1:numClassSets
    try
        FreqFilter=FreqFilterList{1}{class_ind};
    catch
        FreqFilter={};
    end
    
    %% Reanalyze if necessary
    if analyze_flag
        CADS_object(class_ind,:).Analyze('classfile',ClassFileNames{class_ind},varargin{:});
    end
    
    %% Find candidate residues based on sequence
    newargin=['FreqFilter',{FreqFilter},varargin{:}];
    [Keep{class_ind},F{class_ind}]=PlotVar(CADS_object(class_ind,:),newargin{:});
    
    %% Compute Contact Maps of candidate residues
    KeepFilter{class_ind}=CADS_object(class_ind,:).FilterMap('FilterRes',Keep{class_ind},varargin{:});
    
%     KeepFilter{class_ind}
%     Keep1{class_ind}
    
    
%     %% Refilter candidate residues based on contact maps
%     if filter_by_distance
%         
%         
% %         newargin2=['InputFilter',Keep_Distance,newargin{:}];
% %         [Keep2{class_ind},F{class_ind}]=PlotVar(CADS_object(class_ind,:),newargin2{:});
%         
%         Keep=Keep2;
%     else
%         Keep=Keep1;
%     end
    %% Make table
    Table{class_ind}=cell(numDataSets,1);
    for DataSet_ind=1:numDataSets
        for subset_ind=1:length(CADS_object(class_ind,DataSet_ind).Subsets)
            for model_ind=1:length(CADS_object(class_ind,DataSet_ind).Species)
                
                Realnumbers=CADS_object(class_ind,DataSet_ind).Keep(model_ind).Alignment(Keep{class_ind}{DataSet_ind}{subset_ind});
                Indices=find(Keep{class_ind}{DataSet_ind}{subset_ind});
                Realnumbers_Contact=CADS_object(class_ind,DataSet_ind).Keep(model_ind).Alignment(KeepFilter{class_ind}{DataSet_ind}{model_ind}{subset_ind});
                if ~isempty(Realnumbers)
                    Indices(ismember(Realnumbers,{'0','-1'}))=[];
                    Realnumbers(ismember(Realnumbers,{'0','-1'}))=[];
                    
                    
                    Table{class_ind}{DataSet_ind}{model_ind}{subset_ind}=cellstr(aminolookup(CADS_object(class_ind,DataSet_ind).Full(model_ind).Sequence(...
                        str2num(char(Realnumbers)))'));
                    %Table{class_ind}{DataSet_ind}{model_ind}{subset_ind}(:,2)=num2cell(Realnumbers)';
                    Table{class_ind}{DataSet_ind}{model_ind}{subset_ind}(:,2)=Realnumbers';
                    Table{class_ind}{DataSet_ind}{model_ind}{subset_ind}(:,3)=cellstr(repmat(CADS_object(class_ind,...
                        DataSet_ind).EntropyType,length(Realnumbers),1));
                    Table{class_ind}{DataSet_ind}{model_ind}{subset_ind}(:,4)=num2cell(CADS_object(class_ind,...
                        DataSet_ind).Results(model_ind).Variability(Indices))';
                    if ~ isempty(FreqFilter) && FreqFilter{1}~=0
                        Table{class_ind}{DataSet_ind}{model_ind}{subset_ind}(:,5)=num2cell(round(100*F{class_ind}{DataSet_ind}(FreqFilter{1},Indices)))';
                    else
                        Table{class_ind}{DataSet_ind}{model_ind}{subset_ind}(:,5)=num2cell(max(round(100*F{class_ind}{DataSet_ind}(:,Indices))))';
                    end
                    
                    [~,b]=ismember(Realnumbers_Contact,Realnumbers);
                    x=cellstr(repmat('No',length(Realnumbers),1));
                    x(b)=cellstr(repmat('Yes',length(Realnumbers_Contact),1));
                    Table{class_ind}{DataSet_ind}{model_ind}{subset_ind}(:,6)=x;
                                        
                    y=CADS_object(class_ind,DataSet_ind).Results(model_ind).FilteredMap(subset_ind).Y(:,3);
                    for i=1:length(y)
                        Table{class_ind}{DataSet_ind}{model_ind}{subset_ind}(b(i),7)={reshape(y{i}',1,[])};
                    end
                end
                
            end
        end
    end
    
end

% disp(42)