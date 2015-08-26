function [pos] = randcut(G,N,len)
%RANDCUT - Cuts genome DNA randomly into shot fragment
%Genome of size, G, is cutted random into N fragments of average length, len.

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (len>=G), error('No cut.'); end

pos=zeros(N,2);
for (k=1:N),
      ps=1+floor(rand*G);
      pe=ps+len+floor(randn*100);
      pe=min(pe,G);
      pos(k,1)=ps;
      pos(k,2)=pe;
      %fprintf('%d - %d\n',ps,pe);
end