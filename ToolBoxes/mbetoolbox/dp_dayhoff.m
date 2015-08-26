function [D]=dp_dayhoff(aln)
%DP_DAYHOFF - Dayhoff Distance
% Numbers of accepted point mutations (x10) accumulated from closely
% related sequences. Fifteen hundred and seventy-two exchanges are
% shown. Fractional exchanges result when ancestral sequences are
% ambiguous; the probabilities are distributed equally among all
% possibilities. The total number of exchanges tallied was 1,572.
% Note that 36 exchanges, of the 190 possible, were never observed.
% The Asp-Glu pair had the largest number of exchanges 83.1 (Adapted
% from Figure 80. Atlas of Protein Sequence and Structure, Suppl 3,
% 1978, M.O. Dayhoff, ed. National Biomedical Research Foundation,
% 1979.)
%
% Syntax: [D]=dp_dayhoff(aln)
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

[D]=protdist(aln,'dayhoff');