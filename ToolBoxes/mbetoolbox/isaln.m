function [y]=isaln(aln)
%ISALN - Is an alignment structure?
%
% [y]=isaln(aln)

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


y=0;
if ~(isstruct(aln)), return; end
if ~(isfield(aln,'seqtype')), return; end 
if ~(isfield(aln,'seqnames')), return; end 
if ~(isfield(aln,'seq')), return; end 
if ~(isfield(aln,'geneticcode')), return; end

if ~(iscell(aln.seqnames)), return; end
if ~(isnumeric(aln.seqtype)), return; end
if ~(isnumeric(aln.seq)), return; end
if ~(isnumeric(aln.geneticcode)), return; end

if ~(ismember(aln.seqtype, [1 2 3])), return; end
if ~(ismember(aln.geneticcode, [1:13])), return; end
y=1;