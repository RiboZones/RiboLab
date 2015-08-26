function OnionPlot(Pro,bins,keep,doubled)
if nargin < 2 || isempty(bins)
    bins=[0, realmin, 1+realmin, 2+realmin, Inf];
    binName={'Universally Conserved',...
        'Highly Conserved','Conserved','Variable'};
end
if nargin <3
    keep=true(1,length(Pro.shell));
end
if nargin <4
    doubled=false;
end
CustomColorMap=[1,0,0;0,1,0;0,0,1;.5,0,1;1,.5,0;.8,.8,.8;.2,.2,.2;0,0,0];
maxColors=size(CustomColorMap,1);
figure();
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
% fraction by shell
d=d./repmat(sum(d,2),1,numbins);

%%%%%%%%%%%%%%%%%
h=bar(d,.6,'stacked');
%recolor for ribosome shell
usedShells=minShell:minShell+numshells-1;
for i=1:length(h)
    if usedShells(i)>maxColors
        usedShells(i)=maxColors;
    end
    set(h(i),'FaceColor',CustomColorMap(usedShells(i),:));
end
legend(shells)
ylim([0,1.2])
title(Pro.Name,'Interpreter','none')
if ~exist('binName','var')
    binName=cell(1,numbins);
    for i=1:numbins
        binName{i}=[num2str(bins(i)),' - ',num2str(bins(i+1))];
    end
    xlabel('Shannon Entropy [bits]')
end
set(gca,'XTickLabel',binName)
%ylabel('Frequeny of occurence','FontSize',16)
ylabel('Fraction by Shell','FontSize',16)
title(Pro.Name,'Interpreter','none','FontSize',16)
set(gca,'FontSize',16)
%legend off

end
