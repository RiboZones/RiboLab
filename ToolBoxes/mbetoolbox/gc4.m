function [V,P]=gc4(aln)
%GC4 - Counts GC content at fourfold degenerate sites
%
% Syntax: [V,P]=gc4(aln)
%
% Inputs:
%    aln  - Alignment structure
%
% Outputs:
%    V    - Number of GC
%    P    - Frequency of GC
%
% See also: COUNTBASECHANGE

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

S=aln.seq;
[seq0,seq2,seq4,m0,m2,m4] = extractdegeneratesites(S);
V=sum((seq4==2|seq4==3),2);
P=V./m4;