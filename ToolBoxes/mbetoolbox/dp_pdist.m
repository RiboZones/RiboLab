function [D,V]=dp_pdist(aln,gappenalty)
%DP_PDIST - p-distances (amino acid)
%
% Syntax: [D,V]=dp_pdist(aln,gappenalty)
%
% Inputs:
%    aln          - Alignment structure
%    gappenalty   - (optional) Gap penalty
%
% Outputs:
%    D      - Distance matrix
%
% See also: DN_PDIST

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


[n,m] = size(aln.seq);
if(nargin==1) gappenalty=0; end

[N,v,GAP] = dp_aadiff(aln);
D = N./((m-GAP)+(GAP.*gappenalty));
V=D.*(1-D)./m;