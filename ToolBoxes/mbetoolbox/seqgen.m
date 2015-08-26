function [seq,aln] = seqgen(sq,t,tr,md)

if (nargin<4), md=modelk2p(4); end
if (nargin<3), tr='((1:0.5,2:0.7):0.2,3:0.3);'; end
if (nargin<2), t=0.7; end
if (nargin<1), sq=randseq(3000); end

%sq2=mutateseq(sq,md,t);
sq2=mutateseqdep(sq,md,t,{'GC_AC','GC_GT'},[0.8 0.8]);

seq=[sq;sq2];
if (nargout>1)
      aln.seqtype=1;
      aln.geneticcode=0;
      aln.seqnames={'seq1','seq2'};
      aln.seq=seq;
end