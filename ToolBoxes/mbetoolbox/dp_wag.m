function [D]=dp_wag(aln)
%DP_WAG - WAG Distance
%
% Syntax: [D]=dp_wag(aln)
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

[D]=protdist(aln,'wag');