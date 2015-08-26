function [res] = dinuc2codon(dinuc)
%DINUC2CODON - Permutes codons containing a given dinucleotide

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 9/3/2005

if (length(dinuc)~=2)
    error('Please supply a dinuc of dinucleotide, like ''AG''')
end

res={};
CD = {'AAA' 'AAC' 'AAG' 'AAT' 'ACA' 'ACC' 'ACG' 'ACT' 'AGA' 'AGC' 'AGG' 'AGT' 'ATA' 'ATC' 'ATG' 'ATT' ...
      'CAA' 'CAC' 'CAG' 'CAT' 'CCA' 'CCC' 'CCG' 'CCT' 'CGA' 'CGC' 'CGG' 'CGT' 'CTA' 'CTC' 'CTG' 'CTT' ...
      'GAA' 'GAC' 'GAG' 'GAT' 'GCA' 'GCC' 'GCG' 'GCT' 'GGA' 'GGC' 'GGG' 'GGT' 'GTA' 'GTC' 'GTG' 'GTT' ...
      'TAA' 'TAC' 'TAG' 'TAT' 'TCA' 'TCC' 'TCG' 'TCT' 'TGA' 'TGC' 'TGG' 'TGT' 'TTA' 'TTC' 'TTG' 'TTT'};

i=0;
for (k=1:length(CD)),
	x=EditDist(char(CD(k)),dinuc);
	if (x==1)
        if ~(isempty(findstr(char(CD(k)),dinuc))),
            i=i+1;
		    res{i}=char(CD(k));
        end
	end
end



