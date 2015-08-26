function [syn,nsyn]=synnsynsites(seq,gencode)
%synnsynsites - counts Syn. and Nonsyn. sites of coding sequences.

if (nargin<2), gencode=1; end
seq=rmcodongaps(seq);
[n,m]=size(seq);

if (mod(m,3)>0), error('Need codon sequence'); end
[codonseq]=codonise64(seq);

[S,N] = getsynnonsynsites(gencode);

syn=sum(S(codonseq),2);
nsyn=sum(N(codonseq),2);