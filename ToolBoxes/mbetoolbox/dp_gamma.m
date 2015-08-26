function [D,V]=dp_gamma(aln,alpha)
%DP_GAMMA - Gamma distance (amino acids)
% The Gamma distance improves upon the Poisson correction distance
% by taking care of the inequality of the substitution rates among
% sites.  For this purpose, you will need to provide the gamma
% shape parameter (a). For estimating the Dayhoff distance, use
% a = 2.25 (see Nei and Kumar [2000], page 21 for details). For
% computing Grishin's distance, use a = 0.65. (see Nei and Kumar
% [2000], page 23 for details)
%
% Syntax: [D,V]=dp_gamma(aln,alpha)
%
% Inputs:
%    aln          - Alignment structure
%
% Outputs:
%    D      - Distance matrix
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if(nargin==1), alpha=2.25; disp('Using default alpha=2.25'); end

[n,m] = size(aln.seq);


[P,v]=dp_pdist(aln);
D= alpha*(((1-P).^(-1/alpha))-1);
V=(P.*((1-P).^(-1*(1+2/alpha))))./m;
% SE=sqrt(V);