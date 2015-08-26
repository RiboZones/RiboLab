function [D]=dp_jtt(aln)
%DP_JTT - JTT Distance
%
% Syntax: [D]=dp_jtt(aln)
%
% Inputs:
%    aln    - Alignment structure
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

[D]=protdist(aln,'jtt');