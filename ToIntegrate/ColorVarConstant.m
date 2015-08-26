function ColorVarConstant(CADS_object,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


% MapMode='betweenChains';

numModels=length(CADS_object);

% if nargin > 1
%     for ind=1:length(varargin)/2
%         switch varargin{2*ind-1}
%             case 'MapMode'
%                 MapMode=varargin{2*ind};
%         end
%     end
% end

for i=1:numModels;
    
    
    CADS_object(i).Map3Dto2D('UpdateFilteredMap',false(),'MapbyVar',true(),'EnableColorBar',false())

end

end

