function [ OutputArray ] = FrequencyOnion( RV_Lab_Struct )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


FreqData=cell2mat(RV_Lab_Struct.Conservation_Table(2:end,4:8));
numPoints=size(FreqData,1);

RealData=cell(numPoints,1);
for i=1:numPoints
    RealData{i}=FreqData(i,:);
end

OutputArray=OnionHistogram(RV_Lab_Struct.OnionFiles.Onions(1),RV_Lab_Struct.RiboLabMap,RealData);

figure();
bar(cell2mat(OutputArray),'stacked');
end

