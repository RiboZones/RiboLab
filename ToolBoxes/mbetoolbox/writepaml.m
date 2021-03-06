function writepaml(aln,filename)
%WRITEPHYLIP_I - Write alignment structure into PAML formatted file
%
% Syntax:  writepaml(aln,'filename')
%
% Inputs:
%    aln         - Alignment structure
%    filename    - interleaved PAML file.
%
% See also: READPHYLIP_I, WRITEPHYLIP_S, READPHYLIP_S

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (nargin < 1), error('at least one input'); end

if nargin < 2
    [filename, pathname, filterindex] = uiputfile( ...
       {'*.paml;*.pml', 'Paml Format Files (*.paml, *.pml)';
        '*.*',  'All Files (*.*)'}, ...
        'Save as');
	if ~(filename), return; end
	filename=[pathname,filename];

	if (filterindex==1)
	if (isempty(find(filename=='.'))) 		
		filename=[filename,'.pml'];
	end
	end
end

[n,m]=size(aln.seq);
p=1:n; q=1:m;
[NT,AA] = seqcode;

switch (aln.seqtype)
    case (3)	% Protein
	aln.seq(find(isnan(aln.seq)))=i_getcode4gap('PROTEIN');
	Seq(p,q)=AA(aln.seq(p,q));
    otherwise	% nucleotides
	aln.seq(find(isnan(aln.seq)))=i_getcode4gap('DNA');
	Seq(p,q)=NT(aln.seq(p,q));
end


fid = fopen(filename,'wt');
if fid == -1
   disp('Unable to open file.');
   return
end

fprintf(fid, [' %d %d\n'],n,m);
mt = 1:60:size(Seq,2);
mt = cat(1,mt',size(Seq,2)+1);

for (i=1:n),
    name=removeblanks(char(aln.seqnames(i)));
    %fprintf(fid, ['%s\n'], removeblanks(i_name10(name)));
    fprintf(fid, ['%s\n'], removeblanks(name));

for (j=1:length(mt)-1),
    s=char(Seq(i,[mt(j):mt(j+1)-1]));
	fprintf(fid, ['%s\n'],s);
end
	% fprintf(fid,'\n');
end

fclose(fid);