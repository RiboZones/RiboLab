function ColorVar(Vars,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numSamples=length(Vars);
ColorMap=cell(1,numSamples);
h=figure();
hc=zeros(1,numSamples);
m=minmax(cell2mat(Vars)');
Xlabel='Index';
Ylabel='Value';
Title='Title';
if nargin >1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'xlabel'
                Xlabel=varargin{2*ind};
            case 'ylabel'
                Ylabel=varargin{2*ind};
            case 'title'
                Title=varargin{2*ind};
        end
    end
end
%m(1)=floor(m(1));
%m(2)=ceil(m(2));
for i=1:numSamples
    subplot(numSamples,1,i),plot(Vars{i},'w')
    set(get(h,'CurrentAxes'),'NextPlot','add')
    set(get(h,'CurrentAxes'),'Color',[0.8,0.8,0.8])
    set(get(h,'CurrentAxes'),'FontSize',16)
    set(get(h,'CurrentAxes'),'FontName','Myriad Pro')
    subplot(numSamples,1,i),color_line(1:length(Vars{i}),Vars{i},Vars{i},'redblue',m);
    xlabel(Xlabel)
    ylabel(Ylabel)
    title([Title,num2str(i)])
    hc(i)=colorbar();
    ColorMap{i}=((m(1):(m(2)-m(1))*0.2:m(2))-m(1))/(m(2)-m(1))*63+1;
    %get(hc(i))
    set(hc(i),'FontName','Myriad Pro')
    set(hc(i),'FontSize',14)
%     num2str(round(10*(m(1):(m(2)-m(1))*0.2:m(2)))'/10);
    set(hc(i),'YTickLabel',num2str(round(10*(m(1):(m(2)-m(1))*0.2:m(2)))'/10))
    set(hc(i),'YTick',ColorMap{i})

end
end

