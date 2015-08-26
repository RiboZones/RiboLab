function [s] = revseq(s0)
%REVSEQ - Return reverse strand of nucleotide sequences
%
% Syntax: [s] = revseq(s0)
%
% Inputs:
%    s0     - Sequences
%
% Outputs:
%    s    - New sequences
%
% See also: TRANSLATESEQ, REVCOMSEQ

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


if (isstruct(s0))
      if ~(isvalidaln(s0,'NUCLEOTIDE'))
         error ('ERROR: Not nucleotide sequence.')
      end
         s0=s0.seq;
end

[n,m] = size(s0);
if n~=1
    error('REVSEQ requires a sequence of 1xm vector, not nx1.')
end
s=s0(:,m:-1:1);
