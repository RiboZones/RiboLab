function BP=ContactMap2BP(CADS_object,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Species_ind=1;
MapMode='betweenChains';
bp_type='';
BP_FieldNames={'BP1_Name','BP1_Num','BP1_Chain','BP2_Name','BP2_Num','BP2_Chain'};
BP_Order=[1,2,3,4,5,6];
bp_reverse=false;

%for right now, let's make this support single CADS objects
%if length(CADS_object) > 1
%   error('single CADS only please')
%end

numObjs=length(CADS_object);

if nargin > 1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'Species'
                Species_ind=varargin{2*ind};
            case 'MapMode'
                MapMode=varargin{2*ind};
            case 'bp_type'
                bp_type=varargin{2*ind};
            case 'bp_reverse'
                bp_reverse=varargin{2*ind};
        end
    end
end

if bp_reverse
    BP_Order=[4,5,6,1,2,3];
end

for numSet = 1: numObjs
    if isempty(CADS_object(numSet).Results(Species_ind).FilteredMap)
        continue
    end
    numSamples=length(CADS_object(numSet).Results(Species_ind).FilteredMap(1).contacts);
    DataStruct=struct('Index',repmat({''},numSamples,1),'BP1_Name',...
        repmat({''},numSamples,1),'BP1_Num',repmat({''},numSamples,1),'BP1_Chain',...
        repmat({''},numSamples,1),'BP2_Name',repmat({''},numSamples,1),'BP2_Num',...
        repmat({''},numSamples,1),'BP2_Chain',repmat({''},numSamples,1),'BP_Type',...
        repmat({''},numSamples,1),'BP_Nesting',repmat({''},numSamples,1));
    BP(numSet)=struct('Name',CADS_object(numSet).Name,'Chain',CADS_object(numSet).PDB(Species_ind).PDB.Model.Atom(1).chainID,...
        'Data',DataStruct);
    dataind=1;
    %emptyData=true;
    for i=1:numSamples
        
        switch MapMode
            case 'withinTarget'
                numContacts=size(CADS_object(numSet).Results(Species_ind).FilteredMap(1).Y{i,3},1);
                for j=1:numContacts-1
                    %don't forget to update here to make line mode work the new
                    %way
                    for k=j+1:numContacts
                        BP(numSet).Data(dataind).Index=num2str(dataind);
                        contactsA=regexp(CADS_object(numSet).Results(Species_ind).FilteredMap(1).Y{i,3}(j,:),'(?<name>[^-]+)_(?<chain>[^_]*)_[\s]*(?<number>[\w]+)','names');
                        contactsB=regexp(CADS_object(numSet).Results(Species_ind).FilteredMap(1).Y{i,3}(k,:),'(?<name>[^-]+)_(?<chain>[^_]*)_[\s]*(?<number>[\w]+)','names');
                        
                        BP(numSet).Data(dataind).BP1_Name=contactsA.name;
                        BP(numSet).Data(dataind).BP1_Num=contactsA.number;
                        BP(numSet).Data(dataind).BP1_Chain=contactsA.chain;
                        BP(numSet).Data(dataind).BP2_Name=contactsB.name;
                        BP(numSet).Data(dataind).BP2_Num=contactsB.number;
                        BP(numSet).Data(dataind).BP2_Chain=contactsB.chain;
                        BP(numSet).Data(dataind).BP_Type=bp_type;
                        BP(numSet).Data(dataind).BP_Nesting='';
                        dataind=dataind+1;
                        %emptyData=false;
                    end
                end
            case 'betweenChains'
                numContacts=size(CADS_object(numSet).Results(Species_ind).FilteredMap(1).Y{i,3},1);
                for j=1:numContacts
                    contactsA=regexp(cellstr(CADS_object(numSet).Results(Species_ind).FilteredMap(1).Y{i,2}),'(?<name>[^-]+)_(?<chain>[^_]*)_[\s]*(?<number>[\w]+)','names');
                    contactsB=regexp(cellstr(CADS_object(numSet).Results(Species_ind).FilteredMap(1).Y{i,3}),'(?<name>[^-]+)_(?<chain>[^_]*)_[\s]*(?<number>[\w]+)','names');
                    %                v=[contactsB{:}];
                    
                    %                 for k=j+1:numContacts
                    BP(numSet).Data(dataind).Index=num2str(dataind);
                    BP(numSet).Data(dataind).(BP_FieldNames{BP_Order(1)})=contactsA{1}.name;
                    BP(numSet).Data(dataind).(BP_FieldNames{BP_Order(2)})=contactsA{1}.number;
                    BP(numSet).Data(dataind).(BP_FieldNames{BP_Order(3)})=contactsA{1}.chain;
                    BP(numSet).Data(dataind).(BP_FieldNames{BP_Order(4)})=contactsB{j}.name;
                    BP(numSet).Data(dataind).(BP_FieldNames{BP_Order(5)})=contactsB{j}.number;
                    BP(numSet).Data(dataind).(BP_FieldNames{BP_Order(6)})=contactsB{j}.chain;
                    BP(numSet).Data(dataind).BP_Type=bp_type;
                    BP(numSet).Data(dataind).BP_Nesting='';
                    dataind=dataind+1;
                    %emptyData=false;
                    %                 end
                end
                
        end
    end
    numKeep=length(vertcat(BP(numSet).Data.BP1_Chain));
    BP(numSet).Data=BP(numSet).Data(1:numKeep);
end
% if emptyData
%     BP=-1;
% end
end

