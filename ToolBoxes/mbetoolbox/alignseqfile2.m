function [aln] = alignseqfile2(type,filename,geneticcode)
%ALIGNSEQFILE - Align sequence file.
%
% Syntax: [aln] = alignseqfile(type,filename,geneticcode)
%
% Inputs:
%    type          - 'DNA'|'CDS'|'PROTEIN'
%    filename      - Input sequence file (FASTA format accepted).
%    geneticcode   - Genetic code
%
% Outputs:
%    aln     - Alignment structure
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


aln=[];


if(nargin<1) 
   error('Please input seqtype.')
   return;
end

	if ~(ischar(type))
	   error('Wrong sequence type.')
	   return;
   end

if (nargin<2),
    [filename, pathname, filterindex] = uigetfile( ...
       {'*.*', 'Sequence Files (*.*)'}, ...
        'Select a sequence file (FASTA)');
	if ~(filename), return; end
	filename=[pathname,filename];
end
	switch (upper(type))
	    case {'DNA'}
		seqtype = 1;
		if (nargin<3), geneticcode=0; end
		aln = runclustalw(filename,seqtype,geneticcode);
        
	    case ('CDS')
		seqtype = 2;

if nargin < 3
	[stype, geneticcode]=selectSeqTypeAndGeneticCode;
	if (isempty(stype)|isempty(geneticcode)), aln=[]; return; end
end        

        
        if ~(seqtype == 2)
		    error('Must be coding-DNA sequence file.');
		    return;
		end
        
	

        AlnNT = readfasta(filename,2,geneticcode);
        AlnAA = translatealn(AlnNT);
        
	if (i_includeStopCodon(AlnAA))
		    error('ERROR: Stop codon within sequences.')
		    return;
	end

%        if (any(any(AlnAA.seq==i_encode_a('*')))>0)
%            error('ERROR: Stop codon within sequences.')
%            return;
%        end        
		cmd = 'alignseqfile.m';
		dirstr=chdir2where(cmd);
		i_writeFASTA(AlnAA,'infile');
		[AlnAA] = runclustalw('infile',3,geneticcode);
		aln=i_alignCDS2Protein(AlnNT,AlnAA);

	   case ('PROTEIN')
		seqtype = 3;
		if (nargin<3), geneticcode=1; end
		aln = runclustalw(filename,seqtype,geneticcode); 

	   otherwise
	   error('Wrong sequence type.')
	   return;
	end



%%%%%%%%%%%%%
%%% SUBS  %%%
%%%%%%%%%%%%%

function [y] = i_includeStopCodon(AlnAA)
y=0;
[n,m]=size(AlnAA.seq);

[NT,AA] = seqcode;
% AA = 'ARNDCQEGHILKMFPSTWYV*-';
removeable =find(AA=='-'|AA=='*');
Seq = AlnAA.seq;
for i=1:n,
   s=Seq(i,:);
for (j=length(s):-1:1),
	if (ismember(s(j),removeable)),
	  s(j)=[];
	else
	  break;
	end	
end
	x=find(AA=='*');
	if (any(s==x)),
		y=1;
		return;
	end
end



%%%%%%%%%%%%%
%%% SUBS  %%%
%%%%%%%%%%%%%

function i_writeFASTA(aln,filename)
if nargin < 2
	error('No filename')
end

[n,m]=size(aln.seq);
[NT,AA] = seqcode;

if ~(aln.seqtype==3)
	error('Must be protein sequences')
else
	Seq = AA(aln.seq);
end

fid = fopen(filename,'wt');

if fid == -1, 
	error('Unable to open file.')
end

for i=1:n,
   name=char(aln.seqnames(i));
   s=Seq(i,:);
for (j=length(s):-1:1),
	if (strcmp(s(1,j),'-'));
	  s(j)=[];
	else
	  break;
	end	
end
   fprintf(fid, ['>%s\n'],name);
   fprintf(fid, ['%s\n'],char(s));
end
fclose(fid);


%%%%%%%%%%%%%
%%% SUBS  %%%
%%%%%%%%%%%%%

function [aln] = i_alignCDS2Protein(AlnNT,AlnAA)
[n,m]=size(AlnAA.seq);
aln=copyalnheader(AlnNT);
S=ones(n,m*3)*5;

SA = AlnAA.seq;
SN = AlnNT.seq;

for (i=1:n),
x=1;
y=1;
for (j=1:m),
	if ~(SA(i,j)==i_getcode4gap('PROTEIN'))
		S(i,x)=SN(i,y);
		S(i,x+1)=SN(i,y+1);
		S(i,x+2)=SN(i,y+2);
		x=x+3;
		y=y+3;
	else
		x=x+3;
	end
end
end
aln.seq = S;