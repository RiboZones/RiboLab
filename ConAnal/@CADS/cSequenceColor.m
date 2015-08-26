function [Color_Matrix, Bounds] = cSequenceColor(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

index=1;
Method='Group';
numBins=4;

if nargin >1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'numBins'
                numBins=varargin{2*ind};
        end
    end
end

numObjects=length(CADS_object);
Color_Matrix=cell(1,numObjects);
Var=cell(1,numObjects);

L=zeros(1,numObjects);
Pad=zeros(1,numObjects);


for i=1:numObjects
    Var{i}=CADS_object(i).Results(index).Variability;
    L(i)=length(CADS_object(i).Results(index).Variability);
    if mod(L(i),60)
        Pad(i)=60-mod(L(i),60);
    end
    Color_Matrix{i}=zeros(60,(L(i)+Pad(i))/60);
end

switch Method
    case 'Individual'
        for i=1:numObjects
            [~,I]=sort(Var{i});
            Thirdtile=floor(L(i)/3);
            Color_Matrix{i}(I(1:Thirdtile))=-1*ones(1,Thirdtile);
            Color_Matrix{i}(I(end-Thirdtile+1:end))=ones(1,Thirdtile);
            Color_Matrix{i}=Color_Matrix{i}';
        end
    case 'Group'
        sVar=sort(cell2mat(Var));
        
        tileindices=(length(sVar)/numBins)*(1:numBins-1);
        tiles=[-Inf, (1-rem(tileindices,1)).*sVar(floor(tileindices)) + rem(tileindices,1).*sVar(ceil(tileindices)),Inf]+realmin; 
        
%         lowercutoff=sVar(floor(length(sVar)/3));
%         uppercutoff=sVar(end-floor(length(sVar)/3)+1);
        for i=1:numObjects
            [~,bins]=histc(Var{i},tiles);
            Color_Matrix{i}(1:length(bins))=bins;
%             Color_Matrix{i}(Var{i}<=lowercutoff)=-1;
%             Color_Matrix{i}(Var{i}>=uppercutoff)=1;
            Color_Matrix{i}=Color_Matrix{i}';
        end
        Bounds=tiles(2:end-1);
end
end
