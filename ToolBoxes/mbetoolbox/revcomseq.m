function [s] = revcomseq(s0)
%REVCOMSEQ - Return reverse complement of sequences
%
% Syntax: [s] = revcomseq(s0)
%
% Inputs:
%    s0     - Sequences
%
% Outputs:
%    s    - New sequences
%
% See also: REVSEQ

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

s=revseq(s0);
a=find(s==1); c=find(s==2); g=find(s==3); t=find(s==4);
s(a)=4; s(c)=3; s(g)=2; s(t)=1;