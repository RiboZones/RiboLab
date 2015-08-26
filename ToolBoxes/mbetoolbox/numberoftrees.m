function [ntree] = numberoftrees(ns,rooted)
%NUMBEROFTREES - Number of rooted or unrooted trees

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (nargin<1), error('Please specific ns.'); end
if (nargin<2), rooted=1; end
if (ns<4), error('ns too small!'); end
if (ns>15), error('ns too large!'); end
ntree=1;

for (i=4:ns),
  ntree=ntree*(2*i-5);
end
if (rooted), ntree=ntree*(2*i-3); end