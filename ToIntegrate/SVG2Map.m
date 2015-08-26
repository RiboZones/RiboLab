function [ MyMap ] = SVG2Map(filename,varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    
end
if nargin < 3
    DataPointNames = [];
end

if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'MapName'
                MapName = varargin{2*ind};
            case 'DataPointNames'
                DataPointNames = varargin{2*ind};
        end
    end
end

if ~exist('MapName','var')
    [~,MapName] = fileparts(filename);
end
if ~exist('DataPointNames','var')
    DataPointNames = [];
end

MyMap=Map2D(MapName);
MyMap.AddMap(filename,'DataPointNames',DataPointNames,varargin{:});
