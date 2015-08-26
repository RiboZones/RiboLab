function [res,resavg,resstd,score]=slidingwin(d,winsize,step,showit)

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (nargin<3),
    step=1;    
end
if (nargin<2),
    winsize=30;    
end

[n,m]=size(d);
res = slidingavg(d,winsize);
resavg=mean(res);
resstd=std(res);
score=sum(res>=resavg+resstd)+sum(res<=resavg-resstd);

if (showit==1),
	plot(res);
	info = ['Data - window size ', num2str(winsize), ' score=', num2str(score)];
	title(info);
	%axis([1 length(dnav) min(dnav)*1.1 max(dnav)*1.1]);
	xlabel('Base (bp)'); ylabel('Data');
    hold on
    plot([1:m],ones(1,m)*resavg,'r')
    plot([1:m],ones(1,m)*(resavg+resstd),'g--')
    plot([1:m],ones(1,m)*(resavg-resstd),'g--')
	legend('v', 'mean','std') ;
    hold off
end

