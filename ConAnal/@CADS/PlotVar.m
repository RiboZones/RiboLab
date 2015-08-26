function  [Keep,F]=PlotVar(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Single=true;
Style='symbols';
PlotSymbols={'^','v','s','d'};
PlotColors={'b','r','c','m'};
SubsetMode=false();




if nargin >1
    for ind=1:length(varargin)/2
        switch lower(varargin{2*ind-1})
            case 'graphstyle'
                Style=varargin{2*ind};
            case 'single'
                Single=varargin{2*ind};
            case 'plotsymbols'
                PlotSymbols=varargin{2*ind};
            case 'usesubsets'
                SubsetMode=varargin{2*ind};
        end
    end
end


numDataSets=length(CADS_object);
numPlotSymbols=length(PlotSymbols);

% F=cell(1,numDataSets);

[keep_cutoff,cutoff,F] = FilterVar(CADS_object,varargin{:});
switch lower(Style)
    case 'colorline'
        r=[CADS_object.Results]; 
        Range=minmax([r.Variability]);
    case 'bar'
        VarInterest=cell(numDataSets,1);
        [Color,~]=cSequenceColor(CADS_object,varargin{:});
end

Keep=cell(1,numDataSets);

for i=1:numDataSets
    numResidues=length(CADS_object(i).Alignment(1).Sequence);
    
    if isempty(CADS_object(i).Subsets)
        CADS_object(i).Subsets={1:numResidues};
    end
    
    %% Filter by Subsets
    if SubsetMode
        numSubsets=length(CADS_object(i).Subsets);
        Subsets=CADS_object(i).Subsets;
    else
        numSubsets=1;
        Subsets={1:numResidues};
    end
    inSubset=cell(numSubsets,1);
    for j=1:numSubsets
        inSubset{j}=false(1,numResidues);
        inSubset{j}(Subsets{j})=true;
    end
    
    %% Graph
    switch lower(Style)
        case 'line'
            figure()
            hold on
            for j=1:numSubsets
                Keep{i}{j}=keep_cutoff{i} & inSubset{j};
                if ~Single
                    subplot(1,numSubsets,j)
                end
                plot(find(Keep{i}{j}),CADS_object(i).Results(1).Variability(:,Keep{i}{j}),...
                    [PlotColors{j},'-'],'LineWidth',4)
            end
            
        
        case {'symbol','symbols'}
            figure()
            hold on
            for j=1:numSubsets
                Keep{i}{j}=keep_cutoff{i} & inSubset{j};
                if ~Single
                    subplot(1,numSubsets,j)
                end
                plot(find(Keep{i}{j}),CADS_object(i).Results(1).Variability(:,Keep{i}{j}),...
                    [PlotColors{j},PlotSymbols{mod(j,numPlotSymbols)}],'LineWidth',4)
            end
            
        case 'bar'
            VarInterest{i}=reshape(Color{i}',1,[]);
            VarInterest{i}=VarInterest{i}(1:length(CADS_object(i).Results(1).Variability));
            
            
            if i==numDataSets % This mode does a single graph for the whole dataset.   
                [V,~,GLabels]=BreakSubset(VarInterest,[CADS_object.Subsets],varargin{:});
                numbins=length(unique(cell2mat(V')));
                
                for j=1:length(V)
                    H{j}=hist(V{j},numbins);
                    xlabels{j}=GLabels{j}{1};
                end
                z=cell2mat(H)';
                d=reshape(z,numbins,[]);
                d=d';
                d=d./repmat(sum(d,2),1,numbins);
                showcols=size(d,2);
                figure()
%                 setdiff(1:size(d,1),1
                h=bar(d(:,1:showcols)*100,'stacked');
                set(gca,'XTickLabel',xlabels)
            end

        case 'colorline'
            h=figure();
            for j=1:numSubsets
                Keep{i}{j}=keep_cutoff{i} & inSubset{j};
                if ~Single
                    subplot(1,numSubsets,j)
                end
                plot(find(Keep{i}{j}),CADS_object(i).Results(1).Variability(:,Keep{i}{j}),...
                    ['w','-'])
                set(get(h,'CurrentAxes'),'NextPlot','add')
                color_line(find(Keep{i}{j}),CADS_object(i).Results(1).Variability(:,Keep{i}{j}),...
                    CADS_object(i).Results(1).Variability(:,Keep{i}{j}),'redblue',Range);
                set(get(h,'CurrentAxes'),'NextPlot','add')
                if ~Single
                    set(get(h,'CurrentAxes'),'Color',[0.8,0.8,0.8])
                    set(get(h,'CurrentAxes'),'FontSize',16)
                    set(get(h,'CurrentAxes'),'FontName','Myriad Pro')
                    hc=colorbar();
                    ColorMap=((Range(1):(Range(2)-Range(1))*0.2:Range(2))-Range(1))/(Range(2)-Range(1))*63+1;
                    set(hc,'FontName','Myriad Pro')
                    set(hc,'FontSize',14)
                    set(hc,'YTickLabel',num2str(round(10*(Range(1):(Range(2)-Range(1))*0.2:Range(2)))'/10))
                    set(hc,'YTick',ColorMap)
                    xlabel('Alignment Index')
                    ylabel('Entropy [bits]')
                    title([CADS_object(i).Name])
                end
            end
            set(get(h,'CurrentAxes'),'Color',[0.8,0.8,0.8])
            set(get(h,'CurrentAxes'),'FontSize',16)
            set(get(h,'CurrentAxes'),'FontName','Myriad Pro')
            hc=colorbar();
            ColorMap=((Range(1):(Range(2)-Range(1))*0.2:Range(2))-Range(1))/(Range(2)-Range(1))*63+1;
            set(hc,'FontName','Myriad Pro')
            set(hc,'FontSize',14)
            set(hc,'YTickLabel',num2str(round(10*(Range(1):(Range(2)-Range(1))*0.2:Range(2)))'/10))
            set(hc,'YTick',ColorMap)            
            xlabel('Alignment Index')
            ylabel('Entropy [bits]')
%             title([CADS_object(i).Name])
    end
        title(sprintf('%s Filtered @ %g',CADS_object(i).Name,cutoff))

    hold off
    
end

end

