function [ IncludeRes, LineWidths ] = HelixCell2Lines(dataCell,HelicesLabel)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

HubStruct=cell2struct(dataCell(2:end,:),dataCell(1,:),2);

HelicesLines=cell(length(HubStruct),2);
Linewidths=cell(length(HubStruct),2);

for i=1:length(HubStruct)
    HubStruct(i).helixName=HelicesLabel{HubStruct(i).helix};
    HubStruct(i).neighborName=HelicesLabel(HubStruct(i).neighbor);
    HelicesLines{i,1}=cellstr(repmat(HubStruct(i).helixName,length(HubStruct(i).neighbor),1));
    HelicesLines{i,2}=strtrim(HubStruct(i).neighborName);
    Linewidths{i}=dataCell{i+1,3};
    
end
IncludeRes=[vertcat(HelicesLines{:,1}),vertcat(HelicesLines{:,2})];
LineWidths=1/3*[Linewidths{:}]';


