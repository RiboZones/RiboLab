function OnionPlot(Pro,bins,keep,doubled)
if nargin < 2 || isempty(bins)
    bins=[0, realmin, 1+realmin, 2+realmin, Inf];
    binName={'Universally conserved',...
        'Highly Conserved','Conserved','Variable'};
end
if nargin <3
    keep=true(1,length(Pro.shell));
end
if nargin <4
    doubled=false;
end
CustomColorMap=[1,0,0;0,1,0;0,0,1;.5,0,1;1,.5,0;.8,.8,.8;.2,.2,.2;0,0,0];

figure();
if isempty(Pro.shell)
    numres=length(Pro.variability);
    H=histc(Pro.variability,bins);
    H(end)=[];
    numbins=length(bins)-1;
    d=H/numres;
    bar(d,.6);
    shells={'Sample'};
else
    numshells=length(unique(Pro.shell(keep)));
    minShell=min(unique(Pro.shell(keep)));
    G=cell(1,numshells);
    H=cell(1,numshells);
    shells=cell(1,numshells);
    numres=zeros(1,numshells);
    for i=1:numshells
        G{i}=Pro.variability(Pro.shell(keep)==i+minShell-1);
        numres(i)=length(G{i});
        H{i}=histc(G{i},bins);
        H{i}(end)=[];
        if size(H{i},1)~=1
            H{i}=H{i}';
        end
        %
        %double wide
        if doubled
            shells{i}=['Shell ',num2str(2*(i+minShell-1)-1),...
                '+',num2str(2*(i+minShell-1))];
        else
            shells{i}=['Shell ',num2str(i+minShell-1)];
        end
    end
        numbins=length(bins)-1;
        z=cell2mat(H)';
        d=reshape(z,numbins,numshells);
        d=d./repmat(numres,numbins,1);
        h=bar(d,.6);
        %recolor for ribosome shell
        usedShells=minShell:minShell+numshells-1;
        for i=1:length(h)
            switch usedShells(i)
                case 1
                    set(h(i),'FaceColor',CustomColorMap(1,:));
                case 2
                    set(h(i),'FaceColor',CustomColorMap(2,:));
                    
                case 3
                    set(h(i),'FaceColor',CustomColorMap(3,:));
                    
                case 4
                    set(h(i),'FaceColor',CustomColorMap(4,:));
                    
                case 5
                    set(h(i),'FaceColor',CustomColorMap(5,:));
                    
                case 6
                    set(h(i),'FaceColor',CustomColorMap(6,:));
                    
                case 7
                    set(h(i),'FaceColor',CustomColorMap(7,:));
                    
                otherwise
                    set(h(i),'FaceColor',CustomColorMap(8,:));
            end    
        end      
end
legend(shells)
ylim([0,1])
title(Pro.Name,'Interpreter','none')
if ~exist('binName','var')
    binName=cell(1,numbins);
    for i=1:numbins
        binName{i}=[num2str(bins(i)),' - ',num2str(bins(i+1))];
    end
    xlabel('Shannon Entropy [bits]')
end
set(gca,'XTickLabel',binName)
ylabel('Frequeny of occurence','FontSize',16)
title(Pro.Name,'Interpreter','none','FontSize',16)
set(gca,'FontSize',16)
%legend off
  
end
