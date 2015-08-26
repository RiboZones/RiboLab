function [ d,h ] = BarBinPlot(CADS_object,Subsets,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
numDataSets=length(CADS_object);
VarInterest=cell(numDataSets,1);
% Subsets=varargin{1};
[Color,~]=CADS_object.cSequenceColor(varargin{:});
for i=1:numDataSets
   VarInterest{i}=reshape(Color{i}',1,[]);
   VarInterest{i}=VarInterest{i}(1:length(CADS_object(i).Results(1).Variability));
end
%VarInterest=Color;
[V,Gc,GLabels]=BreakSubset(VarInterest,Subsets,varargin{:});
numbins=length(unique(cell2mat(V')));

for j=1:length(V)
    H{j}=hist(V{j},numbins);
end
z=cell2mat(H)';
d=reshape(z,numbins,[]);
d=d';
d=d./repmat(sum(d,2),1,numbins);
% h=bar(d,.6,'stacked');
showcols=size(d,2);
figure()
h=bar(d([2,3,5,6,8,9],1:showcols)*100,'stacked');

