function [D,V]=dn_pdist(aln,gappenalty)
%DN_PDIST - p-distances (nucleotide)
%
% Syntax: [D,V]=dn_pdist(aln,gappenalty)
%
% Inputs:
%    aln          - Alignment structure
%    gappenalty   - (optional) Gap penalty
%
% Outputs:
%    D      - Distance matrix
%
% See also: DP_PDIST

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007
if (isstruct(aln)), seq=aln.seq; else seq=aln; end

[n,m] = size(seq);
if(nargin==1) gappenalty=0; end

[N,v,gap] = dn_ntdiff(aln);
D = N./((m-gap)+(gap.*gappenalty));
if (nargout>1),
	V=D.*(1-D)./m;
end