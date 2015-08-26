function [aln2]=orderbysim(aln,refid,isaa);
%ORDERBYSIM - re-order sequences in alignment by their similarity
%

if nargin<3, isaa=0; end
if nargin<2, refid=1; end

if (isaa)
    d=dp_pdist(aln);
else
    d=dn_pdist(aln);
end

[dump,idx]=sort(d(refid,:));


if isstruct(aln)
    aln2.seqtype=aln.seqtype;
    aln2.geneticcode=aln.geneticcode;
    aln2.seqnames=aln.seqnames(idx);
    aln2.seq=aln.seq(idx,:);
else
    aln2=aln(idx);
end
