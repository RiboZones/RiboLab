function [seq0,seq2,seq4,m0,m2,m4] = extractdegeneratesites(S)
%EXTRACTDEGENERATESITES - Extract 0-, 2- and 4-fold degenerate sites
%
% Syntax: [seq0,seq2,seq4,m0,m2,m4] = extractdegeneratesites(S)
%
% Inputs:
%    S     - Sequence
%
% Outputs:
%    seq0     - 0-fold degenerate sequence only
%    seq2     - 2-fold degenerate sequence only
%    seq4     - 4-fold degenerate sequence only
%    m0       - Number of 0-fold degenerate sites in sequence
%    m2       - Number of 2-fold degenerate sites in sequence
%    m4       - Number of 4-fold degenerate sites in  sequence
%
% See also: EXTRACTSEGREGATINGSITES

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

[n,m]=size(S);
S2=codonise64(S);
marker=zeros(n,m);

% deg. tables = {'AAA' 'AAC' 'AAG' 'AAT' 'ACA' 'ACC' 'ACG' 'ACT' 'AGA' 'AGC' 'AGG' 'AGT' 'ATA'
% 'ATC' 'ATG' 'ATT' 'CAA' 'CAC' 'CAG' 'CAT' 'CCA' 'CCC' 'CCG' 'CCT' 'CGA' 'CGC' 'CGG' 'CGT' 'CTA'
% 'CTC' 'CTG' 'CTT' 'GAA' 'GAC' 'GAG' 'GAT' 'GCA' 'GCC' 'GCG' 'GCT' 'GGA' 'GGC' 'GGG' 'GGT' 'GTA'
% 'GTC' 'GTG' 'GTT' 'TAA' 'TAC' 'TAG' 'TAT' 'TCA' 'TCC' 'TCG' 'TCT' 'TGA' 'TGC' 'TGG' 'TGT' 'TTA'
% 'TTC' 'TTG' 'TTT'};


degtable=[0 0 2; 0 0 2; 0 0 2; 0 0 2; 0 0 4; 0 0 4; 0 0 4; 0 0 4; 2 0 2; 0 0 2;
2 0 2; 0 0 2; 0 0 2; 0 0 2; 0 0 0; 0 0 2; 0 0 2; 0 0 2; 0 0 2; 0 0 2;
0 0 4; 0 0 4; 0 0 4; 0 0 4; 2 0 4; 0 0 4; 2 0 4; 0 0 4; 2 0 4; 0 0 4;
2 0 4; 0 0 4; 0 0 2; 0 0 2; 0 0 2; 0 0 2; 0 0 4; 0 0 4; 0 0 4; 0 0 4;
0 0 4; 0 0 4; 0 0 4; 0 0 4; 0 0 4; 0 0 4; 0 0 4; 0 0 4; 0 0 0; 0 0 2;
0 0 0; 0 0 2; 0 0 4; 0 0 4; 0 0 4; 0 0 4; 0 0 0; 0 0 2; 0 0 0; 0 0 2;
2 0 2; 0 0 2; 2 0 2; 0 0 2; 0 0 0];


for (p=1:n),
for (q=1:m/3)
	deg = degtable(S2(p,q),:);
	a=q;
	q=(q-1)*3+1;	% jump index p every next three bases.
	marker(p,q)=deg(1,1); marker(p,q+1)=deg(1,2); marker(p,q+2)=deg(1,3);
end
end


validflag=zeros(1,m);
k=1:m;
validflag(1,k)=min(marker(:,k))==max(marker(:,k));	% valid columns's flag, 0 or 1

pick0=marker==0;
pick2=marker==2;
pick4=marker==4;
picker0=pick0(1,:)&validflag;
picker2=pick2(1,:)&validflag;
picker4=pick4(1,:)&validflag;

seq0 = S(:,picker0);
seq2 = S(:,picker2);
seq4 = S(:,picker4);

m0=sum(picker0);
m2=sum(picker2);
m4=sum(picker4);