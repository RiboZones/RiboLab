function [ SelectedResidues,SeleNames,SeleNumber ] = SelectByEdge( Edges_Struct,ResidueNames )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


numResLists=length(Edges_Struct);
SelectedResidues=cell(numResLists,1);
SeleNames=cell(numResLists,1);
SeleNumber=cell(numResLists,1);
if isfield(Edges_Struct,'Number')
    enable_number = true;
else
    enable_number = false;
end
for i=1:numResLists
    if ~mod(length(Edges_Struct(i).Edges),2)
            [~,Indices]=ismember(Edges_Struct(i).Edges,ResidueNames);
            %error check
            if sum(Indices~=0) < length(Edges_Struct(i).Edges) && sum(Indices~=0) > 0
                error('Some edges are not found.')
            elseif sum(Indices~=0) == 0
                SelectedResidues{i}={};
            else
                ResNames=cell(length(Indices)/2,1);
                for j=1:2:length(Indices)
                    ResNames{j}=ResidueNames(colon(Indices(j),Indices(j+1)));
                end
                SelectedResidues{i}=vertcat(ResNames{:});
                SeleNames{i}=repmat({Edges_Struct(i).Name},length(SelectedResidues{i}),1);
                if enable_number
                    SeleNumber{i}=repmat({Edges_Struct(i).Number},length(SelectedResidues{i}),1);
                end
            end
            
    else
        error('Bad Edges Structure. Must contain and even number of edges.')
    end
end

