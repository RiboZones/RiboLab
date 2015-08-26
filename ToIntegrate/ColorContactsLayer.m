function ColorContactsLayer(CADS_object,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


% MapMode='betweenChains';

numModels=length(CADS_object);
UpdateFilteredMap=false();

if nargin > 1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'UpdateFilteredMap'
                UpdateFilteredMap=varargin{2*ind};
        end
    end
end


ColorIndices=round(colon(1,63/(numModels-1),64));
for i=1:numModels;
    CADS_object(i).Map3Dto2D('UpdateFilteredMap',UpdateFilteredMap,'MapbyVar',false(),...
        'EnableColorBar',false(),'ColorMapIndex',ColorIndices(i),varargin{:});
end

end

