function  VarPlot(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% merge=false;
Color=true;
if nargin >1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            %             case 'Method'
            %                 merge=varargin{2*ind};
            case 'Color'
                Color=varargin{2*ind};
                
        end
    end
end
%
% if  merge
%     results=[CADS_object.Results];
%
%     %Keep=[CADS_object.Keep];
%     %proteins=[results.Protein];
%     %Pro=proteins.merge(Keep);
%     %Pro.OnionPlot();
% else
l=zeros(1,length(CADS_object));
for i=1:length(CADS_object)
    l(i)=length(CADS_object(i).Results(1).Variability);
end
Var=nan(max(l),length(CADS_object));
for i=1:length(CADS_object)
    Var(1:l(i),i)=CADS_object(i).Results(1).Variability;
end
if Color
    ColorVar(mat2cell(Var,size(Var,1),ones(1,size(Var,2)))',varargin{:})
else
    plot(Var);
end
% end
% end
end




